# frozen_string_literal: true

module Shadcn
  # SidebarTrigger component - button to toggle sidebar open/closed
  class SidebarTriggerComponent < BaseComponent
    BASE_CLASSES = "h-7 w-7"

    def call
      render ButtonComponent.new(
        variant: :ghost,
        size: :icon,
        class_name: cn(BASE_CLASSES, class_name),
        data: { sidebar: "trigger", action: "click->shadcn--sidebar#toggle" },
        **html_options
      ) do
        trigger_content
      end
    end

    private

    def trigger_content
      if content?
        content
      else
        default_icon
      end
    end

    def default_icon
      # PanelLeft icon from Lucide
      content_tag(:svg, nil,
        xmlns: "http://www.w3.org/2000/svg",
        width: "24",
        height: "24",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: "size-4"
      ) do
        safe_join([
          content_tag(:rect, nil, width: "18", height: "18", x: "3", y: "3", rx: "2"),
          content_tag(:path, nil, d: "M9 3v18")
        ])
      end
    end
  end
end
