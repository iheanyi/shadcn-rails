# frozen_string_literal: true

require "test_helper"

class KbdComponentTest < ViewComponent::TestCase
  def test_renders_kbd_element
    render_inline(Shadcn::KbdComponent.new) { "K" }

    assert_selector "kbd", text: "K"
  end

  def test_renders_with_base_styles
    render_inline(Shadcn::KbdComponent.new) { "Enter" }

    assert_selector "kbd.rounded"
    assert_selector "kbd.border"
    assert_selector "kbd.font-mono"
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
