# frozen_string_literal: true

module Shadcn
  # Empty Title component
  class EmptyTitleComponent < BaseComponent
    BASE_CLASSES = "text-lg font-semibold"

    def call
      content_tag(:h3, content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
    end
  end
end
