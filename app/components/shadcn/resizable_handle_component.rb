# frozen_string_literal: true

module Shadcn
  # Draggable handle between resizable panels
  class ResizableHandleComponent < BaseComponent
    BASE_CLASSES = "relative flex w-px items-center justify-center bg-border after:absolute after:inset-y-0 after:left-1/2 after:w-1 after:-translate-x-1/2 focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-1 focus-visible:outline-hidden aria-[orientation=horizontal]:h-px aria-[orientation=horizontal]:w-full aria-[orientation=horizontal]:after:left-0 aria-[orientation=horizontal]:after:h-1 aria-[orientation=horizontal]:after:w-full aria-[orientation=horizontal]:after:translate-x-0 aria-[orientation=horizontal]:after:-translate-y-1/2 [&[aria-orientation=horizontal]>div]:rotate-90"

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
        "data-slot": "resizable-handle",
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
          "z-10 flex h-4 w-3 items-center justify-center rounded-xs border bg-border"
        )
      }
    end

    def grip_icon
      content_tag(:svg, grip_dots_vertical, xmlns: "http://www.w3.org/2000/svg", width: "10", height: "16", viewBox: "0 0 10 16", fill: "currentColor", class: "size-2.5")
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

    def class_names
      cn(
        BASE_CLASSES,
        @direction == :horizontal ? "cursor-col-resize" : "cursor-row-resize",
        @class_name
      )
    end
  end
end
