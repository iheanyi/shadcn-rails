# frozen_string_literal: true

module Shadcn
  # Individual radio button item
  class RadioGroupItemComponent < BaseComponent
    ITEM_CLASSES = "aspect-square h-4 w-4 shrink-0 rounded-full border border-primary text-primary shadow focus:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"

    def initialize(
      value:,
      id: nil,
      disabled: false,
      group_name: nil,
      selected: false,
      **options,
      &block
    )
      super(**options, &block)
      @value = value
      @id = id
      @disabled = disabled
      @group_name = group_name
      @selected = selected
    end

    def call
      content_tag(:button, item_attributes) do
        indicator
      end
    end

    private

    def item_attributes
      attrs = {
        type: "button",
        role: "radio",
        id: @id,
        class: merge_classes(ITEM_CLASSES),
        disabled: @disabled || nil,
        "aria-checked": @selected.to_s,
        "data-state": @selected ? "checked" : "unchecked",
        "data-value": @value,
        "data-shadcn--radio-group-target": "item",
        "data-action": "click->shadcn--radio-group#select keydown->shadcn--radio-group#handleKeydown"
      }
      attrs.merge!(html_options)
      attrs.compact
    end

    def indicator
      content_tag(:span, indicator_attributes) do
        circle_icon
      end
    end

    def indicator_attributes
      {
        class: cn(
          "flex items-center justify-center",
          @selected ? "" : "opacity-0"
        ),
        "data-shadcn--radio-group-target": "indicator"
      }
    end

    def circle_icon
      content_tag(:svg,
        content_tag(:circle, nil, cx: "12", cy: "12", r: "6", fill: "currentColor"),
        xmlns: "http://www.w3.org/2000/svg",
        width: "10",
        height: "10",
        viewBox: "0 0 24 24",
        fill: "currentColor",
        class: "h-2.5 w-2.5 fill-primary"
      )
    end
  end
end
