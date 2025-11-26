# frozen_string_literal: true

module Shadcn
  # Menubar Content component
  # Container for menu items within a dropdown
  class MenubarContentComponent < BaseComponent
    BASE_CLASSES = "z-50 min-w-[12rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95"

    renders_many :items, lambda { |**options, &block|
      MenubarItemComponent.new(**options, &block)
    }
    renders_many :labels, lambda { |**options, &block|
      MenubarLabelComponent.new(**options, &block)
    }
    renders_many :separators, lambda { |**options|
      MenubarSeparatorComponent.new(**options)
    }
    renders_many :checkbox_items, lambda { |**options, &block|
      MenubarCheckboxItemComponent.new(**options, &block)
    }
    renders_many :radio_groups, lambda { |**options, &block|
      MenubarRadioGroupComponent.new(**options, &block)
    }
    renders_many :sub_menus, lambda { |**options, &block|
      MenubarSubComponent.new(**options, &block)
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
      if items.any? || labels.any? || separators.any? || checkbox_items.any? || radio_groups.any? || sub_menus.any?
        safe_join([labels, items, separators, checkbox_items, radio_groups, sub_menus, content].flatten.compact)
      else
        content
      end
    end

    def content_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        role: "menu",
        "aria-orientation": "vertical",
        "data-state": "closed",
        "data-shadcn--menubar-target": "content",
        hidden: true
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
