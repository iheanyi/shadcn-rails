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
