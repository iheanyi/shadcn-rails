# frozen_string_literal: true

module Shadcn
  # Separator component for visually dividing content
  # Matches shadcn/ui Separator component
  #
  # @example Horizontal separator
  #   <%= render Shadcn::SeparatorComponent.new %>
  #
  # @example Vertical separator
  #   <%= render Shadcn::SeparatorComponent.new(orientation: :vertical) %>
  #
  # @example Decorative separator (no semantic meaning)
  #   <%= render Shadcn::SeparatorComponent.new(decorative: true) %>
  #
  class SeparatorComponent < BaseComponent
    BASE_CLASSES = "shrink-0 bg-border data-[orientation=horizontal]:h-px data-[orientation=horizontal]:w-full data-[orientation=vertical]:h-full data-[orientation=vertical]:w-px"

    # @param orientation [Symbol] Separator orientation (:horizontal, :vertical)
    # @param decorative [Boolean] Whether the separator is purely decorative
    def initialize(orientation: :horizontal, decorative: false, **options)
      super(**options)
      @orientation = orientation.to_sym
      @decorative = decorative
    end

    private

    def separator_classes
      cn(BASE_CLASSES, class_name)
    end

    def separator_role
      @decorative ? "none" : "separator"
    end

    def aria_orientation
      @decorative ? nil : @orientation.to_s
    end
  end
end
