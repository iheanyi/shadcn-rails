# frozen_string_literal: true

module Shadcn
  # Draggable handle between resizable panels
  class ResizableHandleComponent < BaseComponent
    HORIZONTAL_CLASSES = "w-px bg-border cursor-col-resize hover:bg-primary/50 transition-colors"
    VERTICAL_CLASSES = "h-px bg-border cursor-row-resize hover:bg-primary/50 transition-colors"

    # @param with_handle [Boolean] Whether to show a visual handle indicator
    # @param direction [Symbol] Direction passed from parent group
    def initialize(with_handle: false, direction: :horizontal, **options)
      super(**options)
      @with_handle = with_handle
      @direction = direction
    end

    def call
      content_tag(:div, handle_content, handle_attributes)
    end

    private

    def handle_content
      return nil unless @with_handle

      content_tag(:div, grip_icon, handle_indicator_attributes)
    end

    def handle_attributes
      {
        class: class_names,
        "data-panel-resize-handle": "",
        "data-shadcn--resizable-target": "handle",
        "data-action": "mousedown->shadcn--resizable#startResize touchstart->shadcn--resizable#startResize",
        role: "separator",
        tabindex: "0",
        "aria-orientation": @direction == :horizontal ? "vertical" : "horizontal"
      }.merge(html_options).compact
    end

    def handle_indicator_attributes
      {
        class: cn(
          "z-10 flex items-center justify-center rounded-sm border bg-border",
          @direction == :horizontal ? "h-4 w-3" : "w-4 h-3"
        )
      }
    end

    def grip_icon
      if @direction == :horizontal
        # Vertical grip dots for horizontal resize
        content_tag(:svg, grip_dots_vertical, xmlns: "http://www.w3.org/2000/svg", width: "10", height: "16", viewBox: "0 0 10 16", fill: "currentColor", class: "h-2.5 w-2.5")
      else
        # Horizontal grip dots for vertical resize
        content_tag(:svg, grip_dots_horizontal, xmlns: "http://www.w3.org/2000/svg", width: "16", height: "10", viewBox: "0 0 16 10", fill: "currentColor", class: "h-2.5 w-2.5")
      end
    end

    def grip_dots_vertical
      # GripVertical icon - 6 dots in 2 columns
      safe_join([
        content_tag(:circle, nil, cx: "3", cy: "2", r: "1"),
        content_tag(:circle, nil, cx: "7", cy: "2", r: "1"),
        content_tag(:circle, nil, cx: "3", cy: "8", r: "1"),
        content_tag(:circle, nil, cx: "7", cy: "8", r: "1"),
        content_tag(:circle, nil, cx: "3", cy: "14", r: "1"),
        content_tag(:circle, nil, cx: "7", cy: "14", r: "1")
      ])
    end

    def grip_dots_horizontal
      # GripHorizontal icon - 6 dots in 2 rows
      safe_join([
        content_tag(:circle, nil, cx: "2", cy: "3", r: "1"),
        content_tag(:circle, nil, cx: "8", cy: "3", r: "1"),
        content_tag(:circle, nil, cx: "14", cy: "3", r: "1"),
        content_tag(:circle, nil, cx: "2", cy: "7", r: "1"),
        content_tag(:circle, nil, cx: "8", cy: "7", r: "1"),
        content_tag(:circle, nil, cx: "14", cy: "7", r: "1")
      ])
    end

    def class_names
      base = @direction == :horizontal ? HORIZONTAL_CLASSES : VERTICAL_CLASSES
      cn(
        "relative flex items-center justify-center",
        base,
        @with_handle && (@direction == :horizontal ? "w-2" : "h-2"),
        "focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-1",
        "after:absolute",
        @direction == :horizontal ? "after:inset-y-0 after:left-1/2 after:w-1 after:-translate-x-1/2" : "after:inset-x-0 after:top-1/2 after:h-1 after:-translate-y-1/2",
        "[&[data-state=dragging]]:bg-primary",
        @class_name
      )
    end
  end
end
