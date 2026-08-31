# frozen_string_literal: true

module Shadcn
  # Alert Description component
  class AlertDescriptionComponent < BaseComponent
    BASE_CLASSES = "col-start-2 grid justify-items-start gap-1 text-sm text-muted-foreground [&_p]:leading-relaxed"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), "data-slot": "alert-description", **html_options)
    end
  end
end
