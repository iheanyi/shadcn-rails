# frozen_string_literal: true

module Shadcn
  # SidebarContent component - scrollable content area for sidebar
  class SidebarContentComponent < BaseComponent
    BASE_CLASSES = "flex min-h-0 flex-1 flex-col gap-2 overflow-auto group-data-[collapsible=icon]:overflow-hidden"

    renders_many :groups, lambda { |**options|
      SidebarGroupComponent.new(**options)
    }

    def call
      content_tag(:div, content_structure, content_attributes)
    end

    private

    def content_structure
      groups.any? ? safe_join(groups) : content
    end

    def content_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        "data-sidebar": "content",
        "data-slot": "sidebar-content"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
