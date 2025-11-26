# frozen_string_literal: true

module Shadcn
  # Toast Title component
  class ToastTitleComponent < BaseComponent
    BASE_CLASSES = "text-sm font-semibold [&+div]:text-xs"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
