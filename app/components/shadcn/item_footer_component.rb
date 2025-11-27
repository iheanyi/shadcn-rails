# frozen_string_literal: true

module Shadcn
  # Item Footer component - display footer content below main content
  class ItemFooterComponent < BaseComponent
    BASE_CLASSES = "mt-2 w-full"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
    end
  end
end
