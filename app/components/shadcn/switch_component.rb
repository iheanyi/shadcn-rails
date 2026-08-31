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
      "peer group/switch inline-flex shrink-0 items-center rounded-full border border-transparent shadow-xs",
      "transition-all outline-none focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50",
      "disabled:cursor-not-allowed disabled:opacity-50 h-[1.15rem] w-8 data-[size=default]:h-[1.15rem] data-[size=default]:w-8",
      "data-[state=checked]:bg-primary",
      "data-[state=unchecked]:bg-input dark:data-[state=unchecked]:bg-input/80"
    ].join(" ")

    THUMB_CLASSES = [
      "pointer-events-none block size-4 rounded-full bg-background ring-0 transition-transform",
      "group-data-[size=default]/switch:size-4",
      "data-[state=checked]:translate-x-[calc(100%-2px)] data-[state=unchecked]:translate-x-0",
      "dark:data-[state=checked]:bg-primary-foreground dark:data-[state=unchecked]:bg-foreground"
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
      @include_hidden && !@disabled && @name.present? && @unchecked_value
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
      attrs = merge_html_attributes(
        {
          type: "button",
          role: "switch",
          class: switch_classes,
          disabled: @disabled || nil,
          "aria-checked": @checked,
          "aria-required": @required || nil,
          "data-slot": "switch",
          "data-size": "default",
          "data-state": state,
          "data-shadcn--switch-target": "button",
          "data-action": "click->shadcn--switch#toggle keydown->shadcn--switch#handleKeydown",
          tabindex: "0"
        }
      )

      attrs.except("data-controller")
    end

    def wrapper_attributes
      {
        class: "inline-flex items-center",
        "data-controller": controller_tokens,
        "data-shadcn--switch-checked-value": @checked
      }
    end

    def thumb_attributes
      {
        class: THUMB_CLASSES,
        "data-slot": "switch-thumb",
        "data-state": state,
        "data-shadcn--switch-target": "thumb"
      }
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

    def controller_tokens
      (["shadcn--switch"] + host_controller_tokens).flat_map { |value| value.to_s.split }.uniq.join(" ")
    end

    def host_controller_tokens
      data_controller_values(data) + data_controller_values(html_options)
    end

    def data_controller_values(attributes)
      attributes.each_with_object([]) do |(key, value), values|
        key_string = key.to_s

        if key_string == "data"
          values.concat(data_controller_values(value || {}))
        elsif key_string.delete_prefix("data-") == "controller" && value.present?
          values << value
        end
      end
    end
  end
end
