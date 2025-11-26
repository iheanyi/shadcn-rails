# frozen_string_literal: true

require "test_helper"

class InputComponentTest < ViewComponent::TestCase
  def test_renders_default_input
    render_inline(Shadcn::InputComponent.new)

    assert_selector "input[type='text']"
    assert_selector "input.flex.h-9.w-full.rounded-md.border"
  end

  def test_renders_with_type
    render_inline(Shadcn::InputComponent.new(type: "email"))
    assert_selector "input[type='email']"

    render_inline(Shadcn::InputComponent.new(type: "password"))
    assert_selector "input[type='password']"

    render_inline(Shadcn::InputComponent.new(type: "number"))
    assert_selector "input[type='number']"
  end

  def test_renders_with_placeholder
    render_inline(Shadcn::InputComponent.new(placeholder: "Enter text"))

    assert_selector "input[placeholder='Enter text']"
  end

  def test_renders_with_value
    render_inline(Shadcn::InputComponent.new(value: "Initial value"))

    assert_selector "input[value='Initial value']"
  end

  def test_renders_with_name_and_id
    render_inline(Shadcn::InputComponent.new(name: "email", id: "user_email"))

    assert_selector "input[name='email']"
    assert_selector "input#user_email"
  end

  def test_renders_disabled
    render_inline(Shadcn::InputComponent.new(disabled: true))

    assert_selector "input[disabled]"
  end

  def test_renders_required
    render_inline(Shadcn::InputComponent.new(required: true))

    assert_selector "input[required]"
  end

  def test_renders_readonly
    render_inline(Shadcn::InputComponent.new(readonly: true))

    assert_selector "input[readonly]"
  end

  def test_renders_with_validation_attributes
    render_inline(Shadcn::InputComponent.new(
      min: 0,
      max: 100,
      minlength: 5,
      maxlength: 50,
      pattern: "[A-Za-z]+"
    ))

    assert_selector "input[min='0']"
    assert_selector "input[max='100']"
    assert_selector "input[minlength='5']"
    assert_selector "input[maxlength='50']"
    assert_selector "input[pattern='[A-Za-z]+']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::InputComponent.new(class_name: "my-input"))

    assert_selector "input.my-input"
  end
end
