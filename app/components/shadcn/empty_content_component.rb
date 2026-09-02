# frozen_string_literal: true

module Shadcn
  # Empty Content component - container for action buttons
  class EmptyContentComponent < BaseComponent
    BASE_CLASSES = "flex w-full max-w-sm min-w-0 flex-col items-center gap-4 text-sm text-balance"

    def call
      content_tag(:div, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "empty-content" }))
    end
  end
end
