# frozen_string_literal: true

module Shadcn
  # Input component for form fields
  # Matches shadcn/ui Input component
  #
  # @example Basic input
  #   <%= render Shadcn::InputComponent.new(name: "email", type: "email", placeholder: "Email") %>
  #
  # @example With label
  #   <%= render Shadcn::LabelComponent.new(for: "email") { "Email" } %>
  #   <%= render Shadcn::InputComponent.new(id: "email", name: "email", type: "email") %>
  #
  # @example Disabled input
  #   <%= render Shadcn::InputComponent.new(name: "locked", disabled: true, value: "Can't change") %>
  #
  # @example File input
  #   <%= render Shadcn::InputComponent.new(name: "file", type: "file") %>
  #
  class InputComponent < BaseComponent
    BASE_CLASSES = "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-base shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm"

    # @param type [String] Input type (text, email, password, etc.)
    # @param name [String, nil] Input name attribute
    # @param id [String, nil] Input id attribute
    # @param value [String, nil] Input value
    # @param placeholder [String, nil] Placeholder text
    # @param disabled [Boolean] Whether input is disabled
    # @param required [Boolean] Whether input is required
    # @param readonly [Boolean] Whether input is readonly
    # @param autofocus [Boolean] Whether to autofocus
    # @param autocomplete [String, nil] Autocomplete attribute
    # @param pattern [String, nil] Validation pattern
    # @param min [String, Integer, nil] Minimum value (for number/date inputs)
    # @param max [String, Integer, nil] Maximum value (for number/date inputs)
    # @param step [String, Integer, nil] Step value (for number inputs)
    # @param minlength [Integer, nil] Minimum length
    # @param maxlength [Integer, nil] Maximum length
    def initialize(
      type: "text",
      name: nil,
      id: nil,
      value: nil,
      placeholder: nil,
      disabled: false,
      required: false,
      readonly: false,
      autofocus: false,
      autocomplete: nil,
      pattern: nil,
      min: nil,
      max: nil,
      step: nil,
      minlength: nil,
      maxlength: nil,
      **options
    )
      super(**options)
      @type = type
      @name = name
      @id = id
      @value = value
      @placeholder = placeholder
      @disabled = disabled
      @required = required
      @readonly = readonly
      @autofocus = autofocus
      @autocomplete = autocomplete
      @pattern = pattern
      @min = min
      @max = max
      @step = step
      @minlength = minlength
      @maxlength = maxlength
    end

    private

    def input_classes
      merge_classes(BASE_CLASSES)
    end
  end
end
