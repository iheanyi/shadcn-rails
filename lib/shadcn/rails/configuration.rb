# frozen_string_literal: true

module Shadcn
  module Rails
    class Configuration
      # Style preset: currently only "default" is supported
      attr_accessor :style

      # Base color theme: neutral, stone, zinc, gray, slate
      attr_accessor :base_color

      # Whether to use CSS variables for theming
      attr_accessor :css_variables

      # Prefix for Tailwind classes (e.g., "tw-")
      attr_accessor :tailwind_prefix

      # Default radius for components
      attr_accessor :radius

      # Dark mode strategy: :class, :media, or :selector
      attr_accessor :dark_mode

      # Icon library to use: :lucide (default), :heroicons, etc.
      attr_accessor :icon_library

      # Component aliases (for overriding default component classes)
      attr_reader :component_aliases

      # Additional themes (name => css_variables hash)
      attr_reader :themes

      def initialize
        @style = "default"
        @base_color = "neutral"
        @css_variables = true
        @tailwind_prefix = ""
        @radius = "0.5rem"
        @dark_mode = :class
        @icon_library = :lucide
        @component_aliases = {}
        @themes = {}
      end

      # Register a custom component alias
      def alias_component(name, klass)
        @component_aliases[name.to_sym] = klass
      end

      # Register a custom theme
      def register_theme(name, variables)
        @themes[name.to_sym] = variables
      end

      # Get all CSS variables for a theme
      def css_variables_for_theme(theme = :default)
        base_variables.merge(@themes[theme] || {})
      end

      # Default CSS variables matching shadcn/ui
      def base_variables
        THEME_VARIABLES[@base_color.to_sym] || THEME_VARIABLES[:neutral]
      end

      # Available base colors with their CSS variable values
      THEME_VARIABLES = {
        neutral: {
          # Light mode
          background: "0 0% 100%",
          foreground: "0 0% 3.9%",
          card: "0 0% 100%",
          card_foreground: "0 0% 3.9%",
          popover: "0 0% 100%",
          popover_foreground: "0 0% 3.9%",
          primary: "0 0% 9%",
          primary_foreground: "0 0% 98%",
          secondary: "0 0% 96.1%",
          secondary_foreground: "0 0% 9%",
          muted: "0 0% 96.1%",
          muted_foreground: "0 0% 45.1%",
          accent: "0 0% 96.1%",
          accent_foreground: "0 0% 9%",
          destructive: "0 84.2% 60.2%",
          destructive_foreground: "0 0% 98%",
          border: "0 0% 89.8%",
          input: "0 0% 89.8%",
          ring: "0 0% 3.9%",
          radius: "0.5rem",
          # Chart colors
          chart_1: "12 76% 61%",
          chart_2: "173 58% 39%",
          chart_3: "197 37% 24%",
          chart_4: "43 74% 66%",
          chart_5: "27 87% 67%"
        },
        slate: {
          background: "0 0% 100%",
          foreground: "222.2 84% 4.9%",
          card: "0 0% 100%",
          card_foreground: "222.2 84% 4.9%",
          popover: "0 0% 100%",
          popover_foreground: "222.2 84% 4.9%",
          primary: "222.2 47.4% 11.2%",
          primary_foreground: "210 40% 98%",
          secondary: "210 40% 96.1%",
          secondary_foreground: "222.2 47.4% 11.2%",
          muted: "210 40% 96.1%",
          muted_foreground: "215.4 16.3% 46.9%",
          accent: "210 40% 96.1%",
          accent_foreground: "222.2 47.4% 11.2%",
          destructive: "0 84.2% 60.2%",
          destructive_foreground: "210 40% 98%",
          border: "214.3 31.8% 91.4%",
          input: "214.3 31.8% 91.4%",
          ring: "222.2 84% 4.9%",
          radius: "0.5rem",
          chart_1: "12 76% 61%",
          chart_2: "173 58% 39%",
          chart_3: "197 37% 24%",
          chart_4: "43 74% 66%",
          chart_5: "27 87% 67%"
        },
        stone: {
          background: "0 0% 100%",
          foreground: "20 14.3% 4.1%",
          card: "0 0% 100%",
          card_foreground: "20 14.3% 4.1%",
          popover: "0 0% 100%",
          popover_foreground: "20 14.3% 4.1%",
          primary: "24 9.8% 10%",
          primary_foreground: "60 9.1% 97.8%",
          secondary: "60 4.8% 95.9%",
          secondary_foreground: "24 9.8% 10%",
          muted: "60 4.8% 95.9%",
          muted_foreground: "25 5.3% 44.7%",
          accent: "60 4.8% 95.9%",
          accent_foreground: "24 9.8% 10%",
          destructive: "0 84.2% 60.2%",
          destructive_foreground: "60 9.1% 97.8%",
          border: "20 5.9% 90%",
          input: "20 5.9% 90%",
          ring: "20 14.3% 4.1%",
          radius: "0.5rem",
          chart_1: "12 76% 61%",
          chart_2: "173 58% 39%",
          chart_3: "197 37% 24%",
          chart_4: "43 74% 66%",
          chart_5: "27 87% 67%"
        },
        gray: {
          background: "0 0% 100%",
          foreground: "224 71.4% 4.1%",
          card: "0 0% 100%",
          card_foreground: "224 71.4% 4.1%",
          popover: "0 0% 100%",
          popover_foreground: "224 71.4% 4.1%",
          primary: "220.9 39.3% 11%",
          primary_foreground: "210 20% 98%",
          secondary: "220 14.3% 95.9%",
          secondary_foreground: "220.9 39.3% 11%",
          muted: "220 14.3% 95.9%",
          muted_foreground: "220 8.9% 46.1%",
          accent: "220 14.3% 95.9%",
          accent_foreground: "220.9 39.3% 11%",
          destructive: "0 84.2% 60.2%",
          destructive_foreground: "210 20% 98%",
          border: "220 13% 91%",
          input: "220 13% 91%",
          ring: "224 71.4% 4.1%",
          radius: "0.5rem",
          chart_1: "12 76% 61%",
          chart_2: "173 58% 39%",
          chart_3: "197 37% 24%",
          chart_4: "43 74% 66%",
          chart_5: "27 87% 67%"
        },
        zinc: {
          background: "0 0% 100%",
          foreground: "240 10% 3.9%",
          card: "0 0% 100%",
          card_foreground: "240 10% 3.9%",
          popover: "0 0% 100%",
          popover_foreground: "240 10% 3.9%",
          primary: "240 5.9% 10%",
          primary_foreground: "0 0% 98%",
          secondary: "240 4.8% 95.9%",
          secondary_foreground: "240 5.9% 10%",
          muted: "240 4.8% 95.9%",
          muted_foreground: "240 3.8% 46.1%",
          accent: "240 4.8% 95.9%",
          accent_foreground: "240 5.9% 10%",
          destructive: "0 84.2% 60.2%",
          destructive_foreground: "0 0% 98%",
          border: "240 5.9% 90%",
          input: "240 5.9% 90%",
          ring: "240 5.9% 10%",
          radius: "0.5rem",
          chart_1: "12 76% 61%",
          chart_2: "173 58% 39%",
          chart_3: "197 37% 24%",
          chart_4: "43 74% 66%",
          chart_5: "27 87% 67%"
        }
      }.freeze

      # Dark mode variants for each theme
      DARK_THEME_VARIABLES = {
        neutral: {
          background: "0 0% 3.9%",
          foreground: "0 0% 98%",
          card: "0 0% 3.9%",
          card_foreground: "0 0% 98%",
          popover: "0 0% 3.9%",
          popover_foreground: "0 0% 98%",
          primary: "0 0% 98%",
          primary_foreground: "0 0% 9%",
          secondary: "0 0% 14.9%",
          secondary_foreground: "0 0% 98%",
          muted: "0 0% 14.9%",
          muted_foreground: "0 0% 63.9%",
          accent: "0 0% 14.9%",
          accent_foreground: "0 0% 98%",
          destructive: "0 62.8% 30.6%",
          destructive_foreground: "0 0% 98%",
          border: "0 0% 14.9%",
          input: "0 0% 14.9%",
          ring: "0 0% 83.1%",
          chart_1: "220 70% 50%",
          chart_2: "160 60% 45%",
          chart_3: "30 80% 55%",
          chart_4: "280 65% 60%",
          chart_5: "340 75% 55%"
        },
        slate: {
          background: "222.2 84% 4.9%",
          foreground: "210 40% 98%",
          card: "222.2 84% 4.9%",
          card_foreground: "210 40% 98%",
          popover: "222.2 84% 4.9%",
          popover_foreground: "210 40% 98%",
          primary: "210 40% 98%",
          primary_foreground: "222.2 47.4% 11.2%",
          secondary: "217.2 32.6% 17.5%",
          secondary_foreground: "210 40% 98%",
          muted: "217.2 32.6% 17.5%",
          muted_foreground: "215 20.2% 65.1%",
          accent: "217.2 32.6% 17.5%",
          accent_foreground: "210 40% 98%",
          destructive: "0 62.8% 30.6%",
          destructive_foreground: "210 40% 98%",
          border: "217.2 32.6% 17.5%",
          input: "217.2 32.6% 17.5%",
          ring: "212.7 26.8% 83.9%",
          chart_1: "220 70% 50%",
          chart_2: "160 60% 45%",
          chart_3: "30 80% 55%",
          chart_4: "280 65% 60%",
          chart_5: "340 75% 55%"
        },
        stone: {
          background: "20 14.3% 4.1%",
          foreground: "60 9.1% 97.8%",
          card: "20 14.3% 4.1%",
          card_foreground: "60 9.1% 97.8%",
          popover: "20 14.3% 4.1%",
          popover_foreground: "60 9.1% 97.8%",
          primary: "60 9.1% 97.8%",
          primary_foreground: "24 9.8% 10%",
          secondary: "12 6.5% 15.1%",
          secondary_foreground: "60 9.1% 97.8%",
          muted: "12 6.5% 15.1%",
          muted_foreground: "24 5.4% 63.9%",
          accent: "12 6.5% 15.1%",
          accent_foreground: "60 9.1% 97.8%",
          destructive: "0 62.8% 30.6%",
          destructive_foreground: "60 9.1% 97.8%",
          border: "12 6.5% 15.1%",
          input: "12 6.5% 15.1%",
          ring: "24 5.7% 82.9%",
          chart_1: "220 70% 50%",
          chart_2: "160 60% 45%",
          chart_3: "30 80% 55%",
          chart_4: "280 65% 60%",
          chart_5: "340 75% 55%"
        },
        gray: {
          background: "224 71.4% 4.1%",
          foreground: "210 20% 98%",
          card: "224 71.4% 4.1%",
          card_foreground: "210 20% 98%",
          popover: "224 71.4% 4.1%",
          popover_foreground: "210 20% 98%",
          primary: "210 20% 98%",
          primary_foreground: "220.9 39.3% 11%",
          secondary: "215 27.9% 16.9%",
          secondary_foreground: "210 20% 98%",
          muted: "215 27.9% 16.9%",
          muted_foreground: "217.9 10.6% 64.9%",
          accent: "215 27.9% 16.9%",
          accent_foreground: "210 20% 98%",
          destructive: "0 62.8% 30.6%",
          destructive_foreground: "210 20% 98%",
          border: "215 27.9% 16.9%",
          input: "215 27.9% 16.9%",
          ring: "216 12.2% 83.9%",
          chart_1: "220 70% 50%",
          chart_2: "160 60% 45%",
          chart_3: "30 80% 55%",
          chart_4: "280 65% 60%",
          chart_5: "340 75% 55%"
        },
        zinc: {
          background: "240 10% 3.9%",
          foreground: "0 0% 98%",
          card: "240 10% 3.9%",
          card_foreground: "0 0% 98%",
          popover: "240 10% 3.9%",
          popover_foreground: "0 0% 98%",
          primary: "0 0% 98%",
          primary_foreground: "240 5.9% 10%",
          secondary: "240 3.7% 15.9%",
          secondary_foreground: "0 0% 98%",
          muted: "240 3.7% 15.9%",
          muted_foreground: "240 5% 64.9%",
          accent: "240 3.7% 15.9%",
          accent_foreground: "0 0% 98%",
          destructive: "0 62.8% 30.6%",
          destructive_foreground: "0 0% 98%",
          border: "240 3.7% 15.9%",
          input: "240 3.7% 15.9%",
          ring: "240 4.9% 83.9%",
          chart_1: "220 70% 50%",
          chart_2: "160 60% 45%",
          chart_3: "30 80% 55%",
          chart_4: "280 65% 60%",
          chart_5: "340 75% 55%"
        }
      }.freeze
    end
  end
end
