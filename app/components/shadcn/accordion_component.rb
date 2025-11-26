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
end
