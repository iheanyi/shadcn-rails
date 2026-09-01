# frozen_string_literal: true

module Shadcn
  # Combobox component - autocomplete input with searchable dropdown
  # Composes Popover and Command components for a searchable select
  #
  # @example Basic combobox
  #   <%= render Shadcn::ComboboxComponent.new(
  #     items: [
  #       { value: "next", label: "Next.js" },
  #       { value: "remix", label: "Remix" },
  #       { value: "rails", label: "Ruby on Rails" }
  #     ],
  #     placeholder: "Select framework...",
  #     search_placeholder: "Search framework..."
  #   ) %>
  #
  # @example With selected value
  #   <%= render Shadcn::ComboboxComponent.new(
  #     items: frameworks,
  #     value: "rails",
  #     placeholder: "Select framework..."
  #   ) %>
  #
  # @example With name for form submission
  #   <%= render Shadcn::ComboboxComponent.new(
  #     items: frameworks,
  #     name: "project[framework]",
  #     placeholder: "Select framework..."
  #   ) %>
  #
  class ComboboxComponent < BaseComponent
    CHEVRON_CLASSES = "ml-2 size-4 shrink-0 opacity-50"
    CHECK_CLASSES = "absolute right-2 size-4"

    # @param items [Array<Hash>] Array of items with :value and :label keys
    # @param value [String, nil] Currently selected value
    # @param placeholder [String] Placeholder text when no value selected
    # @param search_placeholder [String] Placeholder text for search input
    # @param empty_text [String] Text shown when no results found
    # @param name [String, nil] Form field name for hidden input
    # @param disabled [Boolean] Whether the combobox is disabled
    # @param width [String] Width class for the component
    def initialize(
      items: [],
      value: nil,
      placeholder: "Select option...",
      search_placeholder: "Search...",
      empty_text: "No results found.",
      name: nil,
      disabled: false,
      width: "w-[200px]",
      **options
    )
      super(**options)
      @items = items
      @value = value
      @placeholder = placeholder
      @search_placeholder = search_placeholder
      @empty_text = empty_text
      @name = name
      @disabled = disabled
      @width = width
    end

    def call
      content_tag(:div, combobox_content, **combobox_attributes)
    end

    private

    def combobox_content
      safe_join([
        hidden_input,
        trigger_button,
        popover_content_template
      ].compact)
    end

    def hidden_input
      return unless @name

      tag.input(
        type: "hidden",
        name: @name,
        value: @value,
        data: { "shadcn--combobox-target": "hiddenInput" }
      )
    end

    def trigger_button
      content_tag(:button, button_content, **trigger_attributes)
    end

    def button_content
      safe_join([
        display_value,
        chevron_icon
      ])
    end

    def display_value
      label = selected_label
      content_tag(:span, label || @placeholder,
        class: label ? nil : "text-muted-foreground",
        data: { "shadcn--combobox-target": "displayValue" }
      )
    end

    def selected_label
      return nil unless @value

      item = @items.find { |i| i[:value].to_s == @value.to_s }
      item&.dig(:label)
    end

    def chevron_icon
      content_tag(:svg,
        class: CHEVRON_CLASSES,
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
          tag.path(d: "m7 15 5 5 5-5"),
          tag.path(d: "m7 9 5-5 5 5")
        ])
      end
    end

    def trigger_attributes
      {
        type: "button",
        role: "combobox",
        class: cn(
          "inline-flex shrink-0 items-center gap-2 rounded-md text-sm font-medium whitespace-nowrap transition-all outline-none",
          "focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50",
          "disabled:pointer-events-none disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40",
          "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
          "border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground dark:border-input dark:bg-input/30 dark:hover:bg-input/50",
          "h-9 px-4 py-2 has-[>svg]:px-3",
          @width,
          "justify-between"
        ),
        disabled: @disabled || nil,
        "aria-expanded": "false",
        data: {
          "shadcn--combobox-target": "trigger",
          action: "click->shadcn--combobox#toggle"
        }
      }
    end

    def popover_content_template
      content_tag(:div, popover_inner_content, **popover_content_attributes)
    end

    def popover_inner_content
      content_tag(:div, command_content, **command_wrapper_attributes)
    end

    def command_content
      safe_join([
        search_input,
        items_list
      ])
    end

    def search_input
      content_tag(:div, class: "flex items-center border-b px-3") do
        safe_join([
          search_icon,
          tag.input(
            type: "text",
            placeholder: @search_placeholder,
            class: "flex h-10 w-full rounded-md bg-transparent py-3 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50",
            data: {
              "shadcn--combobox-target": "input",
              action: "input->shadcn--combobox#filter"
            }
          )
        ])
      end
    end

    def search_icon
      content_tag(:svg,
        class: "mr-2 size-4 shrink-0 opacity-50",
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

    def items_list
      content_tag(:div, items_content, class: "max-h-[300px] overflow-y-auto overflow-x-hidden", data: { "shadcn--combobox-target": "list" })
    end

    def items_content
      safe_join([
        empty_state,
        items_group
      ])
    end

    def empty_state
      # Always start hidden - will show only when user types and no results match
      content_tag(:div, @empty_text,
        class: "py-6 text-center text-sm text-muted-foreground",
        hidden: true,
        data: { "shadcn--combobox-target": "empty" }
      )
    end

    def items_group
      content_tag(:div, class: "overflow-hidden p-1 text-foreground") do
        safe_join(@items.map { |item| render_item(item) })
      end
    end

    def render_item(item)
      is_selected = @value.to_s == item[:value].to_s

      content_tag(:div, **item_attributes(item, is_selected)) do
        safe_join([
          item[:label],
          check_icon(is_selected)
        ])
      end
    end

    def check_icon(is_selected)
      content_tag(:svg,
        class: cn(CHECK_CLASSES, is_selected ? "opacity-100" : "opacity-0"),
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
        tag.path(d: "M20 6 9 17l-5-5")
      end
    end

    def item_attributes(item, is_selected)
      {
        class: cn(
          "relative flex w-full cursor-default items-center gap-2 rounded-sm py-1.5 pr-8 pl-2 text-sm outline-hidden select-none",
          "data-[disabled=true]:pointer-events-none data-[disabled=true]:opacity-50",
          "hover:bg-accent hover:text-accent-foreground cursor-pointer",
          "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"
        ),
        role: "option",
        tabindex: "0",
        data: {
          "shadcn--combobox-target": "item",
          value: item[:value],
          label: item[:label],
          selected: is_selected,
          action: "click->shadcn--combobox#select"
        }
      }
    end

    def popover_content_attributes
      {
        class: cn(
          "absolute z-50 mt-1 rounded-md bg-popover text-popover-foreground shadow-md ring-1 ring-foreground/10 outline-none duration-100",
          "data-[state=open]:animate-in data-[state=closed]:animate-out",
          "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
          "data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95",
          @width,
          "p-0"
        ),
        hidden: true,
        data: {
          "shadcn--combobox-target": "content",
          state: "closed"
        }
      }
    end

    def command_wrapper_attributes
      {
        class: "flex h-full w-full flex-col overflow-hidden rounded-md bg-popover text-popover-foreground"
      }
    end

    def combobox_attributes
      {
        class: cn("relative inline-block", class_name),
        data: {
          controller: "shadcn--combobox",
          "shadcn--combobox-value-value": @value,
          action: "keydown.escape->shadcn--combobox#close click@window->shadcn--combobox#handleClickOutside"
        }
      }.merge(html_options).merge(build_data)
    end
  end
end
