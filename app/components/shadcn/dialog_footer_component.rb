# frozen_string_literal: true

module Shadcn
  # Dialog Footer component
  class DialogFooterComponent < BaseComponent
    BASE_CLASSES = "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
