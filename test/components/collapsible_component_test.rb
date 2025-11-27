# frozen_string_literal: true

require "test_helper"

class CollapsibleComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_collapsible_container
    render_inline(Shadcn::CollapsibleComponent.new)

    assert_selector "div[data-controller='shadcn--collapsible']"
  end

  # Trigger slot
  def test_renders_with_trigger_slot
    render_inline(Shadcn::CollapsibleComponent.new) do |collapsible|
      collapsible.with_trigger { "Toggle" }
    end

    assert_selector "[data-shadcn--collapsible-target='trigger']", text: "Toggle"
  end

  def test_trigger_has_toggle_action
    render_inline(Shadcn::CollapsibleComponent.new) do |collapsible|
      collapsible.with_trigger { "Click me" }
    end

    assert_selector "[data-action='click->shadcn--collapsible#toggle']"
  end

  # Body slot
  def test_renders_with_body_slot
    render_inline(Shadcn::CollapsibleComponent.new) do |collapsible|
      collapsible.with_body { "Hidden content" }
    end

    # Content is hidden by default (closed state)
    assert_selector "[data-shadcn--collapsible-target='content']", visible: false
  end

  # Open state
  def test_renders_closed_by_default
    render_inline(Shadcn::CollapsibleComponent.new)

    assert_selector "[data-shadcn--collapsible-open-value='false']"
    assert_selector "[data-state='closed']"
  end

  def test_renders_open_when_specified
    render_inline(Shadcn::CollapsibleComponent.new(open: true))

    assert_selector "[data-shadcn--collapsible-open-value='true']"
    assert_selector "[data-state='open']"
  end

  # Disabled state
  def test_renders_enabled_by_default
    render_inline(Shadcn::CollapsibleComponent.new)

    assert_selector "[data-shadcn--collapsible-disabled-value='false']"
  end

  def test_renders_disabled_when_specified
    render_inline(Shadcn::CollapsibleComponent.new(disabled: true))

    assert_selector "[data-shadcn--collapsible-disabled-value='true']"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::CollapsibleComponent.new(class_name: "my-collapsible"))

    assert_selector "div.my-collapsible"
  end

  # Combined trigger and body
  def test_renders_both_trigger_and_body
    render_inline(Shadcn::CollapsibleComponent.new) do |collapsible|
      collapsible.with_trigger { "Show/Hide" }
      collapsible.with_body { "Collapsible content" }
    end

    assert_selector "[data-shadcn--collapsible-target='trigger']"
    # Content is hidden by default
    assert_selector "[data-shadcn--collapsible-target='content']", visible: false
  end

  # Initial state combinations
  def test_renders_open_and_disabled
    render_inline(Shadcn::CollapsibleComponent.new(open: true, disabled: true))

    assert_selector "[data-shadcn--collapsible-open-value='true']"
    assert_selector "[data-shadcn--collapsible-disabled-value='true']"
    assert_selector "[data-state='open']"
  end

  # Stimulus integration
  def test_has_stimulus_controller
    render_inline(Shadcn::CollapsibleComponent.new)

    assert_selector "[data-controller='shadcn--collapsible']"
  end

  # Accessibility
  def test_data_state_reflects_open_state
    render_inline(Shadcn::CollapsibleComponent.new(open: false))
    assert_selector "[data-state='closed']"

    render_inline(Shadcn::CollapsibleComponent.new(open: true))
    assert_selector "[data-state='open']"
  end
end
