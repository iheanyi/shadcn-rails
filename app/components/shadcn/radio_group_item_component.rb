# frozen_string_literal: true

module Shadcn
  # Individual radio button item using native <input type="radio">
  # Styled with CSS to match shadcn/ui design
  # Works without JavaScript
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

    def initialize(
      value:,
      id: nil,
      disabled: false,
      group_name: nil,
      selected: false,
      **options,
      &block
    )
      super(**options, &block)
      @value = value
      @id = id || "radio-#{value}"
      @disabled = disabled
      @group_name = group_name
      @selected = selected
    end

    def call
      if content.present?
        # Render with integrated label if block content provided
        content_tag(:label, label_wrapper_attributes) do
          safe_join([
            radio_input,
            content_tag(:span, content, class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70")
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
