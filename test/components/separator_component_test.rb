# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class SeparatorComponentTest < ViewComponent::TestCase
  def test_renders_horizontal_separator
    render_inline(Ui::SeparatorComponent.new)

    assert_selector "div.bg-border"
    assert_selector "div.h-\\[1px\\]"
    assert_selector "div.w-full"
  end

  def test_renders_vertical_separator
    render_inline(Ui::SeparatorComponent.new(orientation: :vertical))

    assert_selector "div.w-\\[1px\\]"
    assert_selector "div.h-full"
    assert_selector "div[aria-orientation='vertical']"
  end

  def test_renders_decorative_separator
    render_inline(Ui::SeparatorComponent.new(decorative: true))

    assert_selector "div[role='none']"
  end

  def test_renders_non_decorative_separator
    render_inline(Ui::SeparatorComponent.new(decorative: false))

    assert_selector "div[role='separator']"
  end

  def test_accepts_custom_classes
    render_inline(Ui::SeparatorComponent.new(class_name: "my-4"))

    assert_selector "div.my-4"
  end

  def test_has_proper_styling
    render_inline(Ui::SeparatorComponent.new)

    assert_selector "div.shrink-0"
    assert_selector "div.bg-border"
  end
end
