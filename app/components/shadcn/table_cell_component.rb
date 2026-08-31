# frozen_string_literal: true

module Shadcn
  # Table Cell component
  class TableCellComponent < BaseComponent
    BASE_CLASSES = "p-2 align-middle whitespace-nowrap [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]"

    def call
      content_tag(:td, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end
end
