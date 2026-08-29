# frozen_string_literal: true

require "view_component"
require "active_support/all"

# Try to load tailwind_merge, fall back to custom merger if not available
begin
  require "tailwind_merge"
  TAILWIND_MERGE_AVAILABLE = true
rescue LoadError
  TAILWIND_MERGE_AVAILABLE = false
end

require_relative "rails/version"
require_relative "rails/configuration"
require_relative "rails/class_merger"
require_relative "rails/registry"
require_relative "rails/helpers/class_name_helper"
require_relative "rails/helpers/component_helper"
require_relative "rails/helpers/pagination_helper"
require_relative "rails/engine"

module Shadcn
  module Rails
    class Error < StandardError; end

    class << self
      # Access the configuration
      def configuration
        @configuration ||= Configuration.new
      end

      # TailwindMerge instance (singleton)
      def tailwind_merger
        @tailwind_merger ||= TailwindMerge::Merger.new if TAILWIND_MERGE_AVAILABLE
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

        # Validate name contains only lowercase letters and underscores (security hardening)
        unless name.to_s.match?(/\A[a-z_]+\z/)
          raise Error, "Invalid component name format: #{name}. Names must contain only lowercase letters and underscores."
        end

        component_name = "Shadcn::#{name.to_s.camelize}Component"
        component_name.constantize
      rescue NameError
        raise Error, "Unknown component: #{name}. Available components: #{available_components.join(', ')}"
      end

      # List all available components
      def available_components
        Registry.keys.map(&:to_sym)
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
      # Uses tailwind_merge gem if available, falls back to custom ClassMerger
      # @param args [Array] Classes to merge (strings, hashes, arrays, or nil)
      # @return [String] Merged class string with conflicts resolved
      def cn(*args)
        # Flatten and filter the arguments first
        classes = flatten_class_args(args)
        class_string = classes.join(" ")

        if tailwind_merger
          tailwind_merger.merge(class_string)
        else
          ClassMerger.merge(*args)
        end
      end

      private

      # Flatten nested arrays and handle conditional hashes for cn()
      def flatten_class_args(args)
        args.flat_map do |arg|
          case arg
          when nil, false
            []
          when String
            arg.split
          when Array
            flatten_class_args(arg)
          when Hash
            arg.filter_map { |klass, condition| klass.to_s if condition }
          else
            arg.to_s.split
          end
        end
      end
    end
  end
end

# Auto-require components when in Rails
if defined?(::Rails)
  require_relative "rails/engine"
end
