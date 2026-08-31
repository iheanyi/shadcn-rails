# frozen_string_literal: true

module Shadcn
  # Alert Dialog Cancel button component
  class AlertDialogCancelComponent < BaseComponent
    BASE_CLASSES = "mt-2 sm:mt-0 inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground h-9 px-4 py-2"

    def call
      content_tag(:button, content, button_attributes)
    end

    private

    def button_attributes
      attrs = {
        type: "button",
        class: merge_classes(BASE_CLASSES),
        "data-slot": "alert-dialog-cancel",
        "data-action": "click->shadcn--dialog#close"
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end
end
