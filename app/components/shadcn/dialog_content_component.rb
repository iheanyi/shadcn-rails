# frozen_string_literal: true

module Shadcn
  # Dialog Content component
  class DialogContentComponent < BaseComponent
    OVERLAY_CLASSES = "shadcn-overlay fixed inset-0 z-50 bg-black/50 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:animate-in data-[state=open]:fade-in-0"
    CONTENT_CLASSES = "shadcn-dialog-content fixed top-[50%] left-[50%] z-50 grid w-full max-w-[calc(100%-2rem)] translate-x-[-50%] translate-y-[-50%] gap-4 rounded-lg border bg-background p-6 shadow-lg duration-200 outline-none data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95 sm:max-w-lg"
    CLOSE_CLASSES = "absolute top-4 right-4 rounded-xs opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:outline-hidden disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"

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
      content_tag(:template, content_wrapper, { "data-slot": "dialog-portal", "data-shadcn--dialog-target": "template" })
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
        "data-slot": "dialog-overlay",
        "data-shadcn--dialog-target": "overlay",
        "data-action": "click->shadcn--dialog#close",
        "data-state": "closed",
        "aria-hidden": "true"
      })
    end

    def dialog_panel
      content_tag(:div, panel_content, merge_html_attributes({
        class: cn(CONTENT_CLASSES, class_name),
        role: "dialog",
        "aria-modal": "true",
        "data-slot": "dialog-content",
        "data-shadcn--dialog-target": "content",
        "data-state": "closed",
        tabindex: "-1"
      }))
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
        "data-slot": "dialog-close",
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
        fill: "none"
      )
    end
  end
end
