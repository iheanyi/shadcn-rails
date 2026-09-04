# frozen_string_literal: true

module Shadcn
  # Drawer Content component
  class DrawerContentComponent < BaseComponent
    OVERLAY_CLASSES = "fixed inset-0 z-50 bg-black/50 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:animate-in data-[state=open]:fade-in-0"
    CONTENT_CLASSES = [
      "group/drawer-content fixed z-50 flex h-auto flex-col bg-background",
      "data-[vaul-drawer-direction=top]:inset-x-0 data-[vaul-drawer-direction=top]:top-0 data-[vaul-drawer-direction=top]:mb-24 data-[vaul-drawer-direction=top]:max-h-[80vh] data-[vaul-drawer-direction=top]:rounded-b-lg data-[vaul-drawer-direction=top]:border-b",
      "data-[vaul-drawer-direction=bottom]:inset-x-0 data-[vaul-drawer-direction=bottom]:bottom-0 data-[vaul-drawer-direction=bottom]:mt-24 data-[vaul-drawer-direction=bottom]:max-h-[80vh] data-[vaul-drawer-direction=bottom]:rounded-t-lg data-[vaul-drawer-direction=bottom]:border-t",
      "data-[vaul-drawer-direction=right]:inset-y-0 data-[vaul-drawer-direction=right]:right-0 data-[vaul-drawer-direction=right]:w-3/4 data-[vaul-drawer-direction=right]:border-l data-[vaul-drawer-direction=right]:sm:max-w-sm",
      "data-[vaul-drawer-direction=left]:inset-y-0 data-[vaul-drawer-direction=left]:left-0 data-[vaul-drawer-direction=left]:w-3/4 data-[vaul-drawer-direction=left]:border-r data-[vaul-drawer-direction=left]:sm:max-w-sm"
    ].join(" ").freeze

    renders_one :header, lambda { |**options|
      DrawerHeaderComponent.new(**options)
    }
    renders_one :footer, lambda { |**options|
      DrawerFooterComponent.new(**options)
    }

    # @param direction [Symbol] :bottom, :top, :left, or :right
    def initialize(direction: :bottom, **options, &block)
      super(**options, &block)
      @direction = direction
    end

    def call
      content_tag(:template, content_wrapper, { "data-slot": "drawer-portal", "data-shadcn--drawer-target": "template" })
    end

    private

    def content_wrapper
      safe_join([
        overlay,
        drawer_panel
      ])
    end

    def overlay
      content_tag(:div, "", {
        class: OVERLAY_CLASSES,
        "data-slot": "drawer-overlay",
        "data-shadcn--drawer-target": "overlay",
        "data-action": "click->shadcn--drawer#close",
        "data-state": "closed"
      })
    end

    def drawer_panel
      content_tag(:div, panel_content, **panel_attributes)
    end

    def panel_attributes
      merge_html_attributes({
        class: merge_classes(CONTENT_CLASSES),
        role: "dialog",
        "aria-modal": "true",
        "data-slot": "drawer-content",
        "data-shadcn--drawer-target": "content",
        "data-state": "closed",
        "data-direction": @direction.to_s,
        "data-vaul-drawer-direction": @direction.to_s,
        tabindex: "-1"
      })
    end

    def panel_content
      safe_join([
        handle_bar,
        header,
        content,
        footer
      ].compact)
    end

    def handle_bar
      content_tag(:div, "", class: "mx-auto mt-4 hidden h-2 w-[100px] shrink-0 rounded-full bg-muted group-data-[vaul-drawer-direction=bottom]/drawer-content:block")
    end
  end
end
