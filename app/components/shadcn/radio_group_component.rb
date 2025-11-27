# frozen_string_literal: true

module Shadcn
  # Radio Group component for selecting one option from a set
  # Uses native <input type="radio"> elements styled with CSS
  # Works without JavaScript for progressive enhancement
  #
  # @example Basic usage
  #   <%= render Shadcn::RadioGroupComponent.new(name: "plan", value: "pro") do |group| %>
  #     <% group.with_item(value: "free", id: "free") { "Free" } %>
  #     <% group.with_item(value: "pro", id: "pro") { "Pro" } %>
  #   <% end %>
  #
  # @example With separate labels
  #   <%= render Shadcn::RadioGroupComponent.new(name: "plan") do |group| %>
  #     <div class="flex items-center space-x-2">
  #       <% group.with_item(value: "free", id: "free") %>
  #       <%= render Shadcn::LabelComponent.new(for: "free") { "Free" } %>
  #     </div>
  #   <% end %>
  #
  class RadioGroupComponent < BaseComponent
    BASE_CLASSES = "grid gap-3"

    renders_many :items, ->(value:, id: nil, disabled: false, **options, &block) do
      RadioGroupItemComponent.new(
        value: value,
        id: id,
        disabled: disabled,
        group_name: @name,
        selected: @value == value,
        **options,
        &block
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
        content
      end
    end

    private

    def group_attributes
      attrs = {
        role: "radiogroup",
        class: cn(BASE_CLASSES, orientation_classes, class_name),
        "aria-required": @required ? "true" : nil,
        "aria-disabled": @disabled ? "true" : nil
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
