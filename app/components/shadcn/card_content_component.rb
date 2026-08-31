# frozen_string_literal: true

module Shadcn
  # Card Content component
  class CardContentComponent < BaseComponent
    BASE_CLASSES = "px-6"

    # @param standalone [Boolean] Deprecated; v4 content padding is the same in all layouts.
    def initialize(standalone: nil, **options, &block)
      super(**options, &block)
    end

    def call
      content_tag(:div, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "card-content" }))
    end
  end
end
