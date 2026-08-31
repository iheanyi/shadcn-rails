# frozen_string_literal: true

module Shadcn
  # Dialog Footer component
  class DialogFooterComponent < BaseComponent
    BASE_CLASSES = "flex flex-col-reverse gap-2 sm:flex-row sm:justify-end"

    def call
      content_tag(:div, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "dialog-footer" }))
    end
  end
end
