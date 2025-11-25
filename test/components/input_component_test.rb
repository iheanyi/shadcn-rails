# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class InputComponentTest < ViewComponent::TestCase
  def test_renders_default_input
    render_inline(Ui::InputComponent.new)

    assert_selector "input[type='text']"
    assert_selector "input.h-9"
    assert_selector "input.rounded-md"
    assert_selector "input.border"
  end

  def test_renders_email_type
    render_inline(Ui::InputComponent.new(type: "email"))

    assert_selector "input[type='email']"
  end

  def test_renders_password_type
    render_inline(Ui::InputComponent.new(type: "password"))

    assert_selector "input[type='password']"
  end

  def test_renders_with_placeholder
    render_inline(Ui::InputComponent.new(placeholder: "Enter your name"))

    assert_selector "input[placeholder='Enter your name']"
  end

  def test_renders_with_name
    render_inline(Ui::InputComponent.new(name: "user[email]"))

    assert_selector "input[name='user[email]']"
  end

  def test_renders_with_value
    render_inline(Ui::InputComponent.new(value: "test@example.com"))

    assert_selector "input[value='test@example.com']"
  end

  def test_renders_disabled_input
    render_inline(Ui::InputComponent.new(disabled: true))

    assert_selector "input[disabled]"
  end

  def test_accepts_custom_classes
    render_inline(Ui::InputComponent.new(class_name: "custom-input"))

    assert_selector "input.custom-input"
  end

  def test_accepts_html_options
    render_inline(Ui::InputComponent.new(id: "my-input", required: true))

    assert_selector "input#my-input"
    assert_selector "input[required]"
  end

  def test_has_proper_styling
    render_inline(Ui::InputComponent.new)

    assert_selector "input.border-input"
    assert_selector "input.bg-transparent"
    assert_selector "input.text-sm"
  end
end
