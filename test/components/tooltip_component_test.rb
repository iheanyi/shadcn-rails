# frozen_string_literal: true

require "test_helper"

class TooltipComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_tooltip_container
    render_inline(Shadcn::TooltipComponent.new(text: "Tooltip text")) { "Trigger" }

    assert_selector "span[data-controller='shadcn--tooltip']"
  end

  def test_renders_with_relative_inline_block_class
    render_inline(Shadcn::TooltipComponent.new(text: "Tooltip")) { "Trigger" }

    assert_selector "span.relative.inline-block"
  end

  # Trigger content
  def test_renders_trigger_content
    render_inline(Shadcn::TooltipComponent.new(text: "Help text")) { "Hover me" }

    assert_selector "[data-shadcn--tooltip-target='trigger']", text: "Hover me"
  end

  def test_trigger_has_mouse_and_focus_actions
    render_inline(Shadcn::TooltipComponent.new(text: "Tooltip")) { "Content" }

    trigger = page.find("[data-shadcn--tooltip-target='trigger']")
    action = trigger["data-action"]

    assert_includes action, "mouseenter->shadcn--tooltip#show"
    assert_includes action, "mouseleave->shadcn--tooltip#hide"
    assert_includes action, "focus->shadcn--tooltip#show"
    assert_includes action, "blur->shadcn--tooltip#hide"
  end

  # Tooltip content
  def test_renders_tooltip_text
    render_inline(Shadcn::TooltipComponent.new(text: "This is helpful")) { "?" }

    # Content is hidden by default
    assert_selector "[data-shadcn--tooltip-target='content']", text: "This is helpful", visible: false
  end

  def test_tooltip_content_has_role_tooltip
    render_inline(Shadcn::TooltipComponent.new(text: "Info")) { "i" }

    # Content is hidden by default
    assert_selector "[role='tooltip']", visible: false
  end

  def test_tooltip_content_is_hidden_by_default
    render_inline(Shadcn::TooltipComponent.new(text: "Hidden")) { "Show" }

    # Must use visible: false to find hidden elements
    assert_selector "[data-shadcn--tooltip-target='content'][hidden]", visible: false
  end

  def test_tooltip_content_has_closed_state
    render_inline(Shadcn::TooltipComponent.new(text: "Closed")) { "Open" }

    # Content has data-state='closed' and is hidden
    assert_selector "[data-state='closed']", visible: false
  end

  # Side variants
  def test_renders_with_top_side_by_default
    render_inline(Shadcn::TooltipComponent.new(text: "Top")) { "Trigger" }

    # Side value is on the container
    assert_selector "[data-shadcn--tooltip-side-value='top']"
    # data-side is on the hidden content element
    assert_selector "[data-side='top']", visible: false
  end

  def test_renders_with_bottom_side
    render_inline(Shadcn::TooltipComponent.new(text: "Bottom", side: :bottom)) { "Trigger" }

    assert_selector "[data-shadcn--tooltip-side-value='bottom']"
    assert_selector "[data-side='bottom']", visible: false
  end

  def test_renders_with_left_side
    render_inline(Shadcn::TooltipComponent.new(text: "Left", side: :left)) { "Trigger" }

    assert_selector "[data-shadcn--tooltip-side-value='left']"
    assert_selector "[data-side='left']", visible: false
  end

  def test_renders_with_right_side
    render_inline(Shadcn::TooltipComponent.new(text: "Right", side: :right)) { "Trigger" }

    assert_selector "[data-shadcn--tooltip-side-value='right']"
    assert_selector "[data-side='right']", visible: false
  end

  # Align variants
  def test_renders_with_center_align_by_default
    render_inline(Shadcn::TooltipComponent.new(text: "Center")) { "Trigger" }

    assert_selector "[data-shadcn--tooltip-align-value='center']"
  end

  def test_renders_with_start_align
    render_inline(Shadcn::TooltipComponent.new(text: "Start", align: :start)) { "Trigger" }

    assert_selector "[data-shadcn--tooltip-align-value='start']"
  end

  def test_renders_with_end_align
    render_inline(Shadcn::TooltipComponent.new(text: "End", align: :end)) { "Trigger" }

    assert_selector "[data-shadcn--tooltip-align-value='end']"
  end

  # Delay configuration
  def test_renders_with_default_delay
    render_inline(Shadcn::TooltipComponent.new(text: "Delayed")) { "Wait" }

    assert_selector "[data-shadcn--tooltip-delay-value='200']"
  end

  def test_renders_with_custom_delay
    render_inline(Shadcn::TooltipComponent.new(text: "Fast", delay_duration: 100)) { "Quick" }

    assert_selector "[data-shadcn--tooltip-delay-value='100']"
  end

  def test_renders_with_default_skip_delay
    render_inline(Shadcn::TooltipComponent.new(text: "Skip")) { "Move" }

    assert_selector "[data-shadcn--tooltip-skip-delay-value='300']"
  end

  def test_renders_with_custom_skip_delay
    render_inline(Shadcn::TooltipComponent.new(text: "Custom", skip_delay_duration: 500)) { "Between" }

    assert_selector "[data-shadcn--tooltip-skip-delay-value='500']"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::TooltipComponent.new(text: "Styled", class_name: "my-tooltip")) { "Hover" }

    assert_selector "span.my-tooltip"
  end

  # Accessibility
  def test_has_accessible_tooltip_role
    render_inline(Shadcn::TooltipComponent.new(text: "Accessible")) { "Info" }

    # Content with role='tooltip' is hidden by default
    assert_selector "[data-shadcn--tooltip-target='content'][role='tooltip']", visible: false
  end
end
