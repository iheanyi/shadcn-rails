# frozen_string_literal: true

require "rails/generators"
require "rails/generators/base"

module Shadcn
  module Generators
    # Generator for installing shadcn-rails in a Rails application
    # Usage: rails generate shadcn:install
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      class_option :theme, type: :string, default: "neutral",
        desc: "Base color theme (neutral, slate, stone, zinc, gray)"
      class_option :css_variables, type: :boolean, default: true,
        desc: "Use CSS variables for theming"
      class_option :dark_mode, type: :string, default: "class",
        desc: "Dark mode strategy (class, media, both)"
      class_option :skip_tailwind, type: :boolean, default: false,
        desc: "Skip Tailwind CSS configuration"

      desc "Installs shadcn-rails and configures your application"

      def create_initializer
        template "initializer.rb.tt", "config/initializers/shadcn.rb"
      end

      def create_config_file
        template "shadcn.yml.tt", "config/shadcn.yml"
      end

      def add_stylesheet
        return if options[:skip_tailwind]

        if File.exist?("app/assets/stylesheets/application.tailwind.css")
          inject_into_file "app/assets/stylesheets/application.tailwind.css", before: "@tailwind base;" do
            "/* shadcn-rails styles */\n@import \"shadcn/base\";\n@import \"shadcn/components\";\n\n"
          end
        elsif File.exist?("app/assets/stylesheets/application.css")
          append_to_file "app/assets/stylesheets/application.css" do
            "\n/*\n *= require shadcn/base\n *= require shadcn/components\n */\n"
          end
        else
          say "Could not find application stylesheet. Please manually import shadcn styles.", :yellow
        end
      end

      def configure_tailwind
        return if options[:skip_tailwind]
        return unless File.exist?("tailwind.config.js")

        inject_into_file "tailwind.config.js", after: "content: [" do
          "\n    './app/components/**/*.{rb,html,erb}',\n    './app/views/**/*.{html,erb}',"
        end

        say "Updated tailwind.config.js to include component paths", :green
      end

      def setup_stimulus_controllers
        if importmap?
          setup_importmap
        elsif using_esbuild? || using_webpack?
          setup_bundler
        else
          say "Could not detect JavaScript bundler. Please manually configure Stimulus controllers.", :yellow
        end
      end

      def display_post_install_message
        say ""
        say "=" * 60, :green
        say "  shadcn-rails has been installed!", :green
        say "=" * 60, :green
        say ""
        say "Next steps:", :yellow
        say "  1. Ensure Tailwind CSS is configured with the shadcn theme"
        say "  2. Import the Stimulus controllers in your application"
        say "  3. Start using components in your views:"
        say ""
        say "     <%= render Shadcn::ButtonComponent.new(variant: :primary) do %>"
        say "       Click me"
        say "     <% end %>"
        say ""
        say "Theming:", :yellow
        say "  Override CSS variables in your stylesheet to customize the theme:"
        say ""
        say "     :root {"
        say "       --radius: 0.75rem;          /* Adjust border radius */"
        say "       --primary: 221 83% 53%;     /* Custom primary color */"
        say "     }"
        say ""
        say "  For Tailwind CSS v4, also import the theme file:"
        say ""
        say "     @import \"shadcn/tailwind-v4\";"
        say ""
        say "To add individual components to your app for customization:"
        say ""
        say "  rails generate shadcn:add button"
        say "  rails generate shadcn:add --list"
        say ""
        say "For more information, visit: https://github.com/iheanyi/shadcn-rails"
        say ""
      end

      private

      def importmap?
        File.exist?("config/importmap.rb")
      end

      def using_esbuild?
        File.exist?("esbuild.config.mjs") ||
          (File.exist?("package.json") && File.read("package.json").include?("esbuild"))
      end

      def using_webpack?
        File.exist?("webpack.config.js") ||
          (File.exist?("package.json") && File.read("package.json").include?("webpack"))
      end

      def setup_importmap
        append_to_file "config/importmap.rb" do
          <<~RUBY

            # shadcn-rails Stimulus controllers
            pin "shadcn", to: "shadcn/index.js"
          RUBY
        end

        # Update application.js to register controllers
        if File.exist?("app/javascript/controllers/application.js")
          append_to_file "app/javascript/controllers/application.js" do
            <<~JS

              // Import and register shadcn-rails controllers
              import { registerShadcnControllers } from "shadcn"
              registerShadcnControllers(application)
            JS
          end
        end

        say "Configured importmap for shadcn-rails", :green
      end

      def setup_bundler
        # Add to package.json dependencies
        if File.exist?("package.json")
          say "Please install the npm package and add to your JavaScript entry point:", :yellow
          say ""
          say "  npm install shadcn-rails-stimulus"
          say ""
          say "  // In your JavaScript entry point:"
          say "  import { registerShadcnControllers } from 'shadcn-rails-stimulus'"
          say "  registerShadcnControllers(application)"
          say ""
          say "For CSS (if using cssbundling), import in your stylesheet:", :yellow
          say ""
          say "  @import 'shadcn-rails-stimulus/styles/base';"
          say "  @import 'shadcn-rails-stimulus/styles/tailwind-v4';  /* For Tailwind v4 */"
          say ""
        end
      end
    end
  end
end
