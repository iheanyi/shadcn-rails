# frozen_string_literal: true

module Shadcn
  # Toggle Group component for grouping related toggles
  # Matches shadcn/ui ToggleGroup component
  #
  # @example Single selection
  #   <%= render Shadcn::ToggleGroupComponent.new(type: :single, name: "alignment") do |group| %>
  #     <% group.with_item(value: "left", aria_label: "Align left") { icon_left } %>
  #     <% group.with_item(value: "center", aria_label: "Align center") { icon_center } %>
  #     <% group.with_item(value: "right", aria_label: "Align right") { icon_right } %>
  #   <% end %>
  #
  # @example Multiple selection with outline variant
  #   <%= render Shadcn::ToggleGroupComponent.new(type: :multiple, variant: :outline) do |group| %>
  #     <% group.with_item(value: "bold") { "B" } %>
  #     <% group.with_item(value: "italic") { "I" } %>
  #     <% group.with_item(value: "underline") { "U" } %>
  #   <% end %>
  #
  class ToggleGroupComponent < BaseComponent
    BASE_CLASSES = "inline-flex items-center justify-center gap-1 rounded-lg"

    renders_many :items, ->(value:, pressed: false, disabled: false, aria_label: nil, **options, &block) do
      ToggleGroupItemComponent.new(
        value: value,
        pressed: pressed,
        disabled: disabled,
        aria_label: aria_label,
        variant: @variant,
        size: @size,
        group_type: @type,
        **options,
        &block
      )
    end

    # @param type [Symbol] :single or :multiple selection mode
    # @param variant [Symbol] :default or :outline
    # @param size [Symbol] :sm, :default, or :lg
    # @param value [String, Array] Currently selected value(s)
    # @param name [String] Form field name
    def initialize(
      type: :single,
      variant: :default,
      size: :default,
      value: nil,
      name: nil,
      **options
    )
      super(**options)
      @type = type
      @variant = variant
      @size = size
      @value = value
      @name = name
    end

    private

    def group_attributes
      merge_html_attributes(
        {
          role: "group",
          class: group_classes
        },
        {
          controller: "shadcn--toggle-group",
          "shadcn--toggle-group-type-value": @type,
          "shadcn--toggle-group-value-value": value_string
        }
      )
    end

    def hidden_input_attributes
      {
        type: "hidden",
        name: @name,
        value: value_string,
        "data-shadcn--toggle-group-target": "input"
      }
    end

    def group_classes
      merge_classes(BASE_CLASSES)
    end

    def has_name?
      @name.present?
    end

    def value_string
      Array(@value).join(",")
    end
  end
end
