# frozen_string_literal: true

module Shadcn
  # Progress component for showing completion status
  # Matches shadcn/ui Progress component
  #
  # @example Basic progress
  #   <%= render Shadcn::ProgressComponent.new(value: 60) %>
  #
  # @example With custom max
  #   <%= render Shadcn::ProgressComponent.new(value: 30, max: 50) %>
  #
  # @example Indeterminate (loading)
  #   <%= render Shadcn::ProgressComponent.new(indeterminate: true) %>
  #
  class ProgressComponent < BaseComponent
    BASE_CLASSES = "relative h-2 w-full overflow-hidden rounded-full bg-primary/20"
    INDICATOR_CLASSES = "h-full w-full flex-1 bg-primary transition-all"

    # @param value [Integer, Float, nil] Current progress value
    # @param max [Integer, Float] Maximum progress value
    # @param indeterminate [Boolean] Whether to show indeterminate state
    def initialize(value: nil, max: 100, indeterminate: false, **options)
      super(**options)
      @value = value
      @max = max
      @indeterminate = indeterminate
    end

    def call
      content_tag(:div, progress_indicator, progress_attributes)
    end

    private

    def progress_indicator
      content_tag(:div, "", indicator_attributes)
    end

    def progress_percentage
      return 0 if @value.nil? || @max.zero?
      [(@value.to_f / @max.to_f * 100).round, 100].min
    end

    def indicator_style
      if @indeterminate
        nil # Animation handled by CSS
      else
        "transform: translateX(-#{100 - progress_percentage}%)"
      end
    end

    def progress_attributes
      attrs = {
        class: merge_classes(BASE_CLASSES),
        role: "progressbar",
        "aria-valuemin": 0,
        "aria-valuemax": @max,
        "aria-valuenow": @indeterminate ? nil : @value,
        "data-state": @indeterminate ? "indeterminate" : "determinate",
        "data-value": @value,
        "data-max": @max
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end

    def indicator_attributes
      {
        class: cn(INDICATOR_CLASSES, @indeterminate ? "animate-progress-indeterminate" : ""),
        style: indicator_style,
        "data-state": @indeterminate ? "indeterminate" : "determinate"
      }
    end
  end
end
