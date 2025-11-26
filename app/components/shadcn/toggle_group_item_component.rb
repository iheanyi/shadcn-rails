# frozen_string_literal: true

module Shadcn
  # Individual toggle item within a group
  class ToggleGroupItemComponent < BaseComponent
    VARIANTS = {
      default: "bg-transparent",
      outline: "border border-input bg-transparent shadow-sm hover:bg-accent hover:text-accent-foreground"
    }.freeze

    SIZES = {
      sm: "h-8 px-2 min-w-8",
      default: "h-9 px-2.5 min-w-9",
      lg: "h-10 px-3 min-w-10"
    }.freeze

    BASE_CLASSES = "inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground"

    def initialize(
      value:,
      pressed: false,
      disabled: false,
      aria_label: nil,
      variant: :default,
      size: :default,
      group_type: :single,
      **options,
      &block
    )
      super(**options, &block)
      @value = value
      @pressed = pressed
      @disabled = disabled
      @aria_label = aria_label
      @variant = variant
      @size = size
      @group_type = group_type
    end

    def call
      content_tag(:button, content, button_attributes)
    end

    private

    def button_attributes
      attrs = {
        type: "button",
        class: cn(BASE_CLASSES, VARIANTS[@variant], SIZES[@size], class_name),
        disabled: @disabled || nil,
        "aria-pressed": @pressed.to_s,
        "aria-label": @aria_label,
        "data-state": @pressed ? "on" : "off",
        "data-value": @value,
        "data-shadcn--toggle-group-target": "item",
        "data-action": "click->shadcn--toggle-group#toggle"
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end
end
