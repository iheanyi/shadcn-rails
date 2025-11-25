# frozen_string_literal: true

module Shadcn
  module Rails
    module ViewHelpers
      # Helper to merge Tailwind CSS classes intelligently
      # Handles conflicting classes by keeping the last one
      def cn(*classes)
        classes.flatten.compact.join(" ").split.uniq { |c| tailwind_class_group(c) }.join(" ")
      end

      # Render a shadcn component by name
      def shadcn(component_name, **options, &block)
        component_class = "Ui::#{component_name.to_s.camelize}Component".constantize
        render(component_class.new(**options), &block)
      rescue NameError
        raise ArgumentError, "Component '#{component_name}' not found. Run `rails g shadcn:component #{component_name}` to install it."
      end

      private

      # Group Tailwind classes by their prefix to handle conflicts
      def tailwind_class_group(css_class)
        # Extract the responsive prefix and the base class
        parts = css_class.split(":")
        base = parts.last

        # Group by common prefixes
        case base
        when /^(p|px|py|pt|pb|pl|pr|ps|pe)-/
          "padding-#{$1}"
        when /^(m|mx|my|mt|mb|ml|mr|ms|me)-/
          "margin-#{$1}"
        when /^(w|min-w|max-w)-/
          "width"
        when /^(h|min-h|max-h)-/
          "height"
        when /^(text)-/
          "text-size" if base =~ /^text-(xs|sm|base|lg|xl|2xl|3xl|4xl|5xl|6xl)/
        when /^(bg)-/
          "background"
        when /^(border)-/
          "border" unless base =~ /^border-(t|b|l|r|x|y)/
        when /^(rounded)/
          "rounded"
        when /^(flex|grid|block|inline|hidden)/
          "display"
        else
          css_class
        end
      end
    end
  end
end
