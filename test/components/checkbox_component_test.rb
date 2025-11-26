# frozen_string_literal: true

require "test_helper"

class CheckboxComponentTest < ViewComponent::TestCase
  def test_renders_default_checkbox
    render_inline(Shadcn::CheckboxComponent.new)

    assert_selector "button[role='checkbox']"
    assert_selector "button[data-state='unchecked']"
    assert_selector "button[aria-checked='false']"
  end

  def test_renders_with_name_and_id
    render_inline(Shadcn::CheckboxComponent.new(name: "terms", id: "terms-checkbox"))

    assert_selector "button#terms-checkbox"
    assert_selector "input[type='hidden'][name='terms'][value='0']", visible: :all
  end

  def test_renders_checked_state
    render_inline(Shadcn::CheckboxComponent.new(checked: true))

    assert_selector "button[data-state='checked']"
    assert_selector "button[aria-checked='true']"
  end

  def test_renders_disabled_state
    render_inline(Shadcn::CheckboxComponent.new(disabled: true))

    assert_selector "button[disabled]"
  end

  def test_renders_required_state
    render_inline(Shadcn::CheckboxComponent.new(required: true))

    assert_selector "button[aria-required='true']"
  end

  def test_renders_indeterminate_state
    render_inline(Shadcn::CheckboxComponent.new(indeterminate: true))

    assert_selector "button[data-state='indeterminate']"
    assert_selector "button[aria-checked='mixed']"
  end

  def test_renders_stimulus_controller
    render_inline(Shadcn::CheckboxComponent.new)

    assert_selector "button[data-controller='shadcn--checkbox']"
    assert_selector "button[data-action='click->shadcn--checkbox#toggle']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::CheckboxComponent.new(class_name: "my-custom-class"))

    assert_selector "button.my-custom-class"
  end

  def test_renders_with_custom_value
    render_inline(Shadcn::CheckboxComponent.new(name: "accept", value: "yes"))

    assert_selector "button[value='yes']"
  end
end
