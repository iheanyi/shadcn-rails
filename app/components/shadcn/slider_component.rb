# frozen_string_literal: true

module Shadcn
  # Slider component for selecting values within a range
  # Matches shadcn/ui Slider component
  #
  # @example Basic usage
  #   <%= render Shadcn::SliderComponent.new(name: "volume", value: 50, max: 100) %>
  #
  # @example With step
  #   <%= render Shadcn::SliderComponent.new(name: "rating", value: 3, min: 1, max: 5, step: 1) %>
  #
  class SliderComponent < BaseComponent
    TRACK_CLASSES = "relative w-full h-1.5 grow overflow-hidden rounded-full bg-primary/20"
    RANGE_CLASSES = "absolute h-full bg-primary"
    THUMB_CLASSES = "block h-4 w-4 rounded-full border border-primary/50 bg-background shadow transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50"

    # @param name [String] Input name attribute
    # @param value [Numeric] Current value
    # @param min [Numeric] Minimum value
    # @param max [Numeric] Maximum value
    # @param step [Numeric] Step increment
    # @param disabled [Boolean] Whether slider is disabled
    # @param orientation [Symbol] :horizontal or :vertical
    def initialize(
      name: nil,
      value: 0,
      min: 0,
      max: 100,
      step: 1,
      disabled: false,
      orientation: :horizontal,
      **options
    )
      super(**options)
      @name = name
      @value = value.to_f
      @min = min.to_f
      @max = max.to_f
      @step = step.to_f
      @disabled = disabled
      @orientation = orientation
    end

    def call
      content_tag(:div, slider_attributes) do
        safe_join([
          hidden_input,
          track,
          thumb
        ])
      end
    end

    private

    def slider_attributes
      attrs = {
        role: "slider",
        class: merge_classes("relative flex w-full touch-none select-none items-center"),
        "aria-valuemin": @min,
        "aria-valuemax": @max,
        "aria-valuenow": @value,
        "aria-orientation": @orientation.to_s,
        "aria-disabled": @disabled ? "true" : nil,
        tabindex: @disabled ? nil : "0",
        "data-controller": "shadcn--slider",
        "data-shadcn--slider-min-value": @min,
        "data-shadcn--slider-max-value": @max,
        "data-shadcn--slider-step-value": @step,
        "data-shadcn--slider-value-value": @value,
        "data-shadcn--slider-name-value": @name,
        "data-shadcn--slider-disabled-value": @disabled.to_s,
        "data-action": "keydown->shadcn--slider#handleKeydown mousedown->shadcn--slider#startDrag touchstart->shadcn--slider#startDrag"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end

    def hidden_input
      tag(:input,
        type: "hidden",
        name: @name,
        value: @value,
        "data-shadcn--slider-target": "input"
      ) if @name
    end

    def track
      content_tag(:div, class: TRACK_CLASSES, "data-shadcn--slider-target": "track") do
        content_tag(:div, "", class: RANGE_CLASSES, style: "width: #{percentage}%", "data-shadcn--slider-target": "range")
      end
    end

    def thumb
      content_tag(:div,
        "",
        class: THUMB_CLASSES,
        style: "position: absolute; left: calc(#{percentage}% - 8px);",
        "data-shadcn--slider-target": "thumb",
        tabindex: @disabled ? nil : "0"
      )
    end

    def percentage
      return 0 if @max == @min
      ((@value - @min) / (@max - @min) * 100).round(2)
    end
  end
end
