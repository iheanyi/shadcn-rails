# frozen_string_literal: true

module Shadcn
  # Item Title component
  class ItemTitleComponent < BaseComponent
    BASE_CLASSES = "flex w-fit items-center gap-2 text-sm leading-snug font-medium"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **merge_html_attributes({}, slot: "item-title"))
    end
  end
end
