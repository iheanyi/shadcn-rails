# frozen_string_literal: true

module Shadcn
  # Alert Title component
  class AlertTitleComponent < BaseComponent
    BASE_CLASSES = "col-start-2 line-clamp-1 min-h-4 font-medium tracking-tight"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), "data-slot": "alert-title", **html_options)
    end
  end
end
