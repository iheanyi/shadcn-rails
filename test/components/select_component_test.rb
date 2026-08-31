# frozen_string_literal: true

require "test_helper"

class SelectComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_select_container
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "div[data-controller='shadcn--select']"
  end

  def test_renders_with_relative_inline_block_class
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "div.relative.inline-block"
  end

  # Trigger button
  def test_renders_trigger_button
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "button[data-shadcn--select-target='trigger']"
  end

  def test_trigger_uses_v4_focus_visible_ring_styles
    render_inline(Shadcn::SelectComponent.new)

    classes = page.find("button[data-shadcn--select-target='trigger']")["class"].split
    assert_includes classes, "focus-visible:border-ring"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "focus-visible:ring-ring/50"
    refute_includes classes, "focus:ring-2"
    refute_includes classes, "focus:ring-offset-2"
    refute_includes classes, "ring-offset-background"
  end

  def test_trigger_uses_new_york_v4_class_tokens
    render_inline(Shadcn::SelectComponent.new)

    classes = page.find("button[data-shadcn--select-target='trigger']")["class"].split
    assert_includes classes, "h-9"
    assert_includes classes, "w-fit"
    assert_includes classes, "gap-2"
    assert_includes classes, "shadow-xs"
    assert_includes classes, "aria-invalid:border-destructive"
    assert_includes classes, "aria-invalid:ring-destructive/20"
    assert_includes classes, "data-[placeholder]:text-muted-foreground"
    assert_includes classes, "*:data-[slot=select-value]:line-clamp-1"
    assert_includes classes, "*:data-[slot=select-value]:flex"
    assert_includes classes, "*:data-[slot=select-value]:items-center"
    assert_includes classes, "*:data-[slot=select-value]:gap-2"
    assert_includes classes, "dark:bg-input/30"
    assert_includes classes, "dark:hover:bg-input/50"
    assert_includes classes, "dark:aria-invalid:ring-destructive/40"
    assert_includes classes, "[&_svg]:pointer-events-none"
    assert_includes classes, "[&_svg]:shrink-0"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"
    assert_includes classes, "[&_svg:not([class*='text-'])]:text-muted-foreground"
    refute_includes classes, "h-10"
    refute_includes classes, "w-full"
    refute_includes classes, "shadow-sm"
    refute_includes classes, "placeholder:text-muted-foreground"
    refute_includes classes, "data-[size=default]:h-9"
    refute_includes classes, "data-[size=sm]:h-8"
  end

  def test_trigger_marks_placeholder_state_only_when_showing_placeholder
    render_inline(Shadcn::SelectComponent.new(placeholder: "Choose one"))

    assert_selector "button[data-placeholder]"

    render_inline(Shadcn::SelectComponent.new(value: "apple", placeholder: "Choose one"))

    assert_no_selector "button[data-placeholder]"
  end

  def test_trigger_has_combobox_role
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "button[role='combobox']"
  end

  def test_trigger_has_aria_attributes
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "button[aria-expanded='false'][aria-haspopup='listbox']"
  end

  def test_trigger_has_toggle_action
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "[data-action*='click->shadcn--select#toggle']"
  end

  # Placeholder
  def test_renders_default_placeholder
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "[data-shadcn--select-target='display']", text: "Select..."
  end

  def test_renders_custom_placeholder
    render_inline(Shadcn::SelectComponent.new(placeholder: "Choose one"))

    assert_selector "[data-shadcn--select-target='display']", text: "Choose one"
  end

  # Hidden input
  def test_renders_hidden_input
    render_inline(Shadcn::SelectComponent.new(name: "fruit"))

    assert_selector "input[type='hidden'][name='fruit']", visible: false
  end

  def test_hidden_input_has_target
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "input[data-shadcn--select-target='input']", visible: false
  end

  def test_renders_with_id
    render_inline(Shadcn::SelectComponent.new(name: "fruit", id: "fruit-select"))

    assert_selector "input#fruit-select", visible: false
  end

  def test_renders_with_value
    render_inline(Shadcn::SelectComponent.new(name: "fruit", value: "apple"))

    assert_selector "input[value='apple']", visible: false
    assert_selector "[data-shadcn--select-value-value='apple']"
  end

  def test_renders_required_input
    render_inline(Shadcn::SelectComponent.new(name: "fruit", required: true))

    assert_selector "input[required]", visible: false
  end

  # Disabled state
  def test_renders_enabled_by_default
    render_inline(Shadcn::SelectComponent.new)

    assert_no_selector "button[disabled]"
  end

  def test_renders_disabled_when_specified
    render_inline(Shadcn::SelectComponent.new(disabled: true))

    assert_selector "button[disabled]"
  end

  # Content area
  def test_renders_content_area
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "[data-shadcn--select-target='content']", visible: false
  end

  def test_content_has_listbox_role
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "[role='listbox']", visible: false
  end

  def test_content_is_hidden_by_default
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "[data-shadcn--select-target='content'][hidden]", visible: false
  end

  def test_content_has_closed_state
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "[data-state='closed']", visible: false
  end

  def test_content_uses_new_york_v4_class_tokens
    render_inline(Shadcn::SelectComponent.new)

    classes = page.find("[data-shadcn--select-target='content']", visible: false)["class"].split
    assert_includes classes, "shadcn-select-content"
    assert_includes classes, "relative"
    assert_includes classes, "z-50"
    assert_includes classes, "max-h-(--radix-select-content-available-height)"
    assert_includes classes, "min-w-[8rem]"
    assert_includes classes, "origin-(--radix-select-content-transform-origin)"
    assert_includes classes, "overflow-x-hidden"
    assert_includes classes, "overflow-y-auto"
    assert_includes classes, "shadow-md"
    assert_includes classes, "data-[side=bottom]:slide-in-from-top-2"
    assert_includes classes, "data-[side=left]:slide-in-from-right-2"
    assert_includes classes, "data-[side=right]:slide-in-from-left-2"
    assert_includes classes, "data-[side=top]:slide-in-from-bottom-2"
    refute_includes classes, "absolute"
    refute_includes classes, "left-0"
    refute_includes classes, "top-full"
    refute_includes classes, "mt-1"
    refute_includes classes, "max-h-96"
    refute_includes classes, "min-w-[var(--radix-select-trigger-width)]"
    refute_includes classes, "overflow-hidden"
  end

  # Items slot
  def test_renders_with_items
    render_inline(Shadcn::SelectComponent.new) do |select|
      select.with_item(value: "apple") { "Apple" }
      select.with_item(value: "banana") { "Banana" }
    end

    # Items are rendered inside the hidden content
    rendered_content = page.native.inner_html
    assert_includes rendered_content, "Apple"
    assert_includes rendered_content, "Banana"
  end

  def test_item_uses_new_york_v4_class_tokens
    render_inline(Shadcn::SelectItemComponent.new(value: "apple")) { "Apple" }

    classes = page.find("[data-slot='select-item']")["class"].split
    assert_includes classes, "gap-2"
    assert_includes classes, "pr-8"
    assert_includes classes, "pl-2"
    assert_includes classes, "outline-hidden"
    assert_includes classes, "[&_svg]:pointer-events-none"
    assert_includes classes, "[&_svg]:shrink-0"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"
    assert_includes classes, "[&_svg:not([class*='text-'])]:text-muted-foreground"
    assert_includes classes, "*:[span]:last:flex"
    assert_includes classes, "*:[span]:last:items-center"
    assert_includes classes, "*:[span]:last:gap-2"
    refute_includes classes, "pl-8"
    refute_includes classes, "pr-2"
    refute_includes classes, "outline-none"
    refute_includes classes, "hover:bg-accent"
    refute_includes classes, "hover:text-accent-foreground"
  end

  # Groups slot
  def test_renders_with_groups
    render_inline(Shadcn::SelectComponent.new) do |select|
      select.with_group(label: "Fruits") do |group|
        group.with_item(value: "apple") { "Apple" }
      end
    end

    # Group is rendered
    rendered_content = page.native.inner_html
    assert_includes rendered_content, "Fruits"
    assert_includes rendered_content, "Apple"
  end

  def test_group_label_uses_new_york_v4_class_tokens
    render_inline(Shadcn::SelectGroupComponent.new(label: "Fruits"))

    classes = page.find("[data-slot='select-label']")["class"].split
    assert_includes classes, "px-2"
    assert_includes classes, "py-1.5"
    assert_includes classes, "text-xs"
    assert_includes classes, "text-muted-foreground"
    refute_includes classes, "text-sm"
    refute_includes classes, "font-semibold"
  end

  def test_separator_uses_new_york_v4_class_tokens
    render_inline(Shadcn::SelectSeparatorComponent.new)

    classes = page.find("[data-slot='select-separator']")["class"].split
    assert_includes classes, "pointer-events-none"
    assert_includes classes, "-mx-1"
    assert_includes classes, "my-1"
    assert_includes classes, "h-px"
    assert_includes classes, "bg-border"
    refute_includes classes, "bg-muted"
  end

  # Keyboard handling
  def test_has_escape_key_action
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "[data-action*='keydown.escape->shadcn--select#close']"
  end

  def test_trigger_has_keydown_action
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "[data-action*='keydown->shadcn--select#handleKeydown']"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::SelectComponent.new(class_name: "my-select"))

    assert_selector "div.my-select"
  end

  # Chevron icon
  def test_renders_chevron_icon
    render_inline(Shadcn::SelectComponent.new)

    assert_selector "button svg"
  end

  # Display shows selected value
  def test_display_shows_value_when_selected
    render_inline(Shadcn::SelectComponent.new(value: "apple"))

    assert_selector "[data-shadcn--select-target='display']", text: "apple"
  end
end
