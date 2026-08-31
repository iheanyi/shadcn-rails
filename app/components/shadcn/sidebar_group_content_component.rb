# frozen_string_literal: true

module Shadcn
  # SidebarGroupContent component - content container for a sidebar group
  class SidebarGroupContentComponent < BaseComponent
    BASE_CLASSES = "w-full text-sm"

    renders_many :menus, lambda { |**options|
      SidebarMenuComponent.new(**options)
    }

    def call
      content_tag(:div, content_structure, content_attributes)
    end

    private

    def content_structure
      menus.any? ? safe_join(menus) : content
    end

    def content_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        "data-sidebar": "group-content",
        "data-slot": "sidebar-group-content"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
