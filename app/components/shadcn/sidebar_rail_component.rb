# frozen_string_literal: true

module Shadcn
  # SidebarRail component - thin interactive rail for expanding collapsed sidebar
  class SidebarRailComponent < BaseComponent
    BASE_CLASSES = "absolute inset-y-0 z-20 hidden w-4 -translate-x-1/2 transition-all ease-linear group-data-[side=left]:-right-4 group-data-[side=right]:left-0 after:absolute after:inset-y-0 after:left-1/2 after:w-[2px] hover:after:bg-sidebar-border sm:flex"
    HOVER_EXPAND_CLASSES = "in-data-[side=left]:cursor-w-resize in-data-[side=right]:cursor-e-resize [[data-side=left][data-state=collapsed]_&]:cursor-e-resize [[data-side=right][data-state=collapsed]_&]:cursor-w-resize group-data-[collapsible=offcanvas]:translate-x-0 group-data-[collapsible=offcanvas]:after:left-full hover:group-data-[collapsible=offcanvas]:bg-sidebar [[data-side=left][data-collapsible=offcanvas]_&]:-right-2 [[data-side=right][data-collapsible=offcanvas]_&]:-left-2"

    def call
      content_tag(:button, nil, rail_attributes)
    end

    private

    def rail_attributes
      attrs = {
        type: "button",
        class: cn(BASE_CLASSES, HOVER_EXPAND_CLASSES, class_name),
        tabindex: "-1",
        "aria-label": "Toggle Sidebar",
        title: "Toggle Sidebar",
        "data-sidebar": "rail",
        "data-slot": "sidebar-rail",
        "data-action": "click->shadcn--sidebar#toggle"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
