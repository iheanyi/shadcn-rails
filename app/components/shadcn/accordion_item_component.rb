# frozen_string_literal: true

module Shadcn
  # Accordion Item component
  class AccordionItemComponent < BaseComponent
    BASE_CLASSES = "border-b last:border-b-0"

    renders_one :trigger, lambda { |**options, &block|
      AccordionTriggerComponent.new(**options, &block)
    }
    renders_one :body, lambda { |**options, &block|
      AccordionContentComponent.new(**options, &block)
    }

    # @param value [String] Unique value identifying this item
    def initialize(value:, **options)
      super(**options)
      @value = value
    end

    def call
      content_tag(:div, item_content, item_attributes)
    end

    private

    def item_content
      safe_join([trigger, body].compact)
    end

    def item_attributes
      {
        class: merge_classes(BASE_CLASSES),
        "data-slot": "accordion-item",
        "data-shadcn--accordion-target": "item",
        "data-value": @value,
        "data-state": "closed"
      }
    end
  end
end
