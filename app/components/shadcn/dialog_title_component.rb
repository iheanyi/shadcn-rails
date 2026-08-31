# frozen_string_literal: true

module Shadcn
  # Dialog Title component
  class DialogTitleComponent < BaseComponent
    BASE_CLASSES = "text-lg leading-none font-semibold"

    def call
      content_tag(:h2, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "dialog-title" }))
    end
  end
end
