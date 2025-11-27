# frozen_string_literal: true

module Shadcn
  # SidebarMenuItem component - individual menu item
  class SidebarMenuItemComponent < BaseComponent
    BASE_CLASSES = "group/menu-item relative"

    renders_one :button, lambda { |**options|
      SidebarMenuButtonComponent.new(**options)
    }
    renders_one :action, lambda { |**options|
      SidebarMenuActionComponent.new(**options)
    }
    renders_one :badge, lambda { |**options|
      SidebarMenuBadgeComponent.new(**options)
    }
    renders_one :sub, lambda { |**options|
      SidebarMenuSubComponent.new(**options)
    }

    def call
      content_tag(:li, item_content, item_attributes)
    end

    private

    def item_content
      safe_join([button, action, badge, sub, content].compact)
    end

    def item_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        "data-sidebar": "menu-item"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
