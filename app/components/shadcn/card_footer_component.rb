# frozen_string_literal: true

module Shadcn
  # Card Footer component
  class CardFooterComponent < BaseComponent
    BASE_CLASSES = "flex items-center p-6 pt-0"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end
end
