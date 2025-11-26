# frozen_string_literal: true

module Shadcn
  # Table Footer component
  class TableFooterComponent < BaseComponent
    BASE_CLASSES = "border-t bg-muted/50 font-medium [&>tr]:last:border-b-0"

    renders_many :rows, lambda { |**options, &block|
      TableRowComponent.new(**options, &block)
    }

    def call
      content_tag(:tfoot, safe_join([rows, content].compact.flatten), class: merge_classes(BASE_CLASSES))
    end
  end
end
