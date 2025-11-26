# frozen_string_literal: true

module Shadcn
  # Menubar Trigger component
  # Button that opens the menu dropdown
  class MenubarTriggerComponent < BaseComponent
    BASE_CLASSES = "flex cursor-default select-none items-center rounded-sm px-3 py-1 text-sm font-medium outline-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground"

    def call
      content_tag(:button, content, trigger_attributes)
    end

    private

    def trigger_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        type: "button",
        role: "menuitem",
        "aria-haspopup": "menu",
        "aria-expanded": "false",
        "data-state": "closed",
        "data-shadcn--menubar-target": "trigger",
        "data-action": "click->shadcn--menubar#toggle mouseenter->shadcn--menubar#hoverOpen"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
