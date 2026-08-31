# frozen_string_literal: true

module Shadcn
  # Button that toggles a collapsible's content.
  class CollapsibleTriggerComponent < BaseComponent
    BASE_CLASSES = "group #{ButtonComponent::BASE_CLASSES}".freeze

    # @param open [Boolean] Whether the associated collapsible starts open
    # @param disabled [Boolean] Whether the trigger should be disabled
    # @param variant [Symbol, nil] Button style variant
    # @param size [Symbol, nil] Button size
    def initialize(open: false, disabled: false, variant: :ghost, size: :sm, **options, &block)
      super(**options, &block)
      @open = open
      @disabled = disabled
      @variant = variant&.to_sym
      @size = size&.to_sym
    end

    def call
      content_tag(:button, content, trigger_attributes)
    end

    private

    def trigger_attributes
      merge_html_attributes({
        type: "button",
        class: trigger_classes,
        disabled: @disabled || nil,
        "data-shadcn--collapsible-target": "trigger",
        "data-action": "click->shadcn--collapsible#toggle",
        "data-state": @open ? "open" : "closed",
        "aria-disabled": @disabled ? "true" : nil,
        "aria-expanded": @open.to_s
      })
    end

    def trigger_classes
      prefix_classes(cn(
        BASE_CLASSES,
        ButtonComponent::VARIANTS[@variant],
        ButtonComponent::SIZES[@size],
        class_name
      ))
    end
  end
end
