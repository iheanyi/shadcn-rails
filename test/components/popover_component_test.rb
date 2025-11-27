# frozen_string_literal: true

require "test_helper"

class PopoverComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_popover_container
    render_inline(Shadcn::PopoverComponent.new)

    assert_selector "div[data-controller='shadcn--popover']"
  end

  def test_renders_with_relative_inline_block_class
    render_inline(Shadcn::PopoverComponent.new)

    assert_selector "div.relative.inline-block"
  end

  # Trigger slot
  def test_renders_with_trigger_slot
    render_inline(Shadcn::PopoverComponent.new) do |popover|
      popover.with_trigger { "Open Popover" }
    end

    assert_selector "[data-shadcn--popover-target='trigger']", text: "Open Popover"
  end

  def test_trigger_has_toggle_action
    render_inline(Shadcn::PopoverComponent.new) do |popover|
      popover.with_trigger { "Toggle" }
    end

    assert_selector "[data-action='click->shadcn--popover#toggle']"
  end

  # Body slot
  def test_renders_with_body_slot
    render_inline(Shadcn::PopoverComponent.new) do |popover|
      popover.with_body { "Popover content" }
    end

    # Content is hidden by default
    assert_selector "[data-shadcn--popover-target='content']", visible: false
  end

  # Open state
  def test_renders_closed_by_default
    render_inline(Shadcn::PopoverComponent.new)

    assert_selector "[data-shadcn--popover-open-value='false']"
  end

  def test_renders_open_when_specified
    render_inline(Shadcn::PopoverComponent.new(open: true))

    assert_selector "[data-shadcn--popover-open-value='true']"
  end

  # Side variants
  def test_renders_with_bottom_side_by_default
    render_inline(Shadcn::PopoverComponent.new)

    assert_selector "[data-shadcn--popover-side-value='bottom']"
  end

  def test_renders_with_top_side
    render_inline(Shadcn::PopoverComponent.new(side: :top))

    assert_selector "[data-shadcn--popover-side-value='top']"
  end

  def test_renders_with_left_side
    render_inline(Shadcn::PopoverComponent.new(side: :left))

    assert_selector "[data-shadcn--popover-side-value='left']"
  end

  def test_renders_with_right_side
    render_inline(Shadcn::PopoverComponent.new(side: :right))

    assert_selector "[data-shadcn--popover-side-value='right']"
  end

  # Align variants
  def test_renders_with_center_align_by_default
    render_inline(Shadcn::PopoverComponent.new)

    assert_selector "[data-shadcn--popover-align-value='center']"
  end

  def test_renders_with_start_align
    render_inline(Shadcn::PopoverComponent.new(align: :start))

    assert_selector "[data-shadcn--popover-align-value='start']"
  end

  def test_renders_with_end_align
    render_inline(Shadcn::PopoverComponent.new(align: :end))

    assert_selector "[data-shadcn--popover-align-value='end']"
  end

  # Modal mode
  def test_renders_non_modal_by_default
    render_inline(Shadcn::PopoverComponent.new)

    assert_selector "[data-shadcn--popover-modal-value='false']"
  end

  def test_renders_modal_when_specified
    render_inline(Shadcn::PopoverComponent.new(modal: true))

    assert_selector "[data-shadcn--popover-modal-value='true']"
  end

  # Escape key handling
  def test_has_escape_key_action
    render_inline(Shadcn::PopoverComponent.new)

    assert_selector "[data-action='keydown.escape->shadcn--popover#close']"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::PopoverComponent.new(class_name: "my-popover"))

    assert_selector "div.my-popover"
  end

  # Combined trigger and body
  def test_renders_both_trigger_and_body
    render_inline(Shadcn::PopoverComponent.new) do |popover|
      popover.with_trigger { "Open" }
      popover.with_body { "Content" }
    end

    assert_selector "[data-shadcn--popover-target='trigger']"
    # Content is hidden by default
    assert_selector "[data-shadcn--popover-target='content']", visible: false
  end
end
