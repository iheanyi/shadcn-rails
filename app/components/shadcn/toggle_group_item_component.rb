# frozen_string_literal: true

module Shadcn
  # Individual toggle item within a group
  class ToggleGroupItemComponent < BaseComponent
    VARIANTS = {
      default: "bg-transparent",
      outline: "border border-input bg-transparent shadow-xs hover:bg-accent hover:text-accent-foreground"
    }.freeze

    SIZES = {
      sm: "h-8 min-w-8 px-1.5",
      default: "h-9 min-w-9 px-2",
      lg: "h-10 min-w-10 px-2.5"
    }.freeze

    BASE_CLASSES = "inline-flex items-center justify-center gap-2 rounded-md text-sm font-medium whitespace-nowrap transition-[color,box-shadow] outline-none hover:bg-muted hover:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground dark:aria-invalid:ring-destructive/40 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"

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
      merge_html_attributes({
        type: "button",
        class: cn(BASE_CLASSES, VARIANTS[@variant], SIZES[@size], class_name),
        disabled: @disabled || nil,
        "aria-pressed": @pressed.to_s,
        "aria-label": @aria_label,
        "data-slot": "toggle-group-item",
        "data-state": @pressed ? "on" : "off",
        "data-value": @value,
        "data-shadcn--toggle-group-target": "item",
        "data-action": "click->shadcn--toggle-group#toggle"
      })
    end
  end
end
