# frozen_string_literal: true

module Shadcn
  # SidebarMenuSubItem component - submenu item
  class SidebarMenuSubItemComponent < BaseComponent
    BASE_CLASSES = "group/menu-sub-item relative"

    renders_one :button, lambda { |**options|
      SidebarMenuSubButtonComponent.new(**options)
    }

    def call
      content_tag(:li, item_content, item_attributes)
    end

    private

    def item_content
      button || content
    end

    def item_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        "data-sidebar": "menu-sub-item",
        "data-slot": "sidebar-menu-sub-item"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
