# frozen_string_literal: true

module Shadcn
  # Alert Dialog Content component
  class AlertDialogContentComponent < BaseComponent
    OVERLAY_CLASSES = "shadcn-overlay fixed inset-0 z-50 bg-black/50 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:animate-in data-[state=open]:fade-in-0"
    CONTENT_CLASSES = "shadcn-dialog-content fixed top-[50%] left-[50%] z-50 grid w-full max-w-[calc(100%-2rem)] translate-x-[-50%] translate-y-[-50%] gap-4 rounded-lg border bg-background p-6 shadow-lg duration-200 outline-none data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95 sm:max-w-lg"

    renders_one :header, lambda { |**options|
      AlertDialogHeaderComponent.new(**options)
    }
    renders_one :footer, lambda { |**options|
      AlertDialogFooterComponent.new(**options)
    }

    def call
      content_tag(:template, content_wrapper, { "data-shadcn--dialog-target": "template" })
    end

    private

    def content_wrapper
      safe_join([
        overlay,
        dialog_panel
      ])
    end

    def overlay
      content_tag(:div, "", {
        class: OVERLAY_CLASSES,
        "data-shadcn--dialog-target": "overlay",
        "data-state": "closed",
        "aria-hidden": "true"
      })
    end

    def dialog_panel
      content_tag(:div, panel_content, {
        class: cn(CONTENT_CLASSES, class_name),
        role: "alertdialog",
        "aria-modal": "true",
        "data-shadcn--dialog-target": "content",
        "data-state": "closed",
        tabindex: "-1"
      })
    end

    def panel_content
      safe_join([
        header,
        content,
        footer
      ].compact)
    end
  end
end
