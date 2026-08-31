# frozen_string_literal: true

module Shadcn
  # Alert Dialog Description component
  class AlertDialogDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm text-muted-foreground"

    def call
      content_tag(:p, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "alert-dialog-description" }))
    end
  end
end
