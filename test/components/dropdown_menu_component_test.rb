# frozen_string_literal: true

require "test_helper"

class DropdownMenuComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_dropdown_container
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "div[data-controller='shadcn--dropdown']"
  end

  def test_renders_with_relative_inline_block_class
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "div.relative.inline-block"
  end

  # Trigger slot
  def test_renders_with_trigger_slot
    render_inline(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger { "Open Menu" }
    end

    assert_selector "[data-shadcn--dropdown-target='trigger']", text: "Open Menu"
  end

  def test_trigger_has_toggle_action
    render_inline(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger { "Toggle" }
    end

    assert_selector "[data-action='click->shadcn--dropdown#toggle']"
  end

  # Menu slot
  def test_renders_with_menu_slot
    render_inline(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger { "Open" }
      menu.with_menu { "Menu content" }
    end

    # Menu content is rendered (may be hidden)
    assert_text "Menu content"
  end

  # Open state
  def test_renders_closed_by_default
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "[data-shadcn--dropdown-open-value='false']"
  end

  def test_renders_open_when_specified
    render_inline(Shadcn::DropdownMenuComponent.new(open: true))

    assert_selector "[data-shadcn--dropdown-open-value='true']"
  end

  # Align variants
  def test_renders_with_end_align_by_default
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "[data-shadcn--dropdown-align-value='end']"
  end

  def test_renders_with_start_align
    render_inline(Shadcn::DropdownMenuComponent.new(align: :start))

    assert_selector "[data-shadcn--dropdown-align-value='start']"
  end

  def test_renders_with_center_align
    render_inline(Shadcn::DropdownMenuComponent.new(align: :center))

    assert_selector "[data-shadcn--dropdown-align-value='center']"
  end

  # Side variants
  def test_renders_with_bottom_side_by_default
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "[data-shadcn--dropdown-side-value='bottom']"
  end

  def test_renders_with_top_side
    render_inline(Shadcn::DropdownMenuComponent.new(side: :top))

    assert_selector "[data-shadcn--dropdown-side-value='top']"
  end

  def test_renders_with_left_side
    render_inline(Shadcn::DropdownMenuComponent.new(side: :left))

    assert_selector "[data-shadcn--dropdown-side-value='left']"
  end

  def test_renders_with_right_side
    render_inline(Shadcn::DropdownMenuComponent.new(side: :right))

    assert_selector "[data-shadcn--dropdown-side-value='right']"
  end

  # Keyboard handling
  def test_has_escape_key_action
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "[data-action*='keydown.escape->shadcn--dropdown#close']"
  end

  def test_has_click_outside_action
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "[data-action*='clickOutside->shadcn--dropdown#close']"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::DropdownMenuComponent.new(class_name: "my-dropdown"))

    assert_selector "div.my-dropdown"
  end

  # Combined trigger and menu
  def test_renders_both_trigger_and_menu
    render_inline(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger { "Open" }
      menu.with_menu { "Content" }
    end

    assert_selector "[data-shadcn--dropdown-target='trigger']"
    assert_text "Content"
  end
end
