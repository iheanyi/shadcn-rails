# frozen_string_literal: true

module Shadcn
  # Table Body component
  class TableBodyComponent < BaseComponent
    BASE_CLASSES = "[&_tr:last-child]:border-0"

    renders_many :rows, lambda { |**options, &block|
      TableRowComponent.new(**options, &block)
    }

    def call
      content_tag(:tbody, safe_join([rows, content].compact.flatten), class: merge_classes(BASE_CLASSES))
    end
  end
end
