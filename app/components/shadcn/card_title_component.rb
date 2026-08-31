# frozen_string_literal: true

module Shadcn
  # Card Title component
  class CardTitleComponent < BaseComponent
    BASE_CLASSES = "leading-none font-semibold"

    # @param tag [Symbol] HTML tag to use (default: :h3)
    def initialize(tag: :h3, **options, &block)
      super(**options, &block)
      @tag = tag
    end

    def call
      content_tag(@tag, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "card-title" }))
    end
  end
end
