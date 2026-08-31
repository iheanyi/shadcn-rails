# frozen_string_literal: true

module Shadcn
  # Select component for dropdown selection
  # Matches shadcn/ui Select component
  # Uses Stimulus for interactivity
  #
  # @example Basic select
  #   <%= render Shadcn::SelectComponent.new(name: "fruit", placeholder: "Select a fruit") do |select| %>
  #     <% select.with_item(value: "apple") { "Apple" } %>
  #     <% select.with_item(value: "banana") { "Banana" } %>
  #     <% select.with_item(value: "orange") { "Orange" } %>
  #   <% end %>
  #
  # @example With groups
  #   <%= render Shadcn::SelectComponent.new(name: "timezone") do |select| %>
  #     <% select.with_group(label: "North America") do |group| %>
  #       <% group.with_item(value: "est") { "Eastern" } %>
  #       <% group.with_item(value: "pst") { "Pacific" } %>
  #     <% end %>
  #   <% end %>
  #
  class SelectComponent < BaseComponent
    TRIGGER_CLASSES = "flex h-9 w-fit items-center justify-between gap-2 rounded-md border border-input bg-transparent px-3 py-2 text-sm whitespace-nowrap shadow-xs transition-[color,box-shadow] outline-none focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 data-[placeholder]:text-muted-foreground *:data-[slot=select-value]:line-clamp-1 *:data-[slot=select-value]:flex *:data-[slot=select-value]:items-center *:data-[slot=select-value]:gap-2 dark:bg-input/30 dark:hover:bg-input/50 dark:aria-invalid:ring-destructive/40 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4 [&_svg:not([class*='text-'])]:text-muted-foreground"
    CONTENT_CLASSES = "shadcn-select-content relative z-50 max-h-(--radix-select-content-available-height) min-w-[var(--radix-select-trigger-width)] origin-(--radix-select-content-transform-origin) overflow-x-hidden overflow-y-auto rounded-md border bg-popover text-popover-foreground shadow-md data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95"
    VIEWPORT_CLASSES = "p-1"

    # Use polymorphic slots to preserve the order of items and groups
    renders_many :select_items, types: {
      item: {
        renders: lambda { |value:, **options, &block|
          SelectItemComponent.new(value: value, **options, &block)
        },
        as: :item
      },
      group: {
        renders: lambda { |label: nil, **options, &block|
          SelectGroupComponent.new(label: label, **options, &block)
        },
        as: :group
      }
    }

    # @param name [String, nil] Form field name
    # @param id [String, nil] Element ID
    # @param value [String, nil] Currently selected value
    # @param placeholder [String] Placeholder text
    # @param disabled [Boolean] Whether select is disabled
    # @param required [Boolean] Whether select is required
    def initialize(
      name: nil,
      id: nil,
      value: nil,
      placeholder: "Select...",
      disabled: false,
      required: false,
      **options
    )
      super(**options)
      @name = name
      @id = id
      @value = value
      @placeholder = placeholder
      @disabled = disabled
      @required = required
    end

    private

    def wrapper_classes
      cn("relative inline-block", class_name)
    end

    def trigger_classes
      cn(TRIGGER_CLASSES, class_name)
    end

    def display_text
      @value.presence || @placeholder
    end

    def items_content
      # Trigger slot evaluation first by accessing content
      raw_content = content
      # If polymorphic slots were used, render them in order
      if select_items.any?
        safe_join(select_items)
      else
        # Otherwise render the raw block content (for backwards compatibility)
        raw_content
      end
    end
  end
end
