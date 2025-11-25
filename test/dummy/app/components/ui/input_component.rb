# frozen_string_literal: true

module Ui
  class InputComponent < BaseComponent
    def initialize(type: "text", name: nil, value: nil, placeholder: nil, disabled: false, class_name: nil, **html_options)
      @type = type
      @name = name
      @value = value
      @placeholder = placeholder
      @disabled = disabled
      @class_name = class_name
      @html_options = html_options
    end

    def call
      tag.input(
        type: @type,
        name: @name,
        value: @value,
        placeholder: @placeholder,
        disabled: @disabled,
        class: input_classes,
        **@html_options
      )
    end

    private

    def input_classes
      cn(
        "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
        @class_name
      )
    end
  end
end
