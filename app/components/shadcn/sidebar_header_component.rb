# frozen_string_literal: true

module Shadcn
  # SidebarHeader component - sticky header section for sidebar
  class SidebarHeaderComponent < BaseComponent
    BASE_CLASSES = "flex flex-col gap-2 p-2"

    def call
      content_tag(:div, content, header_attributes)
    end

    private

    def header_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        "data-sidebar": "header"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
