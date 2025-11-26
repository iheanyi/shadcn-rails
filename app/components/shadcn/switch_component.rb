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
      "transition-transform data-[state=checked]:translate-x-4 data-[state=unchecked]:translate-x-0"
    ].join(" ")

    # @param name [String, nil] Input name attribute
    # @param id [String, nil] Input id attribute
    # @param value [String] Value when checked
    # @param checked [Boolean] Whether switch is on
    # @param disabled [Boolean] Whether switch is disabled
    # @param required [Boolean] Whether switch is required
    def initialize(
      name: nil,
      id: nil,
      value: "1",
      checked: false,
      disabled: false,
      required: false,
      **options
    )
      super(**options)
      @name = name
      @id = id || (name ? "switch-#{name}" : nil)
      @value = value
      @checked = checked
      @disabled = disabled
      @required = required
    end

    def call
      if content.present?
        # Render with integrated label
        content_tag(:label, class: "flex items-center gap-3 cursor-pointer") do
          safe_join([
            switch_wrapper,
            content_tag(:span, content, class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70")
          ])
        end
      else
        switch_wrapper
      end
    end

    private

    def switch_wrapper
      content_tag(:span, wrapper_attributes) do
        safe_join([
          hidden_unchecked_input,
          hidden_input,
          switch_button
        ].compact)
      end
    end

    def wrapper_attributes
      {
        class: "inline-flex items-center",
        "data-controller": "shadcn--switch",
        "data-shadcn--switch-checked-value": @checked.to_s
      }
    end

    def hidden_unchecked_input
      # Rails convention: hidden input with "0" for unchecked state
      return unless @name

      tag(:input,
        type: "hidden",
        name: @name,
        value: "0",
        autocomplete: "off"
      )
    end

    def hidden_input
      return unless @name

      tag(:input,
        type: "checkbox",
        name: @name,
        id: @id,
        value: @value,
        checked: @checked || nil,
        disabled: @disabled || nil,
        required: @required || nil,
        class: "sr-only",
        "data-shadcn--switch-target": "input",
        tabindex: "-1"
      )
    end

    def switch_button
      content_tag(:button, switch_thumb, switch_button_attributes)
    end

    def switch_thumb
      content_tag(:span, "", class: THUMB_CLASSES, "data-state": state, "data-shadcn--switch-target": "thumb")
    end

    def state
      @checked ? "checked" : "unchecked"
    end

    def switch_button_attributes
      attrs = {
        type: "button",
        role: "switch",
        class: cn(BASE_CLASSES, class_name),
        disabled: @disabled || nil,
        "aria-checked": @checked.to_s,
        "aria-required": @required ? "true" : nil,
        "data-state": state,
        "data-shadcn--switch-target": "button",
        "data-action": "click->shadcn--switch#toggle keydown->shadcn--switch#handleKeydown",
        tabindex: "0"
      }
      attrs.merge!(html_options.except(:class))
      attrs.compact
    end
  end
end
