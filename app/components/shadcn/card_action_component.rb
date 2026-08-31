# frozen_string_literal: true

module Shadcn
  # Card Action component
  class CardActionComponent < BaseComponent
    BASE_CLASSES = "col-start-2 row-span-2 row-start-1 self-start justify-self-end"

    def call
      content_tag(:div, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "card-action" }))
    end
  end
end
