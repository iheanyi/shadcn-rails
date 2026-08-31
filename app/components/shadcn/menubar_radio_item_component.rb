# frozen_string_literal: true

module Shadcn
  # Menubar Radio Item component
  # A radio button within a radio group
  class MenubarRadioItemComponent < BaseComponent
    BASE_CLASSES = "relative flex cursor-default items-center gap-2 rounded-xs py-1.5 pr-2 pl-8 text-sm outline-hidden select-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"

    renders_one :shortcut, lambda { |**options|
      MenubarShortcutComponent.new(**options)
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
      content_tag(:span, radio_icon, class: "pointer-events-none absolute left-2 flex size-3.5 items-center justify-center")
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
        class: "size-2 fill-current"
      })
    end

    def circle_svg
      content_tag(:circle, "", cx: "12", cy: "12", r: "6")
    end

    def item_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        role: "menuitemradio",
        "aria-checked": @checked.to_s,
        tabindex: @disabled ? nil : "-1",
        "data-disabled": @disabled ? "" : nil,
        "data-state": @checked ? "checked" : "unchecked",
        "data-value": @value,
        "data-slot": "menubar-radio-item",
        "data-shadcn--menubar-target": "item",
        "data-action": "click->shadcn--menubar#selectRadio"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
