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

      def add_stylesheet
        return if options[:skip_tailwind]

        if File.exist?(tailwind_v4_stylesheet)
          inject_tailwind_v4_styles(tailwind_v4_stylesheet)
        elsif File.exist?(tailwind_v3_stylesheet)
          inject_tailwind_v3_styles(tailwind_v3_stylesheet)
        elsif File.exist?(application_stylesheet)
          inject_application_styles(application_stylesheet)
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
        say "     <%= render Shadcn::ButtonComponent.new(variant: :default) do %>"
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
        say "  For Tailwind CSS v4, the installer imports the theme file:"
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

      def tailwind_v4_stylesheet
        "app/assets/tailwind/application.css"
      end

      def tailwind_v3_stylesheet
        "app/assets/stylesheets/application.tailwind.css"
      end

      def application_stylesheet
        "app/assets/stylesheets/application.css"
      end

      def inject_tailwind_v4_styles(path)
        styles = <<~CSS
          @import "shadcn/base";
          @import "shadcn/components";
          @import "shadcn/tailwind-v4";
        CSS

        inject_css_imports(path, styles, after: /@import\s+["']tailwindcss["'];?\n/)
      end

      def inject_tailwind_v3_styles(path)
        styles = <<~CSS
          /* shadcn-rails styles */
          @import "shadcn/base";
          @import "shadcn/components";

        CSS

        inject_css_imports(path, styles, before: "@tailwind base;")
      end

      def inject_application_styles(path)
        content = File.read(path)

        if content.match?(/@import\s+["']tailwindcss["']/)
          inject_tailwind_v4_styles(path)
        elsif sprockets_manifest?(content)
          append_unless_present(path, "shadcn/base") do
            "\n/*\n *= require shadcn/base\n *= require shadcn/components\n */\n"
          end
        else
          append_unless_present(path, "shadcn/base") do
            <<~CSS

              /* shadcn-rails styles */
              @import "shadcn/base";
              @import "shadcn/components";
            CSS
          end
        end
      end

      def inject_css_imports(path, styles, location)
        append_unless_present(path, "shadcn/base") do
          inject_into_file path, location do
            "#{styles}\n"
          end

          nil
        end
      end

      def append_unless_present(path, marker)
        if File.read(path).include?(marker)
          say "Skipped #{path}; shadcn styles are already present", :yellow
        else
          addition = yield
          append_to_file(path, addition) if addition
          say "Updated #{path} with shadcn styles", :green
        end
      end

      def sprockets_manifest?(content)
        content.include?("*= require") || content.include?("*= link")
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
        append_importmap_pin %(pin "shadcn", to: "shadcn/index.js")
        append_importmap_pin %(pin "@floating-ui/dom", to: "https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.6.13/+esm")
        append_importmap_pin %(pin "stimulus-use", to: "https://cdn.jsdelivr.net/npm/stimulus-use@0.52.3/+esm")

        # Update application.js to register controllers
        if File.exist?("app/javascript/controllers/application.js")
          append_unless_present("app/javascript/controllers/application.js", "registerShadcnControllers") do
            <<~JS

              // Import and register shadcn-rails controllers
              import { registerShadcnControllers } from "shadcn"
              registerShadcnControllers(application)
            JS
          end
        end

        say "Configured importmap for shadcn-rails", :green
      end

      def append_importmap_pin(pin)
        append_unless_present("config/importmap.rb", pin) do
          "\n#{pin}\n"
        end
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
