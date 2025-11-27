# frozen_string_literal: true

module Shadcn
  # Individual radio button item using native <input type="radio">
  # Styled with CSS to match shadcn/ui design
  # Works without JavaScript
  #
  # @example With label parameter (Tier 2 API)
  #   <%= group.with_item(value: "free", label: "Free") %>
  #
  # @example With label and description
  #   <%= group.with_item(value: "pro", label: "Pro", description: "For professional developers") %>
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
    DESCRIPTION_CLASSES = "text-sm text-muted-foreground"

    # @param value [String] The value for this radio option
    # @param id [String, nil] HTML id attribute
    # @param label [String, nil] Label text (alternative to block content)
    # @param description [String, nil] Description text displayed below the label
    # @param disabled [Boolean] Whether this option is disabled
    # @param group_name [String, nil] The name attribute from parent group
    # @param selected [Boolean] Whether this option is selected
    def initialize(
      value:,
      id: nil,
      label: nil,
      description: nil,
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
      @description = description
      @disabled = disabled
      @group_name = group_name
      @selected = selected
    end

    def call
      label_text = @label || content.presence

      if label_text.present?
        if @description.present?
          # Render with label and description
          render_with_description(label_text)
        else
          # Render with integrated label only
          content_tag(:label, label_wrapper_attributes) do
            safe_join([
              radio_input,
              content_tag(:span, label_text, class: LABEL_CLASSES)
            ])
          end
        end
      else
        # Render just the radio input (for use with external labels)
        radio_input
      end
    end

    private

    def render_with_description(label_text)
      content_tag(:div, class: "flex items-start space-x-3") do
        safe_join([
          content_tag(:div, class: "mt-0.5") { radio_input },
          content_tag(:div, class: "grid gap-1.5 leading-none") do
            safe_join([
              content_tag(:label, label_text, class: cn(LABEL_CLASSES, "cursor-pointer"), for: @id),
              content_tag(:p, @description, class: DESCRIPTION_CLASSES)
            ])
          end
        ])
      end
    end

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
