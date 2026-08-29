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

    # Hidden inputs for form submission
    assert_selector "input[type='hidden'][name='notifications'][value='0']", visible: :all
    assert_selector "input[type='checkbox'][name='notifications'][id='notifications-switch']", visible: :all
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

  def test_disabled_switch_does_not_render_hidden_unchecked_input
    render_inline(Shadcn::SwitchComponent.new(name: "locked", disabled: true))

    assert_selector "input[type='checkbox'][name='locked'][disabled]", visible: :all
    assert_selector "input[type='hidden'][name='locked']", count: 0
  end

  def test_renders_required_state
    render_inline(Shadcn::SwitchComponent.new(required: true))

    assert_selector "button[aria-required='true']"
  end

  def test_renders_stimulus_controller_on_wrapper
    render_inline(Shadcn::SwitchComponent.new)

    # Controller is on the wrapper span, not the button
    assert_selector "span[data-controller='shadcn--switch']"
    assert_selector "button[data-action*='click->shadcn--switch#toggle']"
  end

  def test_appends_host_data_action_without_losing_switch_actions
    render_inline(Shadcn::SwitchComponent.new(data: { action: "analytics#track" }))

    assert_selector "button[data-action='click->shadcn--switch#toggle keydown->shadcn--switch#handleKeydown analytics#track']"
  end

  def test_renders_thumb_element
    render_inline(Shadcn::SwitchComponent.new)

    # Should have thumb span inside button
    assert_selector "button span[data-state]"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::SwitchComponent.new(class_name: "my-custom-class"))

    assert_selector "button.my-custom-class"
  end

  def test_renders_with_custom_value
    render_inline(Shadcn::SwitchComponent.new(name: "active", value: "on"))

    assert_selector "input[type='checkbox'][value='on']", visible: :all
  end

  def test_renders_with_integrated_label
    render_inline(Shadcn::SwitchComponent.new(name: "dark_mode")) { "Enable dark mode" }

    assert_selector "label.flex.items-center"
    assert_selector "label span", text: "Enable dark mode"
  end

  def test_generates_id_from_name
    render_inline(Shadcn::SwitchComponent.new(name: "notifications"))

    assert_selector "input[type='checkbox'][id='switch-notifications']", visible: :all
  end
end
