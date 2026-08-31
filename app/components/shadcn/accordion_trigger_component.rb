# frozen_string_literal: true

module Shadcn
  # Accordion Trigger component
  class AccordionTriggerComponent < BaseComponent
    HEADER_CLASSES = "flex"
    TRIGGER_CLASSES = "flex flex-1 items-start justify-between gap-4 rounded-md py-4 text-left text-sm font-medium transition-all outline-none hover:underline focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-50 [&[data-state=open]>svg]:rotate-180"

    def call
      content_tag(:h3, trigger_button, class: HEADER_CLASSES, "data-orientation": "vertical")
    end

    private

    def trigger_button
      content_tag(:button, button_content, trigger_attributes)
    end

    def button_content
      safe_join([
        content_tag(:span, content),
        chevron_icon
      ])
    end

    def chevron_icon
      content_tag(:svg,
        content_tag(:path, nil, d: "m6 9 6 6 6-6", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round", "stroke-linejoin": "round"),
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "none",
        class: "pointer-events-none size-4 shrink-0 translate-y-0.5 text-muted-foreground transition-transform duration-200"
      )
    end

    def trigger_attributes
      merge_html_attributes({
        type: "button",
        class: cn(TRIGGER_CLASSES, class_name),
        "data-slot": "accordion-trigger",
        "data-shadcn--accordion-target": "trigger",
        "data-action": "click->shadcn--accordion#toggle",
        "data-state": "closed",
        "aria-expanded": "false"
      })
    end
  end
end
