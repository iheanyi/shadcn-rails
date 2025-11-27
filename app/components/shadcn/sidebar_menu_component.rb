# frozen_string_literal: true

module Shadcn
  # SidebarMenu component - menu container for sidebar items
  class SidebarMenuComponent < BaseComponent
    BASE_CLASSES = "flex w-full min-w-0 flex-col gap-1"

    renders_many :items, lambda { |**options|
      SidebarMenuItemComponent.new(**options)
    }

    def call
      content_tag(:ul, menu_content, menu_attributes)
    end

    private

    def menu_content
      items.any? ? safe_join(items) : content
    end

    def menu_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        "data-sidebar": "menu"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
