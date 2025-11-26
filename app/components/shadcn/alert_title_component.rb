# frozen_string_literal: true

module Shadcn
  # Alert Title component
  class AlertTitleComponent < BaseComponent
    BASE_CLASSES = "mb-1 font-medium leading-none tracking-tight"

    def call
      content_tag(:h5, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end
end
