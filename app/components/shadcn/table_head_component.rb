# frozen_string_literal: true

module Shadcn
  # Table Head component
  class TableHeadComponent < BaseComponent
    BASE_CLASSES = "h-10 px-2 text-left align-middle font-medium whitespace-nowrap text-foreground [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]"

    def call
      content_tag(:th, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end
end
