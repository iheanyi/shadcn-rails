# frozen_string_literal: true

module Shadcn
  # SidebarGroupLabel component - label for a sidebar group
  class SidebarGroupLabelComponent < BaseComponent
    BASE_CLASSES = "duration-200 flex h-8 shrink-0 items-center rounded-md px-2 text-xs font-medium text-sidebar-foreground/70 outline-none ring-sidebar-ring transition-[margin,opa] ease-linear focus-visible:ring-2 [&>svg]:size-4 [&>svg]:shrink-0"
    COLLAPSED_CLASSES = "group-data-[collapsible=icon]:-mt-8 group-data-[collapsible=icon]:opacity-0"

    def call
      content_tag(:div, content, label_attributes)
    end

    private

    def label_attributes
      attrs = {
        class: cn(BASE_CLASSES, COLLAPSED_CLASSES, class_name),
        "data-sidebar": "group-label"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
