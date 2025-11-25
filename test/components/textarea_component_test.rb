# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class TextareaComponentTest < ViewComponent::TestCase
  def test_renders_default_textarea
    render_inline(Ui::TextareaComponent.new)

    assert_selector "textarea"
    assert_selector "textarea.rounded-md"
    assert_selector "textarea.border"
    assert_selector "textarea[rows='3']"
  end

  def test_renders_with_placeholder
    render_inline(Ui::TextareaComponent.new(placeholder: "Enter your message"))

    assert_selector "textarea[placeholder='Enter your message']"
  end

  def test_renders_with_name
    render_inline(Ui::TextareaComponent.new(name: "message"))

    assert_selector "textarea[name='message']"
  end

  def test_renders_with_value
    render_inline(Ui::TextareaComponent.new(value: "Hello world"))

    assert_text "Hello world"
  end

  def test_renders_with_custom_rows
    render_inline(Ui::TextareaComponent.new(rows: 5))

    assert_selector "textarea[rows='5']"
  end

  def test_renders_disabled_textarea
    render_inline(Ui::TextareaComponent.new(disabled: true))

    assert_selector "textarea[disabled]"
  end

  def test_accepts_custom_classes
    render_inline(Ui::TextareaComponent.new(class_name: "custom-textarea"))

    assert_selector "textarea.custom-textarea"
  end

  def test_has_proper_styling
    render_inline(Ui::TextareaComponent.new)

    assert_selector "textarea.border-input"
    assert_selector "textarea.bg-transparent"
    assert_selector "textarea.text-sm"
  end
end
