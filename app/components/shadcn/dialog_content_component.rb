# frozen_string_literal: true

module Shadcn
  # Dialog Content component
  class DialogContentComponent < BaseComponent
    OVERLAY_CLASSES = "shadcn-overlay fixed inset-0 z-50 bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
    CONTENT_CLASSES = "shadcn-dialog-content fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%] data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg"
    CLOSE_CLASSES = "absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground"

    renders_one :header, lambda { |**options|
      DialogHeaderComponent.new(**options)
    }
    renders_one :title, lambda { |**options|
      DialogTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      DialogDescriptionComponent.new(**options)
    }
    renders_one :footer, lambda { |**options|
      DialogFooterComponent.new(**options)
    }
    renders_one :close_button

    def call
      # Portal container that will be moved to body
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
        "data-action": "click->shadcn--dialog#close",
        "data-state": "closed",
        "aria-hidden": "true"
      })
    end

    def dialog_panel
      content_tag(:div, panel_content, {
        class: cn(CONTENT_CLASSES, class_name),
        role: "dialog",
        "aria-modal": "true",
        "data-shadcn--dialog-target": "content",
        "data-state": "closed",
        tabindex: "-1"
      })
    end

    def panel_content
      safe_join([
        header,
        title,
        description,
        content,
        footer,
        close_element
      ].compact)
    end

    def close_element
      content_tag(:button, close_icon, {
        type: "button",
        class: CLOSE_CLASSES,
        "data-action": "click->shadcn--dialog#close",
        "aria-label": "Close"
      })
    end

    def close_icon
      content_tag(:svg,
        content_tag(:path, nil, d: "M18 6 6 18M6 6l12 12", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round", "stroke-linejoin": "round"),
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "none",
        class: "h-4 w-4"
      )
    end
  end
end
