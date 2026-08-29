# frozen_string_literal: true

module Shadcn
  module Rails
    class Configuration
      THEMES = %i[neutral slate zinc stone gray].freeze
      DARK_MODES = %i[class media both].freeze

      # Style preset: currently only "default" is supported
      attr_accessor :style

      # Color theme: neutral, slate, zinc, stone, gray
      attr_reader :theme

      # Whether to use CSS variables for theming
      attr_accessor :css_variables

      # Prefix for Tailwind classes (e.g., "tw-")
      attr_accessor :tailwind_prefix

      # Default radius for components
      attr_accessor :radius

      # Dark mode strategy: :class, :media, or :both
      attr_reader :dark_mode

      # Icon library to use: :lucide (default), :heroicons, etc.
      attr_accessor :icon_library

      def initialize
        @style = "default"
        @theme = :neutral
        @css_variables = true
        @tailwind_prefix = ""
        @radius = "0.5rem"
        @dark_mode = :class
        @icon_library = :lucide
      end

      def theme=(value)
        normalized = normalize_theme(value)
        raise ArgumentError, "Unknown shadcn theme: #{value.inspect}. Available themes: #{THEMES.join(', ')}" unless THEMES.include?(normalized)

        @theme = normalized
      end

      # Deprecated alias retained for existing initializers.
      def base_color
        theme
      end

      # Deprecated alias retained for existing initializers.
      def base_color=(value)
        self.theme = value
      end

      def dark_mode=(value)
        normalized = value.to_sym
        raise ArgumentError, "Unknown shadcn dark mode: #{value.inspect}. Available modes: #{DARK_MODES.join(', ')}" unless DARK_MODES.include?(normalized)

        @dark_mode = normalized
      end

      private

      def normalize_theme(value)
        value.to_s.tr("-", "_").to_sym
      end
    end
  end
end
