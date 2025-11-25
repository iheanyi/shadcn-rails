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
        # Matching shadcn/ui textarea
        "flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
        @class_name
      )
    end
  end
end
