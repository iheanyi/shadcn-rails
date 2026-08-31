# frozen_string_literal: true

module Shadcn
  # Context Menu Label component
  class ContextMenuLabelComponent < BaseComponent
    BASE_CLASSES = "px-2 py-1.5 text-sm font-medium text-foreground data-[inset]:pl-8"

    # @param inset [Boolean] Whether to add left padding
    def initialize(inset: false, **options, &block)
      super(**options, &block)
      @inset = inset
    end

    def call
      content_tag(:div, content, **label_attributes)
    end

    private

    def label_attributes
      merge_html_attributes(
        {
          class: merge_classes(BASE_CLASSES),
          "data-slot": "context-menu-label",
          "data-inset": @inset ? "" : nil
        }
      )
    end
  end
end
