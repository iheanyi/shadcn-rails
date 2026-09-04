# frozen_string_literal: true

module Shadcn
  # SidebarFooter component - sticky footer section for sidebar
  class SidebarFooterComponent < BaseComponent
    BASE_CLASSES = "flex flex-col gap-2 p-2"

    def call
      content_tag(:div, content, footer_attributes)
    end

    private

    def footer_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        "data-sidebar": "footer",
        "data-slot": "sidebar-footer"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
