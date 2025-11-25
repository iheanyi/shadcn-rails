# frozen_string_literal: true

module Ui
  class SeparatorComponent < BaseComponent
    def initialize(orientation: :horizontal, decorative: true, class_name: nil, **html_options)
      @orientation = orientation.to_sym
      @decorative = decorative
      @class_name = class_name
      @html_options = html_options
    end

    def call
      tag.div(
        role: @decorative ? "none" : "separator",
        "aria-orientation": @orientation == :vertical ? "vertical" : nil,
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
