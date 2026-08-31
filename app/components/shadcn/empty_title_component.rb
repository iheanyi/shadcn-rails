# frozen_string_literal: true

module Shadcn
  # Empty Title component
  class EmptyTitleComponent < BaseComponent
    BASE_CLASSES = "text-lg font-medium tracking-tight"

    def call
      content_tag(:h3, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "empty-title" }))
    end
  end
end
