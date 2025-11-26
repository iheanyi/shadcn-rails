# frozen_string_literal: true

module Shadcn
  # Alert Description component
  class AlertDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm [&_p]:leading-relaxed"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end
end
