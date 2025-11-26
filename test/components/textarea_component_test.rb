# frozen_string_literal: true

require "test_helper"

class TextareaComponentTest < ViewComponent::TestCase
  def test_renders_default_textarea
    render_inline(Shadcn::TextareaComponent.new)

    assert_selector "textarea"
    assert_selector "textarea.flex.min-h-\\[60px\\].w-full.rounded-md"
  end

  def test_renders_with_placeholder
    render_inline(Shadcn::TextareaComponent.new(placeholder: "Enter text"))

    assert_selector "textarea[placeholder='Enter text']"
  end

  def test_renders_with_value
    render_inline(Shadcn::TextareaComponent.new(value: "Initial content"))

    assert_selector "textarea", text: "Initial content"
  end

  def test_renders_with_rows
    render_inline(Shadcn::TextareaComponent.new(rows: 6))

    assert_selector "textarea[rows='6']"
  end

  def test_renders_disabled
    render_inline(Shadcn::TextareaComponent.new(disabled: true))

    assert_selector "textarea[disabled]"
  end

  def test_renders_required
    render_inline(Shadcn::TextareaComponent.new(required: true))

    assert_selector "textarea[required]"
  end

  def test_renders_with_name_and_id
    render_inline(Shadcn::TextareaComponent.new(name: "bio", id: "user_bio"))

    assert_selector "textarea[name='bio']"
    assert_selector "textarea#user_bio"
  end
end
