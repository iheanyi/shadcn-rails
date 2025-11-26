# frozen_string_literal: true

module Shadcn
  # Collapsible Content component
  class CollapsibleContentComponent < BaseComponent
    BASE_CLASSES = "overflow-hidden data-[state=closed]:animate-collapsible-up data-[state=open]:animate-collapsible-down"

    def initialize(open: false, **options, &block)
      super(**options, &block)
      @open = open
    end

    def call
      content_tag(:div, content, content_attributes)
    end

    private

    def content_attributes
      {
        class: merge_classes(BASE_CLASSES),
        "data-shadcn--collapsible-target": "content",
        "data-state": @open ? "open" : "closed",
        hidden: !@open
      }
    end
  end
end
