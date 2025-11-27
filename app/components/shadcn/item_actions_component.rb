# frozen_string_literal: true

module Shadcn
  # Item Actions component - container for action buttons
  class ItemActionsComponent < BaseComponent
    BASE_CLASSES = "shrink-0 flex items-center gap-2"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
    end
  end
end
