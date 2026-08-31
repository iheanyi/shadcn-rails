# frozen_string_literal: true

require "test_helper"

class InputComponentTest < ViewComponent::TestCase
  def test_renders_default_input
    render_inline(Shadcn::InputComponent.new)

    assert_selector "input[type='text']"
    assert_selector "input.h-9.w-full.min-w-0.rounded-md.border[data-slot='input']"
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

  def test_uses_soft_focus_ring_without_user_agent_outline
    render_inline(Shadcn::InputComponent.new)

    classes = page.find("input")[:class]
    assert_includes classes, "outline-none"
    assert_includes classes, "focus-visible:border-ring"
    assert_includes classes, "focus-visible:ring-ring/50"
    assert_includes classes, "focus-visible:ring-[3px]"
    refute_includes classes, "focus-visible:ring-1"
    refute_includes classes, "focus-visible:outline-none"
  end

  def test_uses_new_york_v4_classes
    render_inline(Shadcn::InputComponent.new)

    classes = page.find("input")[:class]
    assert_includes classes, "shadow-xs"
    assert_includes classes, "dark:bg-input/30"
    assert_includes classes, "aria-invalid:border-destructive"
    assert_includes classes, "aria-invalid:ring-destructive/20"
    assert_includes classes, "dark:aria-invalid:ring-destructive/40"
    assert_includes classes, "transition-[color,box-shadow]"
    assert_includes classes, "selection:bg-primary"
    assert_includes classes, "selection:text-primary-foreground"
    assert_includes classes, "file:inline-flex"
    assert_includes classes, "file:h-7"
    assert_includes classes, "disabled:pointer-events-none"
    refute_includes classes, "shadow-sm"
    refute_includes classes, "transition-colors"
  end
end
