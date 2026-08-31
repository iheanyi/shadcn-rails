# frozen_string_literal: true

module Shadcn
  # SidebarGroupAction component - action button for a sidebar group
  class SidebarGroupActionComponent < BaseComponent
    BASE_CLASSES = "absolute top-3.5 right-3 flex aspect-square w-5 items-center justify-center rounded-md p-0 text-sidebar-foreground ring-sidebar-ring outline-hidden transition-transform hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 [&>svg]:size-4 [&>svg]:shrink-0"
    HIT_AREA_CLASSES = "after:absolute after:-inset-2 md:after:hidden"
    COLLAPSED_CLASSES = "group-data-[collapsible=icon]:hidden"

    def call
      content_tag(:button, content, action_attributes)
    end

    private

    def action_attributes
      attrs = {
        type: "button",
        class: cn(BASE_CLASSES, HIT_AREA_CLASSES, COLLAPSED_CLASSES, class_name),
        "data-sidebar": "group-action",
        "data-slot": "sidebar-group-action"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
