# frozen_string_literal: true

module Shadcn
  # Item Description component
  class ItemDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm text-muted-foreground"

    def call
      content_tag(:p, content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
    end
  end
end
