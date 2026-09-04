# frozen_string_literal: true

module Shadcn
  # Context Menu Checkbox Item component
  # A menu item that can be checked/unchecked
  class ContextMenuCheckboxItemComponent < BaseComponent
    BASE_CLASSES = "relative flex cursor-default items-center gap-2 rounded-sm py-1.5 pr-2 pl-8 text-sm outline-hidden select-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"

    renders_one :shortcut, lambda { |**options|
      ContextMenuShortcutComponent.new(**options)
    }

    # @param checked [Boolean] Whether item is checked
    # @param disabled [Boolean] Whether item is disabled
    def initialize(checked: false, disabled: false, **options, &block)
      super(**options, &block)
      @checked = checked
      @disabled = disabled
    end

    def call
      content_tag(:div, item_content, item_attributes)
    end

    private

    def item_content
      safe_join([
        check_indicator,
        content,
        shortcut
      ].compact)
    end

    def check_indicator
      content_tag(:span, check_icon, class: "pointer-events-none absolute left-2 flex size-3.5 items-center justify-center")
    end

    def check_icon
      return "" unless @checked

      content_tag(:svg, check_svg_path, {
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: "size-4"
      })
    end

    def check_svg_path
      content_tag(:polyline, "", points: "20 6 9 17 4 12")
    end

    def item_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        role: "menuitemcheckbox",
        "aria-checked": @checked.to_s,
        tabindex: @disabled ? nil : "-1",
        "data-slot": "context-menu-checkbox-item",
        "data-disabled": @disabled ? "" : nil,
        "data-state": @checked ? "checked" : "unchecked",
        "data-shadcn--context-menu-target": "item",
        "data-action": "click->shadcn--context-menu#selectItem"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
