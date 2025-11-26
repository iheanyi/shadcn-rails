# frozen_string_literal: true

require "rails/generators"
require "rails/generators/base"

module Shadcn
  module Generators
    # Generator for switching or customizing themes
    # Usage: rails generate shadcn:theme slate
    class ThemeGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      argument :theme_name, type: :string, default: "neutral",
        banner: "theme_name"

      class_option :list, type: :boolean, default: false,
        desc: "List all available themes"

      desc "Changes the shadcn-rails theme or creates a custom theme"

      AVAILABLE_THEMES = %w[neutral slate stone zinc gray].freeze

      def validate_theme
        if options[:list]
          display_available_themes
          exit 0
        end

        unless AVAILABLE_THEMES.include?(theme_name)
          say "Error: Unknown theme '#{theme_name}'", :red
          display_available_themes
          exit 1
        end
      end

      def update_initializer
        initializer_path = "config/initializers/shadcn.rb"

        if File.exist?(initializer_path)
          gsub_file initializer_path,
            /config\.base_color = ["']?\w+["']?/,
            "config.base_color = \"#{theme_name}\""
          say "Updated initializer to use '#{theme_name}' theme", :green
        else
          say "Initializer not found. Run 'rails generate shadcn:install' first.", :yellow
        end
      end

      def update_config_file
        config_path = "config/shadcn.yml"

        if File.exist?(config_path)
          gsub_file config_path,
            /base_color: \w+/,
            "base_color: #{theme_name}"
          say "Updated shadcn.yml to use '#{theme_name}' theme", :green
        end
      end

      def update_stylesheet
        # Check for theme import in stylesheet
        stylesheet_path = "app/assets/stylesheets/application.tailwind.css"

        if File.exist?(stylesheet_path)
          content = File.read(stylesheet_path)

          # Remove existing theme import
          AVAILABLE_THEMES.each do |theme|
            next if theme == "neutral" # neutral uses base.css
            gsub_file stylesheet_path, /@import ["']shadcn\/themes\/#{theme}["'];\n?/, ""
          end

          # Add new theme import if not neutral
          unless theme_name == "neutral"
            inject_into_file stylesheet_path, after: '@import "shadcn/base";' do
              "\n@import \"shadcn/themes/#{theme_name}\";"
            end
          end

          say "Updated stylesheet with '#{theme_name}' theme", :green
        end
      end

      def display_completion_message
        say ""
        say "Theme changed to '#{theme_name}'!", :green
        say ""
        say "The following colors are now active:", :yellow
        display_theme_preview(theme_name)
        say ""
      end

      private

      def display_available_themes
        say ""
        say "Available themes:", :green
        say ""
        AVAILABLE_THEMES.each do |theme|
          say "  - #{theme}"
        end
        say ""
        say "Usage: rails generate shadcn:theme slate"
        say ""
      end

      def display_theme_preview(theme)
        case theme
        when "neutral"
          say "  Primary: Pure black/white"
          say "  Style: Clean, minimal"
        when "slate"
          say "  Primary: Cool blue-gray"
          say "  Style: Professional, corporate"
        when "stone"
          say "  Primary: Warm gray-brown"
          say "  Style: Earthy, natural"
        when "zinc"
          say "  Primary: Cool gray"
          say "  Style: Modern, sleek"
        when "gray"
          say "  Primary: True gray"
          say "  Style: Neutral, balanced"
        end
      end
    end
  end
end
