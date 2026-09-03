# frozen_string_literal: true

module Shadcn
  # Drawer Content component
  class DrawerContentComponent < BaseComponent
    OVERLAY_CLASSES = "fixed inset-0 z-50 bg-black/50 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:animate-in data-[state=open]:fade-in-0"
    CONTENT_CLASSES = {
      bottom: "group/drawer-content fixed inset-x-0 bottom-0 z-50 mt-24 flex h-auto max-h-[80vh] flex-col rounded-t-lg border-t bg-background",
      top: "group/drawer-content fixed inset-x-0 top-0 z-50 mb-24 flex h-auto max-h-[80vh] flex-col rounded-b-lg border-b bg-background",
      left: "group/drawer-content fixed inset-y-0 left-0 z-50 flex h-auto w-3/4 flex-col border-r bg-background sm:max-w-sm",
      right: "group/drawer-content fixed inset-y-0 right-0 z-50 flex h-auto w-3/4 flex-col border-l bg-background sm:max-w-sm"
    }.freeze

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
      content_tag(:template, content_wrapper, { "data-shadcn--drawer-target": "template" })
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
        "data-shadcn--drawer-target": "overlay",
        "data-action": "click->shadcn--drawer#close",
        "data-state": "closed"
      })
    end

    def drawer_panel
      content_tag(:div, panel_content, {
        class: cn(CONTENT_CLASSES[@direction] || CONTENT_CLASSES[:bottom], class_name),
        role: "dialog",
        "aria-modal": "true",
        "data-shadcn--drawer-target": "content",
        "data-state": "closed",
        "data-direction": @direction.to_s,
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
      return unless [:bottom, :top].include?(@direction)

      content_tag(:div, class: "mx-auto mt-4 h-2 w-[100px] shrink-0 rounded-full bg-muted") { "" }
    end
  end
end
