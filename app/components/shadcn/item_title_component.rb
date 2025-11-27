# frozen_string_literal: true

module Shadcn
  # Item Title component
  class ItemTitleComponent < BaseComponent
    BASE_CLASSES = "text-sm font-medium leading-none"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
    end
  end
end
