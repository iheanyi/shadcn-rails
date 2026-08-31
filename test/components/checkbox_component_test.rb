# frozen_string_literal: true

require "test_helper"

class CheckboxComponentTest < ViewComponent::TestCase
  def test_renders_default_checkbox
    render_inline(Shadcn::CheckboxComponent.new)

    assert_selector "input[type='checkbox']"
    assert_selector "input.shadcn-checkbox"
    assert_selector "input[data-slot='checkbox']"
  end

  def test_renders_v4_checkbox_classes
    render_inline(Shadcn::CheckboxComponent.new)

    classes = page.find("input[type='checkbox']")["class"].split

    assert_includes classes, "size-4"
    assert_includes classes, "rounded-[4px]"
    assert_includes classes, "border-input"
    assert_includes classes, "shadow-xs"
    assert_includes classes, "transition-shadow"
    assert_includes classes, "outline-none"
    assert_includes classes, "focus-visible:border-ring"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "focus-visible:ring-ring/50"
    assert_includes classes, "aria-invalid:border-destructive"
    assert_includes classes, "aria-invalid:ring-destructive/20"
    assert_includes classes, "checked:border-primary"
    assert_includes classes, "checked:bg-primary"
    assert_includes classes, "checked:text-primary-foreground"
    assert_includes classes, "dark:bg-input/30"
    assert_includes classes, "dark:aria-invalid:ring-destructive/40"
    assert_includes classes, "dark:checked:bg-primary"

    refute_includes classes, "h-4"
    refute_includes classes, "w-4"
    refute_includes classes, "rounded-sm"
    refute_includes classes, "border-primary"
    refute_includes classes, "focus-visible:outline-none"
    refute_includes classes, "focus-visible:ring-1"
    refute_includes classes, "focus-visible:ring-offset-1"
  end

  def test_renders_with_name_and_id
    render_inline(Shadcn::CheckboxComponent.new(name: "terms", id: "terms-checkbox"))

    assert_selector "input#terms-checkbox[type='checkbox']"
    assert_selector "input[type='hidden'][name='terms'][value='0']", visible: :all
    assert_selector "input[type='checkbox'][name='terms']"
  end

  def test_renders_checked_state
    render_inline(Shadcn::CheckboxComponent.new(checked: true))

    assert_selector "input[type='checkbox'][checked]"
  end

  def test_renders_disabled_state
    render_inline(Shadcn::CheckboxComponent.new(disabled: true))

    assert_selector "input[type='checkbox'][disabled]"
  end

  def test_disabled_checkbox_does_not_render_hidden_unchecked_input
    render_inline(Shadcn::CheckboxComponent.new(name: "locked", disabled: true))

    assert_selector "input[type='checkbox'][name='locked'][disabled]"
    assert_selector "input[type='hidden'][name='locked']", count: 0
  end

  def test_renders_required_state
    render_inline(Shadcn::CheckboxComponent.new(required: true))

    assert_selector "input[type='checkbox'][required]"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::CheckboxComponent.new(class_name: "my-custom-class"))

    assert_selector "input[type='checkbox'].my-custom-class"
  end

  def test_renders_with_custom_value
    render_inline(Shadcn::CheckboxComponent.new(name: "accept", value: "yes"))

    assert_selector "input[type='checkbox'][value='yes']"
  end

  def test_renders_with_integrated_label
    render_inline(Shadcn::CheckboxComponent.new(name: "terms", id: "terms")) { "Accept terms" }

    assert_selector "label.flex.items-center"
    assert_selector "label input[type='checkbox']"
    assert_selector "label span", text: "Accept terms"
  end

  def test_generates_id_from_name
    render_inline(Shadcn::CheckboxComponent.new(name: "newsletter"))

    assert_selector "input[type='checkbox'][id='checkbox-newsletter']"
  end
end
