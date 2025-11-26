# frozen_string_literal: true

module Shadcn
  # Select Item component
  class SelectItemComponent < BaseComponent
    BASE_CLASSES = "relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50"

    # @param value [String] The value for this option
    # @param disabled [Boolean] Whether this option is disabled
    def initialize(value:, disabled: false, **options, &block)
      super(**options, &block)
      @value = value
      @disabled = disabled
    end

    def call
      content_tag(:div, item_content, item_attributes)
    end

    private

    def item_content
      safe_join([
        check_indicator,
        content_tag(:span, content)
      ])
    end

    def check_indicator
      content_tag(:span, check_icon, class: "absolute right-2 flex h-3.5 w-3.5 items-center justify-center")
    end

    def check_icon
      content_tag(:svg,
        content_tag(:path, nil, d: "M20 6 9 17l-5-5", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round", "stroke-linejoin": "round"),
        xmlns: "http://www.w3.org/2000/svg",
        width: "12",
        height: "12",
        viewBox: "0 0 24 24",
        fill: "none",
        class: "h-4 w-4 opacity-0",
        "data-shadcn--select-target": "checkIcon"
      )
    end

    def item_attributes
      {
        class: merge_classes(BASE_CLASSES),
        role: "option",
        "aria-selected": "false",
        "data-shadcn--select-target": "item",
        "data-value": @value,
        "data-disabled": @disabled ? "" : nil,
        "data-action": "click->shadcn--select#select",
        tabindex: @disabled ? nil : "-1"
      }
    end
  end
end
