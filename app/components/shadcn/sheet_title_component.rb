# frozen_string_literal: true

module Shadcn
  # Sheet Title component
  class SheetTitleComponent < BaseComponent
    BASE_CLASSES = "font-semibold text-foreground"

    def call
      content_tag(:h2, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "sheet-title" }))
    end
  end
end
