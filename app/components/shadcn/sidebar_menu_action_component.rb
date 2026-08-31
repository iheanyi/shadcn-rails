# frozen_string_literal: true

module Shadcn
  # SidebarMenuAction component - action button within menu item
  class SidebarMenuActionComponent < BaseComponent
    BASE_CLASSES = "absolute top-1.5 right-1 flex aspect-square w-5 items-center justify-center rounded-md p-0 text-sidebar-foreground ring-sidebar-ring outline-hidden transition-transform peer-hover/menu-button:text-sidebar-accent-foreground hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 [&>svg]:size-4 [&>svg]:shrink-0"
    HIT_AREA_CLASSES = "after:absolute after:-inset-2 md:after:hidden"
    SIZE_CLASSES = "peer-data-[size=sm]/menu-button:top-1 peer-data-[size=lg]/menu-button:top-2.5"
    COLLAPSED_CLASSES = "group-data-[collapsible=icon]:hidden"
    SHOW_ON_HOVER_CLASSES = "group-focus-within/menu-item:opacity-100 group-hover/menu-item:opacity-100 peer-data-[active=true]/menu-button:text-sidebar-accent-foreground data-[state=open]:opacity-100 md:opacity-0"

    def initialize(show_on_hover: false, **options)
      super(**options)
      @show_on_hover = show_on_hover
    end

    def call
      content_tag(:button, content, action_attributes)
    end

    private

    def action_attributes
      attrs = {
        type: "button",
        class: cn(
          BASE_CLASSES,
          HIT_AREA_CLASSES,
          SIZE_CLASSES,
          COLLAPSED_CLASSES,
          @show_on_hover ? SHOW_ON_HOVER_CLASSES : nil,
          class_name
        ),
        "data-sidebar": "menu-action",
        "data-slot": "sidebar-menu-action"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
