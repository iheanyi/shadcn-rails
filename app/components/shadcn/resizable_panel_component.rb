# frozen_string_literal: true

module Shadcn
  # Individual panel within a ResizablePanelGroup
  class ResizablePanelComponent < BaseComponent
    # @param default_size [Integer] Initial size percentage (0-100)
    # @param min_size [Integer] Minimum size percentage
    # @param max_size [Integer] Maximum size percentage
    # @param direction [Symbol] Direction passed from parent group
    def initialize(default_size: nil, min_size: nil, max_size: nil, direction: :horizontal, **options)
      super(**options)
      @default_size = default_size
      @min_size = min_size
      @max_size = max_size
      @direction = direction
    end

    def call
      content_tag(:div, content, panel_attributes)
    end

    private

    def panel_attributes
      {
        class: class_names,
        style: panel_style,
        "data-slot": "resizable-panel",
        "data-panel": "",
        "data-panel-size": @default_size,
        "data-shadcn--resizable-target": "panel",
        "data-min-size": @min_size,
        "data-max-size": @max_size
      }.merge(html_options).compact
    end

    def panel_style
      return unless @default_size

      if @direction == :horizontal
        "flex-basis: #{@default_size}%; flex-grow: 0; flex-shrink: 0;"
      else
        "flex-basis: #{@default_size}%; flex-grow: 0; flex-shrink: 0;"
      end
    end

    def class_names
      cn(
        "overflow-hidden",
        @class_name
      )
    end
  end
end
