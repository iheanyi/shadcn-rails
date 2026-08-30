# frozen_string_literal: true

require "rails/generators"
require "rails/generators/base"
require "shadcn/rails/registry"
require "set"

module Shadcn
  module Generators
    # Generator for adding shadcn components to your application
    # Usage: rails generate shadcn:add button
    #        rails generate shadcn:add button card dialog
    #        rails generate shadcn:add button --exclude-controllers
    class AddGenerator < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      argument :components, type: :array, default: [], banner: "component [component ...]"

      class_option :all, type: :boolean, default: false,
        desc: "Add all available components"
      class_option :list, type: :boolean, default: false,
        desc: "List all available components"
      class_option :include_controllers, type: :boolean, default: true,
        desc: "Include Stimulus controllers (default: true)"
      class_option :exclude_controllers, type: :boolean, default: false,
        desc: "Exclude Stimulus controllers"
      class_option :force, type: :boolean, default: false,
        desc: "Overwrite existing files"
      class_option :path, type: :string, default: "app/components",
        desc: "Path for components (default: app/components)"

      desc "Adds shadcn components to your application for customization"

      def validate_components
        if options[:list]
          display_available_components
          exit 0
        end

        if options[:all]
          @components_to_add = Shadcn::Rails::Registry.keys
        else
          validate_requested_components
          @components_to_add = normalized_components
        end
      end

      def display_plan
        say ""
        say "Adding #{@components_to_add.length} component(s):", :green
        @components_to_add.each { |c| say "  - #{c}" }
        if include_controllers?
          controllers = @components_to_add.sum { |c| component_unit(c).controllers.length }
          say ""
          say "Including #{controllers} Stimulus controller(s)", :cyan if controllers > 0
        end
        say ""
      end

      def add_components
        @added_component_units = Set.new

        @components_to_add.each do |component|
          add_component(component)
        end
      end

      def display_post_add_message
        say ""
        say "=" * 60, :green
        say "  Components added successfully!", :green
        say "=" * 60, :green
        say ""
        say "Components are now in your application:", :yellow
        say "  - Ruby components: #{options[:path]}/shadcn/"
        if copied_controllers?
          say "  - Stimulus controllers: app/javascript/controllers/shadcn/"
        end
        say ""
        say "These local files will take precedence over the gem's components."
        say "You can now customize them as needed."
        say ""
        if copied_controllers?
          say "Note: Register copied controllers in your Stimulus application as needed.", :cyan
          say ""
          copied_controller_files.each do |filename|
            controller_name = filename.sub(/_controller\.js\z/, "").tr("_", "-")
            class_name = "Shadcn#{filename.sub(/_controller\.js\z/, "").camelize}"
            say "  import #{class_name} from \"./shadcn/#{filename.sub(/\.js\z/, "")}\""
            say "  application.register(\"shadcn--#{controller_name}\", #{class_name})"
          end
          say ""
        end
      end

      private

      def display_available_components
        say ""
        say "Available shadcn components:", :green
        say ""

        Shadcn::Rails::Registry.keys.each do |name|
          controller_info = component_unit(name).controllers.any? ? " ✦" : ""
          say "  #{name}#{controller_info}"
        end
        say ""

        say "  ✦ = includes Stimulus controller", :cyan
        say ""
        say "Usage:", :yellow
        say "  rails generate shadcn:add button"
        say "  rails generate shadcn:add button card dialog"
        say "  rails generate shadcn:add --all"
        say ""
      end

      def validate_requested_components
        if components.empty?
          say "Error: Please specify at least one component or use --all", :red
          say ""
          display_available_components
          exit 1
        end

        invalid = components.reject { |component| Shadcn::Rails::Registry.key?(component) }
        if invalid.any?
          say "Error: Unknown component(s): #{invalid.join(', ')}", :red
          say ""
          display_available_components
          exit 1
        end
      end

      def add_component(name)
        name = Shadcn::Rails::Registry.normalize_name(name)
        return if @added_component_units.include?(name)

        @added_component_units.add(name)
        unit = component_unit(name)

        (unit.ruby_files + unit.templates).each do |path|
          copy_component_file(path)
        end

        component_dependencies(unit).each do |dependency|
          add_component(dependency)
        end

        if include_controllers?
          (unit.controllers + file_dependencies(unit)).each do |path|
            copy_javascript_file(path)
          end
        end

        unit.css_sidecars.each do |path|
          copy_css_sidecar(path)
        end
      end

      def copy_component_file(path)
        source_path = Shadcn::Rails::Registry.gem_path(path)
        destination_path = File.join(options[:path], "shadcn", File.basename(path))

        copy_registry_file(source_path, destination_path, File.basename(path))
      end

      def copied_controllers?
        include_controllers? && copied_controller_files.any?
      end

      def copied_controller_files
        @copied_controller_files ||= @components_to_add
          .flat_map { |component| component_unit(component).controllers }
          .map { |path| File.basename(path) }
          .uniq
      end

      def normalized_components
        components.map { |component| Shadcn::Rails::Registry.normalize_name(component) }.uniq
      end

      def copy_javascript_file(path)
        source_path = compiled_javascript_source_path(path)
        destination_path = path.sub(%r{\Aapp/assets/javascripts/shadcn/controllers/}, "app/javascript/controllers/shadcn/")
          .sub(%r{\Aapp/assets/javascripts/shadcn/utils/}, "app/javascript/controllers/shadcn/utils/")
        display_name = destination_path.sub(%r{\Aapp/javascript/controllers/shadcn/}, "")

        copy_registry_file(source_path, destination_path, display_name) do |content|
          content.gsub(%r{from\s+["']\.\./utils/([^"']+)["']}) do
            %(from "./utils/#{Regexp.last_match(1)}")
          end
        end
      end

      def compiled_javascript_source_path(path)
        compiled_path = path.sub(%r{\Aapp/assets/javascripts/shadcn/}, "dist/")
        Shadcn::Rails::Registry.gem_path(compiled_path)
      end

      def copy_css_sidecar(path)
        source_path = Shadcn::Rails::Registry.gem_path(path)
        destination_path = path

        copy_registry_file(source_path, destination_path, File.basename(path))
      end

      def copy_registry_file(source_path, destination_path, display_name)
        if destination_file_exists?(destination_path) && !options[:force]
          say "  skip  #{display_name} (already exists, use --force to overwrite)", :yellow
        else
          content = File.read(source_path)
          content = yield(content) if block_given?
          create_file destination_path, content
          say "  create  #{display_name}", :green
        end
      end

      def component_unit(name)
        Shadcn::Rails::Registry.fetch(name)
      end

      def component_dependencies(unit)
        unit.depends_on.select { |dependency| Shadcn::Rails::Registry.key?(dependency) }
      end

      def file_dependencies(unit)
        unit.depends_on.reject { |dependency| Shadcn::Rails::Registry.key?(dependency) }
      end

      def destination_file_exists?(path)
        File.exist?(File.expand_path(path, destination_root))
      end

      def include_controllers?
        options[:include_controllers] && !options[:exclude_controllers]
      end
    end
  end
end
