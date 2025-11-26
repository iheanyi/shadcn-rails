# frozen_string_literal: true

module Shadcn
  # Drawer Header component
  class DrawerHeaderComponent < BaseComponent
    BASE_CLASSES = "grid gap-1.5 p-4 text-center sm:text-left"

    renders_one :title, lambda { |**options|
      DrawerTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      DrawerDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([title, description, content].compact), class: merge_classes(BASE_CLASSES))
    end
  end
end
