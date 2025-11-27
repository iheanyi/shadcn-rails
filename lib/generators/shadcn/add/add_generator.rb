# frozen_string_literal: true

require "rails/generators"
require "rails/generators/base"

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

      # Map component names to their files
      COMPONENT_FILES = {
        "accordion" => { component: "accordion_component.rb", controller: "accordion_controller.js" },
        "alert" => { component: "alert_component.rb", controller: nil },
        "alert_dialog" => { component: "alert_dialog_component.rb", controller: "dialog_controller.js" },
        "aspect_ratio" => { component: "aspect_ratio_component.rb", controller: nil },
        "avatar" => { component: "avatar_component.rb", controller: "avatar_controller.js" },
        "badge" => { component: "badge_component.rb", controller: nil },
        "breadcrumb" => { component: "breadcrumb_component.rb", controller: nil },
        "button" => { component: "button_component.rb", controller: nil },
        "button_group" => { component: "button_group_component.rb", controller: nil },
        "calendar" => { component: "calendar_component.rb", controller: "calendar_controller.js" },
        "card" => { component: "card_component.rb", controller: nil },
        "carousel" => { component: "carousel_component.rb", controller: "carousel_controller.js" },
        "checkbox" => { component: "checkbox_component.rb", controller: "checkbox_controller.js" },
        "collapsible" => { component: "collapsible_component.rb", controller: "collapsible_controller.js" },
        "combobox" => { component: "combobox_component.rb", controller: "combobox_controller.js" },
        "command" => { component: "command_component.rb", controller: "command_controller.js" },
        "context_menu" => { component: "context_menu_component.rb", controller: "context_menu_controller.js" },
        "date_picker" => { component: "date_picker_component.rb", controller: "date_picker_controller.js" },
        "dialog" => { component: "dialog_component.rb", controller: "dialog_controller.js" },
        "drawer" => { component: "drawer_component.rb", controller: "drawer_controller.js" },
        "dropdown_menu" => { component: "dropdown_menu_component.rb", controller: "dropdown_controller.js" },
        "field" => { component: "field_component.rb", controller: nil },
        "hover_card" => { component: "hover_card_component.rb", controller: "hover_card_controller.js" },
        "input" => { component: "input_component.rb", controller: nil },
        "input_group" => { component: "input_group_component.rb", controller: nil },
        "input_otp" => { component: "input_otp_component.rb", controller: "input_otp_controller.js" },
        "kbd" => { component: "kbd_component.rb", controller: nil },
        "label" => { component: "label_component.rb", controller: nil },
        "menubar" => { component: "menubar_component.rb", controller: "menubar_controller.js" },
        "native_select" => { component: "native_select_component.rb", controller: nil },
        "navigation_menu" => { component: "navigation_menu_component.rb", controller: "navigation_menu_controller.js" },
        "pagination" => { component: "pagination_component.rb", controller: nil },
        "popover" => { component: "popover_component.rb", controller: "popover_controller.js" },
        "progress" => { component: "progress_component.rb", controller: nil },
        "radio_group" => { component: "radio_group_component.rb", controller: "radio_group_controller.js" },
        "resizable" => { component: "resizable_panel_group_component.rb", controller: "resizable_controller.js" },
        "scroll_area" => { component: "scroll_area_component.rb", controller: "scroll_area_controller.js" },
        "select" => { component: "select_component.rb", controller: "select_controller.js" },
        "separator" => { component: "separator_component.rb", controller: nil },
        "sheet" => { component: "sheet_component.rb", controller: "sheet_controller.js" },
        "sidebar" => { component: "sidebar_component.rb", controller: "sidebar_controller.js" },
        "skeleton" => { component: "skeleton_component.rb", controller: nil },
        "slider" => { component: "slider_component.rb", controller: "slider_controller.js" },
        "spinner" => { component: "spinner_component.rb", controller: nil },
        "switch" => { component: "switch_component.rb", controller: "switch_controller.js" },
        "table" => { component: "table_component.rb", controller: nil },
        "tabs" => { component: "tabs_component.rb", controller: "tabs_controller.js" },
        "textarea" => { component: "textarea_component.rb", controller: nil },
        "toast" => { component: "toast_component.rb", controller: "toast_controller.js" },
        "toggle" => { component: "toggle_component.rb", controller: "toggle_controller.js" },
        "toggle_group" => { component: "toggle_group_component.rb", controller: "toggle_group_controller.js" },
        "tooltip" => { component: "tooltip_component.rb", controller: "tooltip_controller.js" },
        "typography" => { component: "typography_component.rb", controller: nil }
      }.freeze

      def validate_components
        if options[:list]
          display_available_components
          exit 0
        end

        if options[:all]
          @components_to_add = COMPONENT_FILES.keys
        else
          validate_requested_components
          @components_to_add = components
        end
      end

      def display_plan
        say ""
        say "Adding #{@components_to_add.length} component(s):", :green
        @components_to_add.each { |c| say "  - #{c}" }
        if include_controllers?
          controllers = @components_to_add.count { |c| COMPONENT_FILES[c][:controller] }
          say ""
          say "Including #{controllers} Stimulus controller(s)", :cyan if controllers > 0
        end
        say ""
      end

      def add_components
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
        if include_controllers?
          say "  - Stimulus controllers: app/javascript/controllers/shadcn/"
        end
        say ""
        say "These local files will take precedence over the gem's components."
        say "You can now customize them as needed."
        say ""
        if include_controllers?
          say "Note: Register the controllers in your Stimulus application:", :cyan
          say ""
          say "  // In app/javascript/controllers/index.js"
          say "  import ShadcnDialog from \"./shadcn/dialog_controller\""
          say "  application.register(\"shadcn--dialog\", ShadcnDialog)"
          say ""
        end
      end

      private

      def display_available_components
        say ""
        say "Available shadcn components:", :green
        say ""

        # Group by category
        categories = {
          "Buttons & Actions" => %w[button button_group toggle toggle_group],
          "Form Inputs" => %w[checkbox field input input_group input_otp label native_select radio_group select slider switch textarea],
          "Data Display" => %w[avatar badge card kbd progress skeleton spinner table typography aspect_ratio scroll_area],
          "Feedback" => %w[alert toast tooltip],
          "Overlays" => %w[alert_dialog dialog drawer dropdown_menu hover_card popover sheet context_menu],
          "Navigation" => %w[accordion breadcrumb collapsible menubar navigation_menu pagination separator tabs resizable],
          "Advanced" => %w[calendar carousel combobox command date_picker sidebar]
        }

        categories.each do |category, comps|
          available = comps & COMPONENT_FILES.keys
          next if available.empty?

          say "  #{category}:", :yellow
          available.each do |name|
            controller_info = COMPONENT_FILES[name][:controller] ? " ✦" : ""
            say "    #{name}#{controller_info}"
          end
          say ""
        end

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

        invalid = components - COMPONENT_FILES.keys
        if invalid.any?
          say "Error: Unknown component(s): #{invalid.join(', ')}", :red
          say ""
          display_available_components
          exit 1
        end
      end

      def add_component(name)
        files = COMPONENT_FILES[name]

        # Copy Ruby component
        copy_ruby_component(name, files[:component])

        # Copy ERB template if it exists
        copy_erb_template(name, files[:component])

        # Copy Stimulus controller if requested and exists
        if include_controllers? && files[:controller]
          copy_stimulus_controller(name, files[:controller])
        end
      end

      def copy_ruby_component(name, filename)
        source_path = gem_component_path(filename)
        destination_path = File.join(options[:path], "shadcn", filename)

        if File.exist?(destination_path) && !options[:force]
          say "  skip  #{filename} (already exists, use --force to overwrite)", :yellow
        else
          copy_file source_path, destination_path
          say "  create  #{filename}", :green
        end
      end

      def copy_erb_template(name, ruby_filename)
        erb_filename = ruby_filename.sub(/\.rb$/, ".html.erb")
        source_path = gem_component_path(erb_filename)

        # Only copy if the template exists
        return unless File.exist?(source_path)

        destination_path = File.join(options[:path], "shadcn", erb_filename)

        if File.exist?(destination_path) && !options[:force]
          say "  skip  #{erb_filename} (already exists, use --force to overwrite)", :yellow
        else
          copy_file source_path, destination_path
          say "  create  #{erb_filename}", :green
        end
      end

      def copy_stimulus_controller(name, filename)
        source_path = gem_controller_path(filename)
        destination_path = "app/javascript/controllers/shadcn/#{filename}"

        # Create directory if it doesn't exist
        directory = File.dirname(destination_path)
        empty_directory directory unless File.directory?(directory)

        if File.exist?(destination_path) && !options[:force]
          say "  skip  #{filename} (already exists, use --force to overwrite)", :yellow
        else
          copy_file source_path, destination_path
          say "  create  #{filename}", :green
        end
      end

      def gem_component_path(filename)
        File.join(gem_root, "app/components/shadcn", filename)
      end

      def gem_controller_path(filename)
        File.join(gem_root, "app/assets/javascripts/shadcn/controllers", filename)
      end

      def gem_root
        @gem_root ||= File.expand_path("../../../../..", __FILE__)
      end

      def include_controllers?
        options[:include_controllers] && !options[:exclude_controllers]
      end
    end
  end
end
