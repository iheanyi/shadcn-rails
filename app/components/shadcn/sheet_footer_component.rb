# frozen_string_literal: true

module Shadcn
  # Sheet Footer component
  class SheetFooterComponent < BaseComponent
    BASE_CLASSES = "flex flex-col-reverse gap-2 sm:flex-row sm:justify-end"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
