# frozen_string_literal: true

module Shadcn
  # Radio Group component for selecting one option from a set
  # Matches shadcn/ui RadioGroup component
  #
  # @example Basic usage
  #   <%= render Shadcn::RadioGroupComponent.new(name: "plan", value: "pro") do |group| %>
  #     <% group.with_item(value: "free", id: "free") %>
  #     <%= render Shadcn::LabelComponent.new(for: "free") { "Free" } %>
  #     <% group.with_item(value: "pro", id: "pro") %>
  #     <%= render Shadcn::LabelComponent.new(for: "pro") { "Pro" } %>
  #   <% end %>
  #
  class RadioGroupComponent < BaseComponent
    BASE_CLASSES = "grid gap-3"

    renders_many :items, ->(value:, id: nil, disabled: false, **options) do
      RadioGroupItemComponent.new(
        value: value,
        id: id,
        disabled: disabled,
        group_name: @name,
        selected: @value == value,
        **options
      )
    end

    # @param name [String] Input name attribute for form submission
    # @param value [String, nil] Currently selected value
    # @param disabled [Boolean] Whether the entire group is disabled
    # @param required [Boolean] Whether a selection is required
    # @param orientation [Symbol] :vertical or :horizontal layout
    def initialize(
      name:,
      value: nil,
      disabled: false,
      required: false,
      orientation: :vertical,
      **options
    )
      super(**options)
      @name = name
      @value = value
      @disabled = disabled
      @required = required
      @orientation = orientation
    end

    def call
      content_tag(:div, group_attributes) do
        safe_join([
          items.map(&:to_s),
          content
        ].flatten.compact)
      end
    end

    private

    def group_attributes
      attrs = {
        role: "radiogroup",
        class: cn(BASE_CLASSES, orientation_classes, class_name),
        "aria-required": @required ? "true" : nil,
        "aria-disabled": @disabled ? "true" : nil,
        "data-controller": "shadcn--radio-group",
        "data-shadcn--radio-group-name-value": @name,
        "data-shadcn--radio-group-value-value": @value
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end

    def orientation_classes
      case @orientation
      when :horizontal
        "flex flex-row gap-4"
      else
        "grid gap-3"
      end
    end
  end
end
