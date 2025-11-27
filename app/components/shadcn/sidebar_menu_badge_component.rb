# frozen_string_literal: true

module Shadcn
  # SidebarMenuBadge component - badge within menu item
  class SidebarMenuBadgeComponent < BaseComponent
    BASE_CLASSES = "absolute right-1 flex h-5 min-w-5 items-center justify-center rounded-md px-1 text-xs font-medium tabular-nums text-sidebar-foreground select-none pointer-events-none"
    COLLAPSED_CLASSES = "peer-hover/menu-button:text-sidebar-accent-foreground peer-data-[active=true]/menu-button:text-sidebar-accent-foreground group-data-[collapsible=icon]:hidden"

    def call
      content_tag(:span, content, badge_attributes)
    end

    private

    def badge_attributes
      attrs = {
        class: cn(BASE_CLASSES, COLLAPSED_CLASSES, class_name),
        "data-sidebar": "menu-badge"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
