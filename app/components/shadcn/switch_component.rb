# frozen_string_literal: true

module Shadcn
  # Switch component for toggle inputs
  # Uses a custom button element with hidden input for form submission
  # Requires Stimulus controller for interactivity
  #
  # @example Basic switch
  #   <%= render Shadcn::SwitchComponent.new(name: "notifications") %>
  #
  # @example With integrated label
  #   <%= render Shadcn::SwitchComponent.new(name: "dark_mode") { "Enable dark mode" } %>
  #
  # @example Checked by default
  #   <%= render Shadcn::SwitchComponent.new(name: "active", checked: true) %>
  #
  class SwitchComponent < BaseComponent
    BASE_CLASSES = [
      "peer inline-flex h-5 w-9 shrink-0 cursor-pointer items-center rounded-full",
      "border-2 border-transparent shadow-sm transition-colors",
      "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background",
      "disabled:cursor-not-allowed disabled:opacity-50",
      "data-[state=checked]:bg-primary data-[state=unchecked]:bg-input"
    ].join(" ")

    THUMB_CLASSES = [
      "pointer-events-none block h-4 w-4 rounded-full bg-background shadow-lg ring-0",
      "transition-transform duration-150 data-[state=checked]:translate-x-4 data-[state=unchecked]:translate-x-0"
    ].join(" ")

    # @param name [String, nil] Input name attribute
    # @param id [String, nil] Input id attribute
    # @param value [String] Value when checked
    # @param checked [Boolean] Whether switch is on
    # @param disabled [Boolean] Whether switch is disabled
    # @param required [Boolean] Whether switch is required
    # @param unchecked_value [String, nil] Hidden value submitted when unchecked
    # @param include_hidden [Boolean] Whether to render the hidden unchecked value input
    def initialize(
      name: nil,
      id: nil,
      value: "1",
      checked: false,
      disabled: false,
      required: false,
      unchecked_value: "0",
      include_hidden: true,
      **options
    )
      super(**options)
      @name = name
      @id = id || (name ? "switch-#{name}" : nil)
      @value = value
      @checked = checked
      @disabled = disabled
      @required = required
      @unchecked_value = unchecked_value
      @include_hidden = include_hidden
    end

    private

    def hidden_input?
      @include_hidden && @name.present? && @unchecked_value
    end

    def hidden_input_attributes
      {
        type: "hidden",
        name: @name,
        value: @unchecked_value,
        autocomplete: "off"
      }
    end

    def checkbox_input_attributes
      {
        type: "checkbox",
        class: "sr-only",
        name: @name,
        id: @id,
        value: @value,
        checked: @checked || nil,
        disabled: @disabled || nil,
        required: @required || nil,
        "data-shadcn--switch-target": "input",
        tabindex: "-1"
      }.compact
    end

    def button_attributes
      html_options
        .merge(build_data)
        .merge(
          type: "button",
          role: "switch",
          class: switch_classes,
          disabled: @disabled || nil,
          "aria-checked": @checked,
          "aria-required": @required || nil,
          "data-state": state,
          "data-shadcn--switch-target": "button",
          "data-action": "click->shadcn--switch#toggle keydown->shadcn--switch#handleKeydown",
          tabindex: "0"
        )
        .compact
    end

    def has_label?
      content.present?
    end

    def state
      @checked ? "checked" : "unchecked"
    end

    def switch_classes
      cn(BASE_CLASSES, class_name)
    end
  end
end
