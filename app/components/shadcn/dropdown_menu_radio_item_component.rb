# frozen_string_literal: true

module Shadcn
  # Dropdown Menu Radio Item component
  # A radio button within a radio group
  class DropdownMenuRadioItemComponent < BaseComponent
    BASE_CLASSES = "relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50"

    renders_one :shortcut, lambda { |**options|
      DropdownMenuShortcutComponent.new(**options)
    }

    # @param value [String] Value of this radio item
    # @param checked [Boolean] Whether item is selected
    # @param disabled [Boolean] Whether item is disabled
    def initialize(value: nil, checked: false, disabled: false, **options, &block)
      super(**options, &block)
      @value = value
      @checked = checked
      @disabled = disabled
    end

    def call
      content_tag(:div, item_content, item_attributes)
    end

    private

    def item_content
      safe_join([
        radio_indicator,
        content,
        shortcut
      ].compact)
    end

    def radio_indicator
      content_tag(:span, radio_icon, class: "absolute left-2 flex h-3.5 w-3.5 items-center justify-center")
    end

    def radio_icon
      return "" unless @checked

      content_tag(:svg, circle_svg, {
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "currentColor",
        stroke: "none",
        class: "h-4 w-4"
      })
    end

    def circle_svg
      content_tag(:circle, "", cx: "12", cy: "12", r: "6")
    end

    def item_attributes
      merge_html_attributes({
        class: cn(BASE_CLASSES, class_name),
        role: "menuitemradio",
        "aria-checked": @checked.to_s,
        tabindex: @disabled ? nil : "-1",
        "data-disabled": @disabled ? "" : nil,
        "data-state": @checked ? "checked" : "unchecked",
        "data-value": @value,
        "data-shadcn--dropdown-target": "item",
        "data-action": "click->shadcn--dropdown#selectRadio"
      })
    end
  end
end
