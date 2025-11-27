# frozen_string_literal: true

module Shadcn
  # Context Menu Content component
  class ContextMenuContentComponent < BaseComponent
    BASE_CLASSES = "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95"

    # Use polymorphic slots to preserve the order of items, labels, and separators
    renders_many :menu_items, types: {
      item: {
        renders: lambda { |**options, &block|
          ContextMenuItemComponent.new(**options, &block)
        },
        as: :item
      },
      label: {
        renders: lambda { |**options, &block|
          ContextMenuLabelComponent.new(**options, &block)
        },
        as: :label
      },
      separator: {
        renders: lambda { |**options|
          ContextMenuSeparatorComponent.new(**options)
        },
        as: :separator
      }
    }

    def call
      content_tag(:div, menu_content, menu_attributes)
    end

    private

    def menu_content
      # Trigger slot evaluation first
      content
      # Render all menu items in the order they were added
      safe_join(menu_items)
    end

    def menu_attributes
      {
        class: merge_classes(BASE_CLASSES),
        role: "menu",
        "aria-orientation": "vertical",
        "data-shadcn--context-menu-target": "content",
        "data-state": "closed",
        style: "position: fixed;",
        hidden: true
      }
    end
  end
end
