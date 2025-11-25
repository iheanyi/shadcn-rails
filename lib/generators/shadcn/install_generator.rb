# frozen_string_literal: true

require "rails/generators"
require "rails/generators/base"

module Shadcn
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    class_option :skip_tailwind, type: :boolean, default: false, desc: "Skip Tailwind CSS configuration"
    class_option :components_path, type: :string, default: "app/components/ui", desc: "Path to install components"

    desc "Install shadcn-rails and configure your Rails application"

    def create_components_directory
      empty_directory options[:components_path]
      say_status :create, options[:components_path], :green
    end

    def create_base_component
      template "base_component.rb.tt", "#{options[:components_path]}/base_component.rb"
    end

    def create_application_component
      return if File.exist?("app/components/application_component.rb")

      template "application_component.rb.tt", "app/components/application_component.rb"
    end

    def configure_tailwind
      return if options[:skip_tailwind]

      if File.exist?("config/tailwind.config.js")
        inject_tailwind_config
      else
        create_tailwind_config
      end
    end

    def create_css_file
      return if options[:skip_tailwind]

      template "shadcn.css.tt", "app/assets/stylesheets/shadcn.css"
    end

    def create_initializer
      template "initializer.rb.tt", "config/initializers/shadcn.rb"
    end

    def create_helpers_concern
      template "component_helpers.rb.tt", "app/helpers/concerns/shadcn_helpers.rb"
    end

    def add_helper_to_application_helper
      return unless File.exist?("app/helpers/application_helper.rb")

      inject_into_file "app/helpers/application_helper.rb", after: "module ApplicationHelper\n" do
        "  include ShadcnHelpers\n"
      end
    rescue StandardError
      say_status :skip, "Could not inject ShadcnHelpers into ApplicationHelper", :yellow
    end

    def display_post_install_message
      say ""
      say "🎉 shadcn-rails has been installed successfully!", :green
      say ""
      say "Next steps:", :cyan
      say "  1. Make sure you have view_component gem installed"
      say "  2. Add `@import 'shadcn';` to your application.css (or application.tailwind.css)"
      say "  3. Install components with: rails g shadcn:component button"
      say ""
      say "Available components:", :cyan
      say "  #{Shadcn::Rails::AVAILABLE_COMPONENTS.join(', ')}"
      say ""
    end

    private

    def inject_tailwind_config
      say_status :info, "Updating existing Tailwind configuration", :blue

      # Add shadcn color configuration
      content = File.read("config/tailwind.config.js")

      unless content.include?("shadcn")
        # Inject content path for components
        if content.include?("content:")
          inject_into_file "config/tailwind.config.js", after: "content: [" do
            "\n    './app/components/**/*.{rb,html,erb}',\n    './app/components/**/*.html.erb',"
          end
        end

        # Inject theme extensions
        if content.include?("theme:")
          say_status :info, "Please manually add shadcn theme variables to your Tailwind config", :yellow
        end
      end
    end

    def create_tailwind_config
      template "tailwind.config.js.tt", "config/tailwind.config.js"
    end
  end
end
