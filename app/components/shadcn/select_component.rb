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
    TRIGGER_CLASSES = "flex h-10 w-full items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm transition-[color,box-shadow] outline-none placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1"
    CONTENT_CLASSES = "shadcn-select-content absolute left-0 top-full z-50 mt-1 max-h-96 min-w-[var(--radix-select-trigger-width)] w-max overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95"
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
