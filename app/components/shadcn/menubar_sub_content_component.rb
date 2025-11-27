# frozen_string_literal: true

module Shadcn
  # Menubar Sub Content component
  # Container for submenu items
  class MenubarSubContentComponent < BaseComponent
    BASE_CLASSES = "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95"

    # Use polymorphic slots to preserve the order of items and separators
    renders_many :menu_items, types: {
      item: {
        renders: lambda { |**options, &block|
          MenubarItemComponent.new(**options, &block)
        },
        as: :item
      },
      separator: {
        renders: lambda { |**options|
          MenubarSeparatorComponent.new(**options)
        },
        as: :separator
      }
    }

    def call
      content_tag(:div, sub_content, content_attributes)
    end

    private

    def sub_content
      # Trigger slot evaluation first by accessing content
      raw_content = content
      # If polymorphic slots were used, render them in order
      if menu_items.any?
        safe_join(menu_items)
      else
        # Otherwise render the raw block content (for backwards compatibility)
        raw_content
      end
    end

    def content_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        role: "menu",
        "aria-orientation": "vertical",
        "data-state": "closed",
        "data-shadcn--menubar-target": "subContent",
        "data-action": "mouseenter->shadcn--menubar#cancelCloseSubTimer mouseleave->shadcn--menubar#startCloseSubTimer",
        hidden: true
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
