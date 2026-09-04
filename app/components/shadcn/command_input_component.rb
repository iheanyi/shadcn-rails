# frozen_string_literal: true

module Shadcn
  # Command Input component - search input for command palette
  class CommandInputComponent < BaseComponent
    WRAPPER_CLASSES = "flex h-9 items-center gap-2 border-b px-3"
    INPUT_CLASSES = "flex h-10 w-full rounded-md bg-transparent py-3 text-sm outline-hidden placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50"
    ICON_CLASSES = "size-4 shrink-0 opacity-50"

    # @param placeholder [String] Placeholder text
    # @param autofocus [Boolean] Whether to autofocus the input
    def initialize(placeholder: "Type a command or search...", autofocus: false, **options)
      super(**options)
      @placeholder = placeholder
      @autofocus = autofocus
    end

    def call
      content_tag(:div, class: WRAPPER_CLASSES, "data-slot": "command-input-wrapper") do
        safe_join([
          search_icon,
          tag.input(
            type: "text",
            placeholder: @placeholder,
            autofocus: @autofocus || nil,
            class: merge_classes(INPUT_CLASSES),
            "data-slot": "command-input",
            data: {
              "shadcn--command-target": "input",
              action: "input->shadcn--command#filter"
            },
            **html_options.except(:class)
          )
        ])
      end
    end

    private

    def search_icon
      content_tag(:svg,
        class: ICON_CLASSES,
        xmlns: "http://www.w3.org/2000/svg",
        width: "24",
        height: "24",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round"
      ) do
        safe_join([
          tag.circle(cx: "11", cy: "11", r: "8"),
          tag.path(d: "m21 21-4.3-4.3")
        ])
      end
    end
  end
end
