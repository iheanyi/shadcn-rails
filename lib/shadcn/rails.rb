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
require_relative "form_builder"
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

      # Generate complete CSS for themes
      # Supports three dark mode strategies:
      # - :media - uses @media (prefers-color-scheme: dark) for automatic detection
      # - :class - uses .dark class selector (default for manual toggling)
      # - :both - includes both media query AND .dark class for maximum flexibility
      def theme_css
        css = configured_theme_css
        root_block = apply_radius(extract_css_block(css, ":root"))
        dark_block = extract_css_block(css, ".dark")

        [root_block, dark_mode_css(dark_block)].compact.join("\n\n")
      end

      def define_component_aliases
        define_component_alias(:Component, :BaseComponent)

        Registry.each do |unit|
          unit.ruby_files.each do |path|
            component_name = File.basename(path, ".rb").camelize.to_sym
            public_name = component_name.to_s.delete_suffix("Component").to_sym
            define_component_alias(public_name, component_name)
          end
        end
      end

      def resolve_component_alias(name)
        define_component_alias(:Component, :BaseComponent) if name == :Component

        component_name = :"#{name}Component"
        define_component_alias(name, component_name)
      end

      def theme_path(theme = configuration.theme)
        if theme == :neutral
          File.expand_path("../../app/assets/stylesheets/shadcn/base.css", __dir__)
        else
          File.expand_path("../../app/assets/stylesheets/shadcn/themes/#{theme}.css", __dir__)
        end
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

      def configured_theme_css
        File.read(theme_path)
      rescue Errno::ENOENT
        raise Error, "Theme CSS not found for #{configuration.theme.inspect}"
      end

      def extract_css_block(css, selector)
        pattern = /^#{Regexp.escape(selector)}\s*\{.*?^\}/m
        css[pattern] || raise(Error, "Theme CSS for #{configuration.theme.inspect} is missing #{selector}")
      end

      def apply_radius(root_block)
        radius = configuration.radius
        return root_block if radius.blank?

        if root_block.match?(/--radius:\s*[^;]+;/)
          root_block.sub(/--radius:\s*[^;]+;/, "--radius: #{radius};")
        else
          root_block.sub(/\n\}\s*\z/, "\n  --radius: #{radius};\n}")
        end
      end

      def dark_mode_css(dark_block)
        case configuration.dark_mode
        when :media
          dark_media_block(dark_block)
        when :both
          [dark_media_block(dark_block), dark_block].join("\n\n")
        else
          dark_block
        end
      end

      def dark_media_block(dark_block)
        <<~CSS.strip
          @media (prefers-color-scheme: dark) {
          #{dark_block.sub(/^\.dark/, ":root").lines.map { |line| "  #{line}" }.join.chomp}
          }
        CSS
      end

      def define_component_alias(public_name, component_name)
        return if Shadcn.const_defined?(public_name, false)
        return unless Shadcn.const_defined?(component_name, false)

        Shadcn.const_set(public_name, Shadcn.const_get(component_name, false))
      end
    end
  end

  def self.const_missing(name)
    component = Rails.resolve_component_alias(name)
    return component if component

    super
  end
end

# Auto-require components when in Rails
if defined?(::Rails)
  require_relative "rails/engine"
end
