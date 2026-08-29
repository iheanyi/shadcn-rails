# frozen_string_literal: true

module Shadcn
  # Checkbox component using native <input type="checkbox">
  # Styled with CSS to match shadcn/ui design
  # Works without JavaScript
  #
  # @example Basic checkbox
  #   <%= render Shadcn::CheckboxComponent.new(name: "terms", id: "terms") %>
  #   <%= render Shadcn::LabelComponent.new(for: "terms") { "Accept terms" } %>
  #
  # @example Checked by default
  #   <%= render Shadcn::CheckboxComponent.new(name: "subscribe", checked: true) %>
  #
  # @example Disabled
  #   <%= render Shadcn::CheckboxComponent.new(name: "locked", disabled: true) %>
  #
  # @example With integrated label
  #   <%= render Shadcn::CheckboxComponent.new(name: "terms", id: "terms") { "Accept terms and conditions" } %>
  #
  class CheckboxComponent < BaseComponent
    BASE_CLASSES = [
      "shadcn-checkbox",
      "peer h-4 w-4 shrink-0 rounded-sm border border-primary",
      "focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-1",
      "disabled:cursor-not-allowed disabled:opacity-50",
      "cursor-pointer"
    ].join(" ")

    # @param name [String, nil] Input name attribute
    # @param id [String, nil] Input id attribute
    # @param value [String] Value when checked
    # @param checked [Boolean] Whether checkbox is checked
    # @param disabled [Boolean] Whether checkbox is disabled
    # @param required [Boolean] Whether checkbox is required
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
      @id = id || (name ? "checkbox-#{name}" : nil)
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

    def checkbox_attributes
      html_options
        .merge(build_data)
        .merge(
          type: "checkbox",
          name: @name,
          id: @id,
          value: @value,
          checked: @checked || nil,
          disabled: @disabled || nil,
          required: @required || nil,
          class: checkbox_classes
        )
        .compact
    end

    def checkbox_classes
      cn(BASE_CLASSES, class_name)
    end

    def has_label?
      content.present?
    end
  end
end
