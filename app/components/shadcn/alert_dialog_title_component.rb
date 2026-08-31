# frozen_string_literal: true

module Shadcn
  # Alert Dialog Title component
  class AlertDialogTitleComponent < BaseComponent
    BASE_CLASSES = "text-lg font-semibold sm:group-has-data-[slot=alert-dialog-media]/alert-dialog-content:col-start-2"

    def call
      content_tag(:h2, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "alert-dialog-title" }))
    end
  end
end
