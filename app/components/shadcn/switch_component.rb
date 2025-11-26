# frozen_string_literal: true

module Shadcn
  # Switch component using native <input type="checkbox">
  # Styled with CSS to look like a toggle switch
  # Works without JavaScript
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
  # @example With integrated label
  #   <%= render Shadcn::SwitchComponent.new(name: "notifications") { "Enable notifications" } %>
  #
  class SwitchComponent < BaseComponent
    BASE_CLASSES = [
      "shadcn-switch",
      "peer inline-flex shrink-0",
      "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background",
      "disabled:cursor-not-allowed disabled:opacity-50"
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
            hidden_input,
            switch_input,
            content_tag(:span, content, class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70")
          ])
        end
      else
        # Render just the switch (for use with external labels)
        safe_join([hidden_input, switch_input].compact)
      end
    end

    private

    def hidden_input
      # Include hidden input with "0" value for unchecked state (Rails convention)
      return unless @name

      tag(:input,
        type: "hidden",
        name: @name,
        value: "0",
        autocomplete: "off"
      )
    end

    def switch_input
      tag(:input, input_attributes)
    end

    def input_attributes
      attrs = {
        type: "checkbox",
        role: "switch",
        name: @name,
        id: @id,
        value: @value,
        class: cn(BASE_CLASSES, class_name),
        disabled: @disabled || nil,
        checked: @checked || nil,
        required: @required || nil,
        "aria-checked": @checked.to_s
      }
      attrs.merge!(html_options.except(:class))
      attrs.compact
    end
  end
end
