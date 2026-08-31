# frozen_string_literal: true

module Shadcn
  # Empty Description component
  class EmptyDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm/relaxed text-muted-foreground [&>a]:underline [&>a]:underline-offset-4 [&>a:hover]:text-primary"

    def call
      content_tag(:p, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "empty-description" }))
    end
  end
end
