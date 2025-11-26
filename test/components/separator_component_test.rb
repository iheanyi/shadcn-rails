# frozen_string_literal: true

require "test_helper"

class SeparatorComponentTest < ViewComponent::TestCase
  def test_renders_horizontal_separator
    render_inline(Shadcn::SeparatorComponent.new)

    assert_selector "div[role='separator']"
    assert_selector "div.h-\\[1px\\].w-full"
    assert_selector "div[aria-orientation='horizontal']"
  end

  def test_renders_vertical_separator
    render_inline(Shadcn::SeparatorComponent.new(orientation: :vertical))

    assert_selector "div.h-full.w-\\[1px\\]"
    assert_selector "div[aria-orientation='vertical']"
  end

  def test_renders_decorative_separator
    render_inline(Shadcn::SeparatorComponent.new(decorative: true))

    assert_selector "div[role='none']"
    assert_no_selector "div[aria-orientation]"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::SeparatorComponent.new(class_name: "my-4"))

    assert_selector "div.my-4"
  end
end
