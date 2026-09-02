# frozen_string_literal: true

module Shadcn
  # Slider component for selecting values within a range
  # Uses a native range input with custom styling for reliability
  # Matches shadcn/ui Slider component appearance
  #
  # @example Basic usage
  #   <%= render Shadcn::SliderComponent.new(name: "volume", value: 50, max: 100) %>
  #
  # @example With step
  #   <%= render Shadcn::SliderComponent.new(name: "rating", value: 3, min: 1, max: 5, step: 1) %>
  #
  class SliderComponent < BaseComponent
    BASE_CLASSES = "shadcn-slider w-full h-1.5 rounded-full appearance-none cursor-pointer bg-muted focus:outline-none disabled:pointer-events-none disabled:opacity-50"

    # @param name [String] Input name attribute
    # @param value [Numeric] Current value
    # @param min [Numeric] Minimum value
    # @param max [Numeric] Maximum value
    # @param step [Numeric] Step increment
    # @param disabled [Boolean] Whether slider is disabled
    def initialize(
      name: nil,
      value: 0,
      min: 0,
      max: 100,
      step: 1,
      disabled: false,
      **options
    )
      super(**options)
      @name = name
      @value = value.to_f
      @min = min.to_f
      @max = max.to_f
      @step = step.to_f
      @disabled = disabled
    end

    private

    def slider_attributes
      merge_html_attributes(
        {
          type: "range",
          name: @name,
          value: @value,
          min: @min,
          max: @max,
          step: @step,
          disabled: @disabled || nil,
          class: slider_classes,
          style: slider_style,
          "data-controller": "shadcn--slider",
          "data-action": "input->shadcn--slider#updateStyle"
        }
      )
    end

    def slider_classes
      merge_classes(BASE_CLASSES)
    end

    def slider_style
      # CSS custom property for the fill percentage
      "--slider-fill: #{percentage}%"
    end

    def percentage
      return 0 if @max == @min
      ((@value - @min) / (@max - @min) * 100).round(2)
    end
  end
end
