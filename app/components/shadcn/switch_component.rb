# frozen_string_literal: true

module Shadcn
  # Switch component for toggle inputs
  # Matches shadcn/ui Switch component
  #
  # @example Basic switch
  #   <%= render Shadcn::SwitchComponent.new(name: "notifications") %>
  #
  # @example With label
  #   <label class="flex items-center gap-2">
  #     <%= render Shadcn::SwitchComponent.new(name: "dark_mode") %>
  #     Enable dark mode
  #   </label>
  #
  # @example Checked by default
  #   <%= render Shadcn::SwitchComponent.new(name: "active", checked: true) %>
  #
  class SwitchComponent < BaseComponent
    BASE_CLASSES = "peer inline-flex h-5 w-9 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=unchecked]:bg-input"
    THUMB_CLASSES = "pointer-events-none block h-4 w-4 rounded-full bg-background shadow-lg ring-0 transition-transform data-[state=checked]:translate-x-4 data-[state=unchecked]:translate-x-0"

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
      @id = id
      @value = value
      @checked = checked
      @disabled = disabled
      @required = required
    end

    def call
      content_tag(:span, class: "inline-flex items-center") do
        safe_join([
          hidden_input,
          switch_button
        ])
      end
    end

    private

    def hidden_input
      tag(:input,
        type: "hidden",
        name: @name,
        value: "0"
      ) if @name
    end

    def switch_button
      content_tag(:button, switch_thumb, switch_attributes)
    end

    def switch_thumb
      content_tag(:span, "", class: THUMB_CLASSES, "data-state": state)
    end

    def state
      @checked ? "checked" : "unchecked"
    end

    def switch_attributes
      attrs = {
        type: "button",
        role: "switch",
        id: @id,
        value: @value,
        class: merge_classes(BASE_CLASSES),
        disabled: @disabled || nil,
        "aria-checked": @checked.to_s,
        "aria-required": @required ? "true" : nil,
        "data-state": state,
        "data-controller": "shadcn--switch",
        "data-action": "click->shadcn--switch#toggle",
        "data-shadcn--switch-checked-value": @checked.to_s,
        "data-shadcn--switch-name-value": @name
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
