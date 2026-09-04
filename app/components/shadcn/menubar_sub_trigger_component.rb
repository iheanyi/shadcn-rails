# frozen_string_literal: true

module Shadcn
  # Menubar Sub Trigger component
  # Button that opens a submenu
  class MenubarSubTriggerComponent < BaseComponent
    BASE_CLASSES = "flex cursor-default items-center rounded-sm px-2 py-1.5 text-sm outline-none select-none focus:bg-accent focus:text-accent-foreground data-[inset]:pl-8 data-[state=open]:bg-accent data-[state=open]:text-accent-foreground"

    # @param inset [Boolean] Whether to add left padding
    def initialize(inset: false, **options, &block)
      super(**options, &block)
      @inset = inset
    end

    def call
      content_tag(:div, trigger_content, trigger_attributes)
    end

    private

    def trigger_content
      safe_join([content, chevron_icon])
    end

    def chevron_icon
      content_tag(:svg, chevron_path, {
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: "ml-auto h-4 w-4"
      })
    end

    def chevron_path
      content_tag(:polyline, "", points: "9 18 15 12 9 6")
    end

    def trigger_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        role: "menuitem",
        "aria-haspopup": "menu",
        "aria-expanded": "false",
        "data-state": "closed",
        "data-inset": @inset ? "" : nil,
        "data-slot": "menubar-sub-trigger",
        "data-shadcn--menubar-target": "subTrigger",
        "data-action": "mouseenter->shadcn--menubar#openSub mouseleave->shadcn--menubar#startCloseSubTimer"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
