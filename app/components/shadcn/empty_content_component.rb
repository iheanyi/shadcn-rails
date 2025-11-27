# frozen_string_literal: true

module Shadcn
  # Empty Content component - container for action buttons
  class EmptyContentComponent < BaseComponent
    BASE_CLASSES = "flex flex-col items-center gap-2"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
    end
  end
end
