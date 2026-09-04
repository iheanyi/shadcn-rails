# frozen_string_literal: true

module Shadcn
  # SidebarSeparator component - visual separator for sidebar
  class SidebarSeparatorComponent < BaseComponent
    BASE_CLASSES = "mx-2 w-auto bg-sidebar-border"

    def call
      content_tag(:hr, nil, separator_attributes)
    end

    private

    def separator_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        "data-sidebar": "separator",
        "data-slot": "sidebar-separator"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
