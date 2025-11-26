# frozen_string_literal: true

require "test_helper"

class ToggleComponentTest < ViewComponent::TestCase
  def test_renders_toggle_button
    render_inline(Shadcn::ToggleComponent.new) { "Toggle" }

    assert_selector "button[type='button']", text: "Toggle"
    assert_selector "button[data-controller='shadcn--toggle']"
  end

  def test_renders_with_unpressed_state_by_default
    render_inline(Shadcn::ToggleComponent.new) { "Toggle" }

    assert_selector "button[aria-pressed='false']"
    assert_selector "button[data-state='off']"
  end

  def test_renders_with_pressed_state
    render_inline(Shadcn::ToggleComponent.new(pressed: true)) { "Toggle" }

    assert_selector "button[aria-pressed='true']"
    assert_selector "button[data-state='on']"
  end

  def test_renders_with_outline_variant
    render_inline(Shadcn::ToggleComponent.new(variant: :outline)) { "Toggle" }

    assert_selector "button.border"
  end

  def test_renders_with_small_size
    render_inline(Shadcn::ToggleComponent.new(size: :sm)) { "Toggle" }

    assert_selector "button.h-8"
  end

  def test_renders_with_large_size
    render_inline(Shadcn::ToggleComponent.new(size: :lg)) { "Toggle" }

    assert_selector "button.h-10"
  end

  def test_renders_with_disabled_state
    render_inline(Shadcn::ToggleComponent.new(disabled: true)) { "Toggle" }

    assert_selector "button[disabled]"
  end

  def test_renders_with_aria_label
    render_inline(Shadcn::ToggleComponent.new(aria_label: "Toggle bold")) { "B" }

    assert_selector "button[aria-label='Toggle bold']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::ToggleComponent.new(class_name: "my-toggle")) { "Toggle" }

    assert_selector "button.my-toggle"
  end

  def test_renders_stimulus_action
    render_inline(Shadcn::ToggleComponent.new) { "Toggle" }

    assert_selector "button[data-action='click->shadcn--toggle#toggle']"
  end
end
