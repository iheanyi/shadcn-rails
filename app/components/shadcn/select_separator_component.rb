# frozen_string_literal: true

module Shadcn
  # Select Separator component
  class SelectSeparatorComponent < BaseComponent
    BASE_CLASSES = "pointer-events-none -mx-1 my-1 h-px bg-border"

    def call
      content_tag(:div, "", class: merge_classes(BASE_CLASSES), role: "separator", "data-slot": "select-separator")
    end
  end
end
