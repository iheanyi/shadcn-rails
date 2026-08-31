# frozen_string_literal: true

module Shadcn
  # Card Footer component
  class CardFooterComponent < BaseComponent
    BASE_CLASSES = "flex items-center px-6 [.border-t]:pt-6"

    def call
      content_tag(:div, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "card-footer" }))
    end
  end
end
