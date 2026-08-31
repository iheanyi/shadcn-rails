# frozen_string_literal: true

module Shadcn
  # Radio Group component for selecting one option from a set
  # Uses native <input type="radio"> elements styled with CSS
  # Works without JavaScript for progressive enhancement
  #
  # @example Data-driven usage (Tier 1)
  #   <%= render Shadcn::RadioGroupComponent.new(
  #     name: "plan",
  #     value: "pro",
  #     items: [
  #       { value: "free", label: "Free" },
  #       { value: "pro", label: "Pro" },
  #       { value: "enterprise", label: "Enterprise", disabled: true }
  #     ]
  #   ) %>
  #
  # @example Simple DSL with labels (Tier 2)
  #   <%= render Shadcn::RadioGroupComponent.new(name: "plan") do |group| %>
  #     <%= group.with_item(value: "free", label: "Free") %>
  #     <%= group.with_item(value: "pro", label: "Pro") %>
  #   <% end %>
  #
  # @example With separate labels (backward compatible)
  #   <%= render Shadcn::RadioGroupComponent.new(name: "plan") do |group| %>
  #     <div class="flex items-center space-x-2">
  #       <%= group.with_item(value: "free", id: "free") %>
  #       <%= render Shadcn::LabelComponent.new(for: "free") { "Free" } %>
  #     </div>
  #   <% end %>
  #
  class RadioGroupComponent < BaseComponent
    BASE_CLASSES = "grid gap-3"

    renders_many :items, ->(value:, id: nil, label: nil, disabled: false, **options, &block) do
      RadioGroupItemComponent.new(
        value: value,
        id: id || generate_item_id(value),
        label: label,
        disabled: @disabled || disabled,
        group_name: @name,
        selected: @value.to_s == value.to_s,
        **options,
        &block
      )
    end

    # @param name [String] Input name attribute for form submission
    # @param value [String, nil] Currently selected value
    # @param items [Array<Hash>] Array of item hashes with :value, :label, :disabled keys
    # @param disabled [Boolean] Whether the entire group is disabled
    # @param required [Boolean] Whether a selection is required
    # @param orientation [Symbol] :vertical or :horizontal layout
    def initialize(
      name:,
      value: nil,
      items: [],
      disabled: false,
      required: false,
      orientation: :vertical,
      **options
    )
      super(**options)
      @name = name
      @value = value
      @items_data = items
      @disabled = disabled
      @required = required
      @orientation = orientation
    end

    private

    def group_attributes
      merge_html_attributes(
        {
          role: "radiogroup",
          class: group_classes,
          "data-slot": "radio-group",
          "aria-required": @required || nil,
          "aria-disabled": @disabled || nil
        },
        {
          controller: "shadcn--radio-group",
          "shadcn--radio-group-name-value": @name,
          "shadcn--radio-group-value-value": @value
        }
      )
    end

    def group_classes
      cn(BASE_CLASSES, orientation_classes, class_name)
    end

    def orientation_classes
      case @orientation
      when :horizontal
        "flex flex-row gap-4"
      else
        "grid gap-3"
      end
    end

    # Render items from the items: data array
    def render_data_items
      return nil if @items_data.empty?

      safe_join(@items_data.map do |item|
        RadioGroupItemComponent.new(
          value: item[:value],
          id: item[:id] || generate_item_id(item[:value]),
          label: item[:label],
          disabled: @disabled || item[:disabled],
          group_name: @name,
          selected: @value.to_s == item[:value].to_s,
          data: item[:data] || {}
        ).render_in(view_context)
      end)
    end

    # Render items from with_item slot calls
    def render_slot_items
      return nil if items.empty?

      safe_join(items.map(&:to_s))
    end

    def generate_item_id(value)
      "#{@name}-#{value}".parameterize
    end
  end
end
