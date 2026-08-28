# frozen_string_literal: true

module Shadcn
  # Hover Card Content component
  class HoverCardContentComponent < BaseComponent
    BASE_CLASSES = "shadcn-hover-card z-50 w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2"

    # @param side [Symbol] :top, :right, :bottom, or :left
    # @param align [Symbol] :start, :center, or :end
    def initialize(side: :bottom, align: :center, **options, &block)
      super(**options, &block)
      @side = side
      @align = align
    end

    def call
      content_tag(:div, content, content_attributes)
    end

    private

    def content_attributes
      attrs = {
        class: merge_classes(BASE_CLASSES),
        role: "tooltip",
        "data-state": "closed",
        "data-side": @side.to_s,
        "data-align": @align.to_s,
        "data-shadcn--hover-card-target": "content",
        style: "display: none; position: absolute;"
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end
end
