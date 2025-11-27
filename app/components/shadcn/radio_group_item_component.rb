# frozen_string_literal: true

module Shadcn
  # Individual radio button item using native <input type="radio">
  # Styled with CSS to match shadcn/ui design
  # Works without JavaScript
  #
  # @example With label parameter (Tier 2 API)
  #   <%= group.with_item(value: "free", label: "Free") %>
  #
  # @example With block content (backward compatible)
  #   <%= group.with_item(value: "free") { "Free" } %>
  #
  # @example Without label (for external labels)
  #   <%= group.with_item(value: "free", id: "plan-free") %>
  #
  class RadioGroupItemComponent < BaseComponent
    # CSS classes for the native radio input styled as a custom circle
    ITEM_CLASSES = [
      # Reset native appearance
      "appearance-none",
      # Size and shape
      "aspect-square h-4 w-4 shrink-0 rounded-full",
      # Border and colors
      "border border-primary",
      # Ring focus style
      "focus:outline-none focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-1",
      # Disabled state
      "disabled:cursor-not-allowed disabled:opacity-50",
      # Custom checked indicator using CSS
      "relative",
      # Checked state - show inner circle
      "checked:bg-primary",
      # Transition for smooth state changes
      "transition-colors"
    ].join(" ")

    LABEL_CLASSES = "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"

    # @param value [String] The value for this radio option
    # @param id [String, nil] HTML id attribute
    # @param label [String, nil] Label text (alternative to block content)
    # @param disabled [Boolean] Whether this option is disabled
    # @param group_name [String, nil] The name attribute from parent group
    # @param selected [Boolean] Whether this option is selected
    def initialize(
      value:,
      id: nil,
      label: nil,
      disabled: false,
      group_name: nil,
      selected: false,
      **options,
      &block
    )
      super(**options, &block)
      @value = value
      @id = id || "radio-#{value}"
      @label = label
      @disabled = disabled
      @group_name = group_name
      @selected = selected
    end

    def call
      label_text = @label || content.presence

      if label_text.present?
        # Render with integrated label
        content_tag(:label, label_wrapper_attributes) do
          safe_join([
            radio_input,
            content_tag(:span, label_text, class: LABEL_CLASSES)
          ])
        end
      else
        # Render just the radio input (for use with external labels)
        radio_input
      end
    end

    private

    def radio_input
      tag(:input, input_attributes)
    end

    def input_attributes
      attrs = {
        type: "radio",
        name: @group_name,
        value: @value,
        id: @id,
        class: cn(ITEM_CLASSES, "peer", class_name),
        disabled: @disabled || nil,
        checked: @selected || nil
      }
      attrs.merge!(html_options.except(:class))
      attrs.compact
    end

    def label_wrapper_attributes
      {
        class: "flex items-center space-x-2 cursor-pointer",
        for: @id
      }
    end
  end
end
