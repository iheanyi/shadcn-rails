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
    TRIGGER_CLASSES = "flex h-9 w-full items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1"
    CONTENT_CLASSES = "relative z-50 max-h-96 min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2"
    VIEWPORT_CLASSES = "p-1"

    renders_many :items, lambda { |value:, **options, &block|
      SelectItemComponent.new(value: value, **options, &block)
    }
    renders_many :groups, lambda { |label: nil, **options, &block|
      SelectGroupComponent.new(label: label, **options, &block)
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

    def call
      content_tag(:div, select_structure, select_attributes)
    end

    private

    def select_structure
      safe_join([
        hidden_input,
        trigger,
        content_wrapper
      ])
    end

    def hidden_input
      tag(:input,
        type: "hidden",
        name: @name,
        id: @id,
        value: @value,
        required: @required || nil,
        "data-shadcn--select-target": "input"
      )
    end

    def trigger
      content_tag(:button, trigger_content, trigger_attributes)
    end

    def trigger_content
      safe_join([
        content_tag(:span, @value.presence || @placeholder, "data-shadcn--select-target": "display"),
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
        class: "h-4 w-4 opacity-50"
      )
    end

    def trigger_attributes
      {
        type: "button",
        class: cn(TRIGGER_CLASSES, class_name),
        role: "combobox",
        disabled: @disabled || nil,
        "aria-expanded": "false",
        "aria-haspopup": "listbox",
        "data-shadcn--select-target": "trigger",
        "data-action": "click->shadcn--select#toggle keydown->shadcn--select#handleKeydown",
        "data-placeholder": @placeholder
      }
    end

    def content_wrapper
      content_tag(:div, viewport, {
        class: CONTENT_CLASSES,
        role: "listbox",
        "data-shadcn--select-target": "content",
        "data-state": "closed",
        hidden: true
      })
    end

    def viewport
      content_tag(:div, items_content, class: VIEWPORT_CLASSES)
    end

    def items_content
      safe_join([items, groups, content].compact.flatten)
    end

    def select_attributes
      attrs = {
        class: "relative",
        "data-controller": "shadcn--select",
        "data-shadcn--select-value-value": @value,
        "data-action": "keydown.escape->shadcn--select#close"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Select Item component
  class SelectItemComponent < BaseComponent
    BASE_CLASSES = "relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50"

    # @param value [String] The value for this option
    # @param disabled [Boolean] Whether this option is disabled
    def initialize(value:, disabled: false, **options)
      super(**options)
      @value = value
      @disabled = disabled
    end

    def call
      content_tag(:div, item_content, item_attributes)
    end

    private

    def item_content
      safe_join([
        check_indicator,
        content_tag(:span, content)
      ])
    end

    def check_indicator
      content_tag(:span, check_icon, class: "absolute right-2 flex h-3.5 w-3.5 items-center justify-center")
    end

    def check_icon
      content_tag(:svg,
        content_tag(:path, nil, d: "M20 6 9 17l-5-5", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round", "stroke-linejoin": "round"),
        xmlns: "http://www.w3.org/2000/svg",
        width: "12",
        height: "12",
        viewBox: "0 0 24 24",
        fill: "none",
        class: "h-4 w-4 opacity-0",
        "data-shadcn--select-target": "checkIcon"
      )
    end

    def item_attributes
      {
        class: merge_classes(BASE_CLASSES),
        role: "option",
        "aria-selected": "false",
        "data-shadcn--select-target": "item",
        "data-value": @value,
        "data-disabled": @disabled ? "" : nil,
        "data-action": "click->shadcn--select#select",
        tabindex: @disabled ? nil : "-1"
      }
    end
  end

  # Select Group component
  class SelectGroupComponent < BaseComponent
    LABEL_CLASSES = "px-2 py-1.5 text-sm font-semibold"

    renders_many :items, lambda { |value:, **options, &block|
      SelectItemComponent.new(value: value, **options, &block)
    }

    # @param label [String, nil] Group label
    def initialize(label: nil, **options)
      super(**options)
      @label = label
    end

    def call
      content_tag(:div, group_content, role: "group")
    end

    private

    def group_content
      safe_join([
        (@label ? content_tag(:div, @label, class: LABEL_CLASSES) : nil),
        items,
        content
      ].compact.flatten)
    end
  end

  # Select Separator component
  class SelectSeparatorComponent < BaseComponent
    BASE_CLASSES = "-mx-1 my-1 h-px bg-muted"

    def call
      content_tag(:div, "", class: merge_classes(BASE_CLASSES), role: "separator")
    end
  end
end
