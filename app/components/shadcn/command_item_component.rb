# frozen_string_literal: true

module Shadcn
  # Command Item component - individual selectable command
  class CommandItemComponent < BaseComponent
    BASE_CLASSES = "relative flex cursor-default gap-2 select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none data-[disabled=true]:pointer-events-none data-[selected=true]:bg-accent data-[selected=true]:text-accent-foreground data-[disabled=true]:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0"

    # Shortcut slot
    renders_one :shortcut, lambda { |**options|
      CommandShortcutComponent.new(**options)
    }

    # @param value [String, nil] The searchable value (defaults to content text)
    # @param disabled [Boolean] Whether the item is disabled
    # @param on_select [String] JavaScript to execute on select
    def initialize(value: nil, disabled: false, on_select: nil, **options)
      super(**options)
      @value = value
      @disabled = disabled
      @on_select = on_select
    end

    def call
      content_tag(:div, item_content, **item_attributes)
    end

    private

    def item_content
      safe_join([content, shortcut].compact)
    end

    def item_attributes
      {
        class: merge_classes(BASE_CLASSES),
        role: "option",
        tabindex: @disabled ? nil : "0",
        data: {
          "shadcn--command-target": "item",
          value: @value,
          disabled: @disabled || nil,
          selected: false,
          action: @disabled ? nil : "click->shadcn--command#select"
        }.compact
      }.merge(html_options).merge(build_data)
    end
  end
end
