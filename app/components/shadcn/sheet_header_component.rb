# frozen_string_literal: true

module Shadcn
  # Sheet Header component
  class SheetHeaderComponent < BaseComponent
    BASE_CLASSES = "flex flex-col gap-1.5 p-4"

    renders_one :title, lambda { |**options|
      SheetTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      SheetDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([title, description, content].compact), **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "sheet-header" }))
    end
  end
end
