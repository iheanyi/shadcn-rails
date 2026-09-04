# frozen_string_literal: true

module Shadcn
  # SidebarMenuBadge component - badge within menu item
  class SidebarMenuBadgeComponent < BaseComponent
    BASE_CLASSES = "pointer-events-none absolute top-1.5 right-1 flex h-5 min-w-5 items-center justify-center rounded-md px-1 text-xs font-medium text-sidebar-foreground tabular-nums select-none"
    PEER_CLASSES = "peer-hover/menu-button:text-sidebar-accent-foreground peer-data-[active=true]/menu-button:text-sidebar-accent-foreground peer-data-[size=sm]/menu-button:top-1 peer-data-[size=lg]/menu-button:top-2.5"
    COLLAPSED_CLASSES = "group-data-[collapsible=icon]:hidden"

    def call
      content_tag(:span, content, badge_attributes)
    end

    private

    def badge_attributes
      attrs = {
        class: cn(BASE_CLASSES, PEER_CLASSES, COLLAPSED_CLASSES, class_name),
        "data-sidebar": "menu-badge",
        "data-slot": "sidebar-menu-badge"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
