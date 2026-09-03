# frozen_string_literal: true

module Shadcn
  # Menubar Content component
  # Container for menu items within a dropdown
  class MenubarContentComponent < BaseComponent
    BASE_CLASSES = "z-50 min-w-[12rem] origin-(--radix-menubar-content-transform-origin) overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95"

    # Use polymorphic slots to preserve the order of items, labels, separators, etc.
    renders_many :menu_items, types: {
      item: {
        renders: lambda { |**options, &block|
          MenubarItemComponent.new(**options, &block)
        },
        as: :item
      },
      label: {
        renders: lambda { |**options, &block|
          MenubarLabelComponent.new(**options, &block)
        },
        as: :label
      },
      separator: {
        renders: lambda { |**options|
          MenubarSeparatorComponent.new(**options)
        },
        as: :separator
      },
      checkbox_item: {
        renders: lambda { |**options, &block|
          MenubarCheckboxItemComponent.new(**options, &block)
        },
        as: :checkbox_item
      },
      radio_group: {
        renders: lambda { |**options, &block|
          MenubarRadioGroupComponent.new(**options, &block)
        },
        as: :radio_group
      },
      sub_menu: {
        renders: lambda { |**options, &block|
          MenubarSubComponent.new(**options, &block)
        },
        as: :sub_menu
      }
    }

    # @param align [Symbol] Content alignment (:start, :center, :end)
    # @param side_offset [Integer] Offset from trigger
    def initialize(align: :start, side_offset: 4, **options)
      super(**options)
      @align = align
      @side_offset = side_offset
    end

    def call
      content_tag(:div, menu_content, content_attributes)
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

    def content_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        role: "menu",
        "aria-orientation": "vertical",
        "data-state": "closed",
        "data-side": "bottom",
        "data-shadcn--menubar-target": "content",
        hidden: true
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
