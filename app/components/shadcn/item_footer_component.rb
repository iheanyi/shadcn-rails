# frozen_string_literal: true

module Shadcn
  # Item Footer component - display footer content below main content
  class ItemFooterComponent < BaseComponent
    BASE_CLASSES = "flex basis-full items-center justify-between gap-2"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **merge_html_attributes({}, slot: "item-footer"))
    end
  end
end
