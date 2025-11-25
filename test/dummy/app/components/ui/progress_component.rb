# frozen_string_literal: true

module Ui
  class ProgressComponent < BaseComponent
    def initialize(value: 0, max: 100, class_name: nil, **html_options)
      @value = value.to_i
      @max = max.to_i
      @class_name = class_name
      @html_options = html_options
    end

    def call
      tag.div(
        role: "progressbar",
        "aria-valuemin": 0,
        "aria-valuemax": @max,
        "aria-valuenow": @value,
        class: progress_classes,
        **@html_options
      ) do
        tag.div(class: "h-full w-full flex-1 bg-primary transition-all", style: indicator_style)
      end
    end

    private

    def progress_classes
      cn("relative h-4 w-full overflow-hidden rounded-full bg-secondary", @class_name)
    end

    def indicator_style
      percentage = @max.positive? ? (@value.to_f / @max * 100).clamp(0, 100) : 0
      "transform: translateX(-#{100 - percentage}%)"
    end
  end
end
