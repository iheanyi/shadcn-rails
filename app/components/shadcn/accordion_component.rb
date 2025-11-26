# frozen_string_literal: true

module Shadcn
  # Accordion component for collapsible content sections
  # Matches shadcn/ui Accordion component
  # Uses Stimulus for interactivity
  #
  # @example Single accordion
  #   <%= render Shadcn::AccordionComponent.new(type: :single, collapsible: true) do |accordion| %>
  #     <% accordion.with_item(value: "item-1") do |item| %>
  #       <% item.with_trigger { "Is it accessible?" } %>
  #       <% item.with_body { "Yes. It adheres to the WAI-ARIA design pattern." } %>
  #     <% end %>
  #     <% accordion.with_item(value: "item-2") do |item| %>
  #       <% item.with_trigger { "Is it styled?" } %>
  #       <% item.with_body { "Yes. It comes with default styles." } %>
  #     <% end %>
  #   <% end %>
  #
  # @example Multiple accordion
  #   <%= render Shadcn::AccordionComponent.new(type: :multiple) do |accordion| %>
  #     ...
  #   <% end %>
  #
  class AccordionComponent < BaseComponent
    renders_many :items, lambda { |value:, **options, &block|
      AccordionItemComponent.new(value: value, **options, &block)
    }

    # @param type [Symbol] Accordion type (:single, :multiple)
    # @param collapsible [Boolean] For single type, whether all items can be collapsed
    # @param default_value [String, Array] Initially expanded item(s)
    def initialize(type: :single, collapsible: false, default_value: nil, **options)
      super(**options)
      @type = type.to_sym
      @collapsible = collapsible
      @default_value = default_value
    end

    def call
      content_tag(:div, accordion_content, accordion_attributes)
    end

    private

    def accordion_content
      safe_join([items, content].compact.flatten)
    end

    def accordion_attributes
      attrs = {
        class: class_name,
        "data-controller": "shadcn--accordion",
        "data-shadcn--accordion-type-value": @type.to_s,
        "data-shadcn--accordion-collapsible-value": @collapsible.to_s,
        "data-shadcn--accordion-default-value": Array(@default_value).join(",")
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Accordion Item component
  class AccordionItemComponent < BaseComponent
    BASE_CLASSES = "border-b"

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
        "data-shadcn--accordion-target": "item",
        "data-value": @value,
        "data-state": "closed"
      }
    end
  end

  # Accordion Trigger component
  class AccordionTriggerComponent < BaseComponent
    HEADER_CLASSES = "flex"
    TRIGGER_CLASSES = "flex flex-1 items-center justify-between py-4 text-sm font-medium transition-all hover:underline text-left [&[data-state=open]>svg]:rotate-180"

    def call
      content_tag(:h3, trigger_button, class: HEADER_CLASSES, "data-orientation": "vertical")
    end

    private

    def trigger_button
      content_tag(:button, button_content, trigger_attributes)
    end

    def button_content
      safe_join([
        content_tag(:span, content),
        chevron_icon
      ])
    end

    def chevron_icon
      content_tag(:svg,
        content_tag(:path, nil, d: "m6 9 6 6 6-6", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round", "stroke-linejoin": "round"),
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "none",
        class: "h-4 w-4 shrink-0 text-muted-foreground transition-transform duration-200"
      )
    end

    def trigger_attributes
      {
        type: "button",
        class: cn(TRIGGER_CLASSES, class_name),
        "data-shadcn--accordion-target": "trigger",
        "data-action": "click->shadcn--accordion#toggle",
        "data-state": "closed",
        "aria-expanded": "false"
      }
    end
  end

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
        "data-shadcn--accordion-target": "content",
        "data-state": "closed",
        hidden: true
      }
    end
  end
end
