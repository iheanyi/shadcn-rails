# frozen_string_literal: true

module Shadcn
  # Table Row component
  class TableRowComponent < BaseComponent
    BASE_CLASSES = "border-b transition-colors hover:bg-muted/50 has-aria-expanded:bg-muted/50 data-[state=selected]:bg-muted"

    renders_many :heads, lambda { |**options, &block|
      TableHeadComponent.new(**options, &block)
    }
    renders_many :cells, lambda { |**options, &block|
      TableCellComponent.new(**options, &block)
    }

    # @param selected [Boolean] Whether row is selected
    def initialize(selected: false, **options, &block)
      super(**options, &block)
      @selected = selected
    end

    def call
      content_tag(:tr, row_content, row_attributes)
    end

    private

    def row_content
      safe_join([heads, cells, content].compact.flatten)
    end

    def row_attributes
      attrs = {
        class: merge_classes(BASE_CLASSES),
        "data-state": @selected ? "selected" : nil
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end
end
