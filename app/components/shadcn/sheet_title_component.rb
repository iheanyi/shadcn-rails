# frozen_string_literal: true

module Shadcn
  # Sheet Title component
  class SheetTitleComponent < BaseComponent
    BASE_CLASSES = "text-lg font-semibold text-foreground"

    def call
      content_tag(:h2, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
