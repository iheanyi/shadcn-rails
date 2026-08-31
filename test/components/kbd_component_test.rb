# frozen_string_literal: true

require "test_helper"

class KbdComponentTest < ViewComponent::TestCase
  def test_renders_kbd_element
    render_inline(Shadcn::KbdComponent.new) { "K" }

    assert_selector "kbd", text: "K"
  end

  def test_renders_with_base_styles
    render_inline(Shadcn::KbdComponent.new) { "Enter" }

    kbd = page.find("kbd")
    classes = kbd[:class]
    class_tokens = classes.split

    assert_equal "kbd", kbd["data-slot"]
    assert_equal "pointer-events-none inline-flex h-5 w-fit min-w-5 items-center justify-center gap-1 rounded-sm bg-muted px-1 font-sans text-xs font-medium text-muted-foreground select-none [&_svg:not([class*='size-'])]:size-3 [[data-slot=tooltip-content]_&]:bg-background/20 [[data-slot=tooltip-content]_&]:text-background dark:[[data-slot=tooltip-content]_&]:bg-background/10", classes
    assert_includes class_tokens, "rounded-sm"
    assert_includes class_tokens, "min-w-5"
    assert_includes class_tokens, "font-sans"
    assert_includes class_tokens, "text-xs"
    assert_includes class_tokens, "px-1"
    refute_includes class_tokens, "font-mono"
    refute_includes class_tokens, "text-[10px]"
    refute_includes class_tokens, "border"
    refute_includes class_tokens, "opacity-100"
  end

  def test_renders_keyboard_shortcut
    render_inline(Shadcn::KbdComponent.new) { "⌘K" }

    assert_selector "kbd", text: "⌘K"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::KbdComponent.new(class_name: "my-custom-class")) { "Ctrl" }

    assert_selector "kbd.my-custom-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::KbdComponent.new(data: { key: "escape" })) { "Esc" }

    assert_selector "kbd[data-key='escape']"
  end
end
