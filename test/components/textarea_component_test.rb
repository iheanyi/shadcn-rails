# frozen_string_literal: true

require "test_helper"

class TextareaComponentTest < ViewComponent::TestCase
  def test_renders_default_textarea
    render_inline(Shadcn::TextareaComponent.new)

    assert_selector "textarea"
    assert_selector "textarea.flex.field-sizing-content.min-h-16.w-full.rounded-md[data-slot='textarea']"
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

  def test_renders_with_custom_class
    render_inline(Shadcn::TextareaComponent.new(class_name: "my-textarea"))

    assert_selector "textarea.my-textarea"
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::TextareaComponent.new(class: "alias-class"))

    assert_selector "textarea.alias-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::TextareaComponent.new(data: { testid: "textarea" }))

    assert_selector "[data-testid='textarea']"
  end

  def test_uses_soft_focus_ring_without_user_agent_outline
    render_inline(Shadcn::TextareaComponent.new)

    classes = page.find("textarea")[:class]
    assert_includes classes, "outline-none"
    assert_includes classes, "focus-visible:border-ring"
    assert_includes classes, "focus-visible:ring-ring/50"
    assert_includes classes, "focus-visible:ring-[3px]"
    refute_includes classes, "focus-visible:ring-1"
    refute_includes classes, "focus-visible:outline-none"
  end

  def test_uses_new_york_v4_classes
    render_inline(Shadcn::TextareaComponent.new)

    classes = page.find("textarea")[:class]
    assert_includes classes, "field-sizing-content"
    assert_includes classes, "min-h-16"
    assert_includes classes, "shadow-xs"
    assert_includes classes, "dark:bg-input/30"
    assert_includes classes, "aria-invalid:border-destructive"
    assert_includes classes, "aria-invalid:ring-destructive/20"
    assert_includes classes, "dark:aria-invalid:ring-destructive/40"
    assert_includes classes, "transition-[color,box-shadow]"
    refute_includes classes, "min-h-[60px]"
    refute_includes classes, "shadow-sm"
  end
end
