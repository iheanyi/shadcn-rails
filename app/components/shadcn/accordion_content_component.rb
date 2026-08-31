# frozen_string_literal: true

module Shadcn
  # Accordion Content component
  class AccordionContentComponent < BaseComponent
    BASE_CLASSES = "overflow-hidden text-sm data-[state=closed]:animate-accordion-up data-[state=open]:animate-accordion-down"
    INNER_CLASSES = "pb-4 pt-0"

    def call
      content_tag(:div, inner_content, content_attributes)
    end

    private

    def inner_content
      content_tag(:div, content, class: INNER_CLASSES)
    end

    def content_attributes
      {
        class: merge_classes(BASE_CLASSES),
        role: "region",
        "data-slot": "accordion-content",
        "data-shadcn--accordion-target": "content",
        "data-state": "closed",
        hidden: true
      }
    end
  end
end
