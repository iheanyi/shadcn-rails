# frozen_string_literal: true

module Shadcn
  # Toast Description component
  class ToastDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm opacity-90"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
