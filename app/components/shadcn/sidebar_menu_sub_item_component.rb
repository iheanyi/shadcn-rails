# frozen_string_literal: true

module Shadcn
  # SidebarMenuSubItem component - submenu item
  class SidebarMenuSubItemComponent < BaseComponent
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
        "data-sidebar": "menu-sub-item"
      }
      attrs[:class] = class_name if class_name.present?
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
