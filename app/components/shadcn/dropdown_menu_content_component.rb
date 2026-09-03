# frozen_string_literal: true

module Shadcn
  # Dropdown Menu Content component
  class DropdownMenuContentComponent < BaseComponent
    BASE_CLASSES = "shadcn-dropdown z-50 max-h-(--radix-dropdown-menu-content-available-height) min-w-[8rem] origin-(--radix-dropdown-menu-content-transform-origin) overflow-x-hidden overflow-y-auto rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95"

    # Use polymorphic slots to preserve the order of items, labels, separators, groups, etc.
    renders_many :menu_items, types: {
      item: {
        renders: lambda { |**options, &block|
          DropdownMenuItemComponent.new(**options, &block)
        },
        as: :item
      },
      label: {
        renders: lambda { |**options, &block|
          DropdownMenuLabelComponent.new(**options, &block)
        },
        as: :label
      },
      separator: {
        renders: lambda { |**options|
          DropdownMenuSeparatorComponent.new(**options)
        },
        as: :separator
      },
      group: {
        renders: lambda { |**options, &block|
          DropdownMenuGroupComponent.new(**options, &block)
        },
        as: :group
      },
      checkbox_item: {
        renders: lambda { |**options, &block|
          DropdownMenuCheckboxItemComponent.new(**options, &block)
        },
        as: :checkbox_item
      },
      radio_group: {
        renders: lambda { |**options, &block|
          DropdownMenuRadioGroupComponent.new(**options, &block)
        },
        as: :radio_group
      }
    }

    def call
      content_tag(:div, menu_content, menu_attributes)
    end

    private

    def menu_content
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
