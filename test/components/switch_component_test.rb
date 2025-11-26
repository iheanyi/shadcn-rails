# frozen_string_literal: true

require "test_helper"

class SwitchComponentTest < ViewComponent::TestCase
  def test_renders_default_switch
    render_inline(Shadcn::SwitchComponent.new)

    assert_selector "button[role='switch']"
    assert_selector "button[data-state='unchecked']"
    assert_selector "button[aria-checked='false']"
  end

  def test_renders_with_name_and_id
    render_inline(Shadcn::SwitchComponent.new(name: "notifications", id: "notifications-switch"))

    assert_selector "button#notifications-switch"
    assert_selector "input[type='hidden'][name='notifications'][value='0']", visible: :all
  end

  def test_renders_checked_state
    render_inline(Shadcn::SwitchComponent.new(checked: true))

    assert_selector "button[data-state='checked']"
    assert_selector "button[aria-checked='true']"
  end

  def test_renders_disabled_state
    render_inline(Shadcn::SwitchComponent.new(disabled: true))

    assert_selector "button[disabled]"
  end

  def test_renders_required_state
    render_inline(Shadcn::SwitchComponent.new(required: true))

    assert_selector "button[aria-required='true']"
  end

  def test_renders_stimulus_controller
    render_inline(Shadcn::SwitchComponent.new)

    assert_selector "button[data-controller='shadcn--switch']"
    assert_selector "button[data-action='click->shadcn--switch#toggle']"
  end

  def test_renders_thumb_element
    render_inline(Shadcn::SwitchComponent.new)

    # Should have thumb span inside
    assert_selector "button span[data-state]"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::SwitchComponent.new(class_name: "my-custom-class"))

    assert_selector "button.my-custom-class"
  end

  def test_renders_with_custom_value
    render_inline(Shadcn::SwitchComponent.new(name: "active", value: "on"))

    assert_selector "button[value='on']"
  end
end
