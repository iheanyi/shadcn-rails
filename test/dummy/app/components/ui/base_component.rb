# frozen_string_literal: true

module Ui
  class BaseComponent < ApplicationComponent
    private

    # Merge CSS classes intelligently, handling Tailwind conflicts
    # Uses tailwind_merge gem if available, otherwise falls back to simple join
    def cn(*classes)
      merged_classes = classes.flatten.compact.reject(&:empty?).join(" ")
      
      if defined?(TailwindMerge::Merger)
        TailwindMerge::Merger.new.merge(merged_classes)
      else
        merged_classes.split.uniq.join(" ")
      end
    end

    # Generate a unique ID for accessibility
    def generate_id(prefix = "shadcn")
      "#{prefix}-#{SecureRandom.hex(4)}"
    end

    # Common focus ring styles
    def focus_ring_classes
      "focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
    end

    # Common disabled styles  
    def disabled_classes
      "disabled:pointer-events-none disabled:opacity-50"
    end
  end
end
