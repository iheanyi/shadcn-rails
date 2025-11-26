# frozen_string_literal: true

module Shadcn
  # Sheet Description component
  class SheetDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm text-muted-foreground"

    def call
      content_tag(:p, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
