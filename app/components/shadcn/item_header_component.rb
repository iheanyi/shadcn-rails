# frozen_string_literal: true

module Shadcn
  # Item Header component - display header content above main content
  class ItemHeaderComponent < BaseComponent
    BASE_CLASSES = "mb-2"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
    end
  end
end
