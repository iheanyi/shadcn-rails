# frozen_string_literal: true

module Shadcn
  # Context Menu Content component
  class ContextMenuContentComponent < BaseComponent
    BASE_CLASSES = "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95"

    renders_many :items, lambda { |**options, &block|
      ContextMenuItemComponent.new(**options, &block)
    }
    renders_many :labels, lambda { |**options, &block|
      ContextMenuLabelComponent.new(**options, &block)
    }
    renders_many :separators, lambda { |**options|
      ContextMenuSeparatorComponent.new(**options)
    }

    def call
      content_tag(:div, menu_content, menu_attributes)
    end

    private

    def menu_content
      if items.any? || labels.any? || separators.any?
        safe_join([labels, items, separators, content].flatten.compact)
      else
        content
      end
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
