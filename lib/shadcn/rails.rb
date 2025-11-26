# frozen_string_literal: true

require "view_component"
require "active_support/all"

require_relative "rails/version"
require_relative "rails/configuration"
require_relative "rails/class_merger"
require_relative "rails/helpers/class_name_helper"
require_relative "rails/helpers/component_helper"
require_relative "rails/engine"

module Shadcn
  module Rails
    class Error < StandardError; end

    class << self
      # Access the configuration
      def configuration
        @configuration ||= Configuration.new
      end

      # Configure the gem
      # @yield [Configuration]
      def configure
        yield(configuration)
      end

      # Reset configuration to defaults
      def reset_configuration!
        @configuration = Configuration.new
      end

      # Get a component class by name
      # Supports aliases defined in configuration
      #
      # @param name [Symbol, String] Component name
      # @return [Class] Component class
      def component_for(name)
        name = name.to_sym
        return configuration.component_aliases[name] if configuration.component_aliases.key?(name)

        component_name = "Shadcn::#{name.to_s.camelize}Component"
        component_name.constantize
      rescue NameError
        raise Error, "Unknown component: #{name}. Available components: #{available_components.join(', ')}"
      end

      # List all available components
      def available_components
        @available_components ||= Dir[File.join(__dir__, "../../app/components/shadcn/*_component.rb")].map do |file|
          File.basename(file, "_component.rb").to_sym
        end
      end

      # Generate CSS variables for the current theme
      def css_variables(theme: :light)
        vars = if theme == :dark
          Configuration::DARK_THEME_VARIABLES[configuration.base_color.to_sym] || {}
        else
          configuration.base_variables
        end

        vars.map { |key, value| "--#{key.to_s.tr('_', '-')}: #{value};" }.join("\n  ")
      end

      # Generate complete CSS for themes
      # Supports three dark mode strategies:
      # - :media - uses @media (prefers-color-scheme: dark) for automatic detection
      # - :class - uses .dark class selector (default for manual toggling)
      # - :both - includes both media query AND .dark class for maximum flexibility
      def theme_css
        light_vars = css_variables(theme: :light)
        dark_vars = css_variables(theme: :dark)
        mode = configuration.dark_mode

        css = <<~CSS
          :root {
            #{light_vars}
          }
        CSS

        case mode
        when :media
          css += <<~CSS

            @media (prefers-color-scheme: dark) {
              :root {
                #{dark_vars}
              }
            }
          CSS
        when :both
          css += <<~CSS

            @media (prefers-color-scheme: dark) {
              :root {
                #{dark_vars}
              }
            }

            .dark {
              #{dark_vars}
            }
          CSS
        else # :class (default)
          css += <<~CSS

            .dark {
              #{dark_vars}
            }
          CSS
        end

        css
      end

      # Shorthand for the cn() class merger
      def cn(*args)
        ClassMerger.merge(*args)
      end
    end
  end
end

# Auto-require components when in Rails
if defined?(::Rails)
  require_relative "rails/engine"
end
