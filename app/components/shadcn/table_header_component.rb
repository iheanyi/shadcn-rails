# frozen_string_literal: true

module Shadcn
  # Table Header component
  class TableHeaderComponent < BaseComponent
    BASE_CLASSES = "[&_tr]:border-b"

    renders_many :rows, lambda { |**options, &block|
      TableRowComponent.new(**options, &block)
    }

    def call
      content_tag(:thead, safe_join([rows, content].compact.flatten), class: merge_classes(BASE_CLASSES))
    end
  end
end
