# frozen_string_literal: true

module Shadcn
  # Dropdown Menu Content component
  class DropdownMenuContentComponent < BaseComponent
    BASE_CLASSES = "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2"

    renders_many :items, lambda { |**options, &block|
      DropdownMenuItemComponent.new(**options, &block)
    }
    renders_many :labels, lambda { |**options, &block|
      DropdownMenuLabelComponent.new(**options, &block)
    }
    renders_many :separators, lambda { |**options|
      DropdownMenuSeparatorComponent.new(**options)
    }
    renders_many :groups, lambda { |**options, &block|
      DropdownMenuGroupComponent.new(**options, &block)
    }

    def call
      content_tag(:div, menu_content, menu_attributes)
    end

    private

    def menu_content
      # If items/labels/separators are used, render them
      # Otherwise render the block content
      if items.any? || labels.any? || separators.any? || groups.any?
        safe_join([labels, items, separators, groups, content].flatten.compact)
      else
        content
      end
    end

    def menu_attributes
      {
        class: merge_classes(BASE_CLASSES),
        role: "menu",
        "aria-orientation": "vertical",
        "data-shadcn--dropdown-target": "content",
        "data-state": "closed",
        "data-side": "bottom",
        hidden: true
      }
    end
  end
end
