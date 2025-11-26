# frozen_string_literal: true

module Shadcn
  # Menubar Sub Content component
  # Container for submenu items
  class MenubarSubContentComponent < BaseComponent
    BASE_CLASSES = "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95"

    renders_many :items, lambda { |**options, &block|
      MenubarItemComponent.new(**options, &block)
    }
    renders_many :separators, lambda { |**options|
      MenubarSeparatorComponent.new(**options)
    }

    def call
      content_tag(:div, sub_content, content_attributes)
    end

    private

    def sub_content
      if items.any? || separators.any?
        safe_join([items, separators, content].flatten.compact)
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
