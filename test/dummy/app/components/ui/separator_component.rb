# frozen_string_literal: true

module Ui
  class SeparatorComponent < BaseComponent
    def initialize(orientation: :horizontal, class_name: nil, **html_options)
      @orientation = orientation.to_sym
      @class_name = class_name
      @html_options = html_options
    end

    def call
      tag.div(
        role: "separator",
        "aria-orientation": @orientation,
        class: separator_classes,
        **@html_options
      )
    end

    private

    def separator_classes
      cn(
        "shrink-0 bg-border",
        @orientation == :horizontal ? "h-[1px] w-full" : "h-full w-[1px]",
        @class_name
      )
    end
  end
end
