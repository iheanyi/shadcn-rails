# frozen_string_literal: true

module Shadcn
  # Trigger button that opens navigation menu content
  class NavigationMenuTriggerComponent < BaseComponent
    TRIGGER_CLASSES = [
      "group inline-flex h-9 w-max items-center justify-center rounded-md bg-background px-4 py-2",
      "text-sm font-medium transition-[color,box-shadow] outline-none",
      "hover:bg-accent hover:text-accent-foreground",
      "focus:bg-accent focus:text-accent-foreground focus-visible:ring-[3px] focus-visible:ring-ring/50 focus-visible:outline-1",
      "disabled:pointer-events-none disabled:opacity-50",
      "data-[state=open]:bg-accent/50 data-[state=open]:text-accent-foreground data-[state=open]:hover:bg-accent data-[state=open]:focus:bg-accent"
    ].join(" ").freeze

    def call
      content_tag(:button, trigger_content, trigger_attributes)
    end

    private

    def trigger_content
      safe_join([
        content,
        chevron_icon
      ])
    end

    def chevron_icon
      content_tag(:svg, chevron_path,
        xmlns: "http://www.w3.org/2000/svg",
        width: "24",
        height: "24",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: "relative top-[1px] ml-1 size-3 transition duration-300 group-data-[state=open]:rotate-180",
        "aria-hidden": "true"
      )
    end

    def chevron_path
      content_tag(:path, nil, d: "m6 9 6 6 6-6")
    end

    def trigger_attributes
      {
        class: cn(TRIGGER_CLASSES, class_name),
        type: "button",
        "data-slot": "navigation-menu-trigger",
        "data-shadcn--navigation-menu-target": "trigger",
        "data-action": "click->shadcn--navigation-menu#toggle mouseenter->shadcn--navigation-menu#hoverOpen",
        "aria-expanded": "false",
        "data-state": "closed"
      }.merge(html_options).compact
    end
  end
end
