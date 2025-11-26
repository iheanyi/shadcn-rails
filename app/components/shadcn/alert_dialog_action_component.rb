# frozen_string_literal: true

module Shadcn
  # Alert Dialog Action button component
  class AlertDialogActionComponent < BaseComponent
    BASE_CLASSES = "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground shadow hover:bg-primary/90 h-9 px-4 py-2"

    def call
      content_tag(:button, content, button_attributes)
    end

    private

    def button_attributes
      attrs = {
        type: "button",
        class: merge_classes(BASE_CLASSES),
        "data-action": "click->shadcn--dialog#close"
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end
end
