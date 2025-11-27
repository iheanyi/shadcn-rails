# frozen_string_literal: true

module Shadcn
  # SidebarMenuSub component - submenu container
  class SidebarMenuSubComponent < BaseComponent
    BASE_CLASSES = "mx-3.5 flex min-w-0 translate-x-px flex-col gap-1 border-l border-sidebar-border px-2.5 py-0.5"
    COLLAPSED_CLASSES = "group-data-[collapsible=icon]:hidden"

    renders_many :items, lambda { |**options|
      SidebarMenuSubItemComponent.new(**options)
    }

    def call
      content_tag(:ul, sub_content, sub_attributes)
    end

    private

    def sub_content
      items.any? ? safe_join(items) : content
    end

    def sub_attributes
      attrs = {
        class: cn(BASE_CLASSES, COLLAPSED_CLASSES, class_name),
        "data-sidebar": "menu-sub"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
