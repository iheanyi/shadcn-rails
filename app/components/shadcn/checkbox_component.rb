# frozen_string_literal: true

module Shadcn
  # Checkbox component for boolean inputs
  # Matches shadcn/ui Checkbox component
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
  class CheckboxComponent < BaseComponent
    BASE_CLASSES = "peer h-4 w-4 shrink-0 rounded-sm border border-primary shadow focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground"

    # @param name [String, nil] Input name attribute
    # @param id [String, nil] Input id attribute
    # @param value [String] Value when checked
    # @param checked [Boolean] Whether checkbox is checked
    # @param disabled [Boolean] Whether checkbox is disabled
    # @param required [Boolean] Whether checkbox is required
    # @param indeterminate [Boolean] Whether checkbox shows indeterminate state
    def initialize(
      name: nil,
      id: nil,
      value: "1",
      checked: false,
      disabled: false,
      required: false,
      indeterminate: false,
      **options
    )
      super(**options)
      @name = name
      @id = id
      @value = value
      @checked = checked
      @disabled = disabled
      @required = required
      @indeterminate = indeterminate
    end

    def call
      # Custom checkbox using button with hidden input
      content_tag(:span, class: "inline-flex items-center") do
        safe_join([
          hidden_input,
          checkbox_button
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

    def checkbox_button
      content_tag(:button,
        checkbox_indicator,
        checkbox_attributes
      )
    end

    def checkbox_indicator
      # Checkmark icon (rendered when checked)
      content_tag(:span, class: "flex items-center justify-center text-current") do
        if @indeterminate
          # Minus icon for indeterminate
          content_tag(:svg,
            content_tag(:path, nil, d: "M5 12h14", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round"),
            xmlns: "http://www.w3.org/2000/svg",
            width: "12",
            height: "12",
            viewBox: "0 0 24 24",
            fill: "none",
            class: "h-3 w-3"
          )
        else
          # Checkmark icon
          content_tag(:svg,
            content_tag(:path, nil, d: "M20 6 9 17l-5-5", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round", "stroke-linejoin": "round"),
            xmlns: "http://www.w3.org/2000/svg",
            width: "12",
            height: "12",
            viewBox: "0 0 24 24",
            fill: "none",
            class: cn("h-3 w-3", @checked ? "" : "opacity-0")
          )
        end
      end
    end

    def checkbox_attributes
      attrs = {
        type: "button",
        role: "checkbox",
        id: @id,
        name: @name ? nil : @name, # Name goes on hidden input
        value: @value,
        class: merge_classes(BASE_CLASSES),
        disabled: @disabled || nil,
        "aria-checked": @indeterminate ? "mixed" : @checked.to_s,
        "aria-required": @required ? "true" : nil,
        "data-state": @indeterminate ? "indeterminate" : (@checked ? "checked" : "unchecked"),
        "data-controller": "shadcn--checkbox",
        "data-action": "click->shadcn--checkbox#toggle",
        "data-shadcn--checkbox-checked-value": @checked.to_s,
        "data-shadcn--checkbox-name-value": @name
      }
      attrs.merge!(html_options.except(:name))
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
