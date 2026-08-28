# frozen_string_literal: true

module Shadcn
  # Sheet Content component
  class SheetContentComponent < BaseComponent
    OVERLAY_CLASSES = "shadcn-overlay fixed inset-0 z-50 bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
    BASE_CONTENT_CLASSES = "shadcn-sheet-content fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out data-[state=closed]:duration-300 data-[state=open]:duration-500 data-[state=open]:animate-in data-[state=closed]:animate-out"
    CLOSE_CLASSES = "absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-secondary"

    renders_one :header, lambda { |**options|
      SheetHeaderComponent.new(**options)
    }
    renders_one :title, lambda { |**options|
      SheetTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      SheetDescriptionComponent.new(**options)
    }
    renders_one :footer, lambda { |**options|
      SheetFooterComponent.new(**options)
    }

    # @param side [Symbol] Side the sheet appears from
    def initialize(side: :right, **options)
      super(**options)
      @side = side.to_sym
    end

    def call
      content_tag(:template, content_wrapper, { "data-shadcn--sheet-target": "template" })
    end

    private

    def content_wrapper
      safe_join([overlay, sheet_panel])
    end

    def overlay
      content_tag(:div, "", {
        class: OVERLAY_CLASSES,
        "data-shadcn--sheet-target": "overlay",
        "data-action": "click->shadcn--sheet#close",
        "data-state": "closed"
      })
    end

    def sheet_panel
      content_tag(:div, panel_content, panel_attributes)
    end

    def panel_content
      safe_join([
        header,
        title,
        description,
        content,
        footer,
        close_button
      ].compact)
    end

    def panel_attributes
      {
        class: cn(BASE_CONTENT_CLASSES, SheetComponent::SIDES[@side], class_name),
        role: "dialog",
        "aria-modal": "true",
        "data-shadcn--sheet-target": "content",
        "data-side": @side.to_s,
        "data-state": "closed",
        tabindex: "-1"
      }
    end

    def close_button
      content_tag(:button, close_icon, {
        type: "button",
        class: CLOSE_CLASSES,
        "data-action": "click->shadcn--sheet#close",
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
