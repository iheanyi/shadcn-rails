# frozen_string_literal: true

module Shadcn
  # Card Description component
  class CardDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm text-muted-foreground"

    def call
      content_tag(:p, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end
end
