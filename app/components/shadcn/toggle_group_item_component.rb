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

    # Mirrors upstream toggleVariants; the group-specific overrides below are
    # layered on top exactly like ToggleGroupItem does in New York v4.
    BASE_CLASSES = "inline-flex items-center justify-center gap-2 rounded-md text-sm font-medium whitespace-nowrap transition-[color,box-shadow] outline-none hover:bg-muted hover:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground dark:aria-invalid:ring-destructive/40 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"

    GROUP_ITEM_CLASSES = "w-auto min-w-0 shrink-0 px-3 focus:z-10 focus-visible:z-10"

    # Joined-edge treatment when the parent group renders with spacing=0.
    SPACING_CLASSES = "data-[spacing=0]:rounded-none data-[spacing=0]:shadow-none data-[spacing=0]:first:rounded-l-md data-[spacing=0]:last:rounded-r-md data-[spacing=0]:data-[variant=outline]:border-l-0 data-[spacing=0]:data-[variant=outline]:first:border-l"

    def initialize(
      value:,
      pressed: false,
      disabled: false,
      aria_label: nil,
      variant: :default,
      size: :default,
      spacing: 0,
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
      @spacing = spacing
      @group_type = group_type
    end

    def call
      content_tag(:button, content, button_attributes)
    end

    private

    def button_attributes
      merge_html_attributes({
        type: "button",
        class: cn(BASE_CLASSES, VARIANTS[@variant], SIZES[@size], GROUP_ITEM_CLASSES, SPACING_CLASSES, class_name),
        disabled: @disabled || nil,
        "aria-pressed": @pressed.to_s,
        "aria-label": @aria_label,
        "data-slot": "toggle-group-item",
        "data-variant": @variant,
        "data-size": @size,
        "data-spacing": @spacing,
        "data-state": @pressed ? "on" : "off",
        "data-value": @value,
        "data-shadcn--toggle-group-target": "item",
        "data-action": "click->shadcn--toggle-group#toggle"
      })
    end
  end
end
