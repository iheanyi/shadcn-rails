# frozen_string_literal: true

module Ui
  class TextareaComponent < BaseComponent
    def initialize(name: nil, value: nil, placeholder: nil, rows: 3, disabled: false, class_name: nil, **html_options)
      @name = name
      @value = value
      @placeholder = placeholder
      @rows = rows
      @disabled = disabled
      @class_name = class_name
      @html_options = html_options
    end

    def call
      tag.textarea(
        @value,
        name: @name,
        placeholder: @placeholder,
        rows: @rows,
        disabled: @disabled,
        class: textarea_classes,
        **@html_options
      )
    end

    private

    def textarea_classes
      cn(
        "flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
        @class_name
      )
    end
  end
end
