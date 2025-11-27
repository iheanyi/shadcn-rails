# frozen_string_literal: true

module Shadcn
  # SidebarMenuAction component - action button within menu item
  class SidebarMenuActionComponent < BaseComponent
    BASE_CLASSES = "absolute right-1 top-1.5 flex aspect-square w-5 items-center justify-center rounded-md p-0 text-sidebar-foreground outline-none ring-sidebar-ring transition-transform hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 peer-hover/menu-button:text-sidebar-accent-foreground [&>svg]:size-4 [&>svg]:shrink-0"
    COLLAPSED_CLASSES = "group-data-[collapsible=icon]:hidden"
    SHOW_ON_HOVER_CLASSES = "after:absolute after:-inset-2 after:md:hidden group-focus-within/menu-item:opacity-100 group-hover/menu-item:opacity-100 data-[state=open]:opacity-100 peer-data-[active=true]/menu-button:text-sidebar-accent-foreground md:opacity-0"

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
          COLLAPSED_CLASSES,
          @show_on_hover ? SHOW_ON_HOVER_CLASSES : nil,
          class_name
        ),
        "data-sidebar": "menu-action"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
