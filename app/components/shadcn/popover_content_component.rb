# frozen_string_literal: true

module Shadcn
  # Popover Content component
  class PopoverContentComponent < BaseComponent
    BASE_CLASSES = "z-50 w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-hidden data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95"

    def call
      content_tag(:div, content, content_attributes)
    end

    private

    def content_attributes
      {
        class: merge_classes(BASE_CLASSES),
        "data-shadcn--popover-target": "content",
        "data-state": "closed",
        "data-side": "bottom",
        tabindex: "-1",
        hidden: true
      }
    end
  end
end
