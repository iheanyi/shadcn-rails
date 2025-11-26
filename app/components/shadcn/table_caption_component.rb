# frozen_string_literal: true

module Shadcn
  # Table Caption component
  class TableCaptionComponent < BaseComponent
    BASE_CLASSES = "mt-4 text-sm text-muted-foreground"

    def call
      content_tag(:caption, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end
end
