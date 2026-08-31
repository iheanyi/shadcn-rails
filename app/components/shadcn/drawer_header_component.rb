# frozen_string_literal: true

module Shadcn
  # Drawer Header component
  class DrawerHeaderComponent < BaseComponent
    BASE_CLASSES = "flex flex-col gap-0.5 p-4 group-data-[vaul-drawer-direction=bottom]/drawer-content:text-center group-data-[vaul-drawer-direction=top]/drawer-content:text-center md:gap-1.5 md:text-left"

    renders_one :title, lambda { |**options|
      DrawerTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      DrawerDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([title, description, content].compact), **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "drawer-header" }))
    end
  end
end
