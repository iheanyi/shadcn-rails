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

    def call
      content_tag(:div, group_content, group_attributes)
    end

    private

    def group_content
      safe_join([
        hidden_input,
        items.map(&:to_s)
      ].flatten.compact)
    end

    def hidden_input
      return unless @name

      tag(:input,
        type: "hidden",
        name: @name,
        value: Array(@value).join(","),
        "data-shadcn--toggle-group-target": "input"
      )
    end

    def group_attributes
      attrs = {
        role: "group",
        class: merge_classes(BASE_CLASSES),
        "data-controller": "shadcn--toggle-group",
        "data-shadcn--toggle-group-type-value": @type.to_s,
        "data-shadcn--toggle-group-value-value": Array(@value).join(",")
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Individual toggle item within a group
  class ToggleGroupItemComponent < BaseComponent
    VARIANTS = {
      default: "bg-transparent",
      outline: "border border-input bg-transparent shadow-sm hover:bg-accent hover:text-accent-foreground"
    }.freeze

    SIZES = {
      sm: "h-8 px-2 min-w-8",
      default: "h-9 px-2.5 min-w-9",
      lg: "h-10 px-3 min-w-10"
    }.freeze

    BASE_CLASSES = "inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground"

    def initialize(
      value:,
      pressed: false,
      disabled: false,
      aria_label: nil,
      variant: :default,
      size: :default,
      group_type: :single,
      **options
    )
      super(**options)
      @value = value
      @pressed = pressed
      @disabled = disabled
      @aria_label = aria_label
      @variant = variant
      @size = size
      @group_type = group_type
    end

    def call
      content_tag(:button, content, button_attributes)
    end

    private

    def button_attributes
      attrs = {
        type: "button",
        class: cn(BASE_CLASSES, VARIANTS[@variant], SIZES[@size], class_name),
        disabled: @disabled || nil,
        "aria-pressed": @pressed.to_s,
        "aria-label": @aria_label,
        "data-state": @pressed ? "on" : "off",
        "data-value": @value,
        "data-shadcn--toggle-group-target": "item",
        "data-action": "click->shadcn--toggle-group#toggle"
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end
end
