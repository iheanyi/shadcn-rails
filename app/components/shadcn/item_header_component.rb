# frozen_string_literal: true

module Shadcn
  # Item Header component - display header content above main content
  class ItemHeaderComponent < BaseComponent
    BASE_CLASSES = "flex basis-full items-center justify-between gap-2"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **merge_html_attributes({}, slot: "item-header"))
    end
  end
end
