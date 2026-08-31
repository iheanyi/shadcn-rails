# frozen_string_literal: true

require "test_helper"

class SeparatorComponentTest < ViewComponent::TestCase
  def test_renders_horizontal_separator
    render_inline(Shadcn::SeparatorComponent.new)

    assert_selector "div[role='separator']"
    assert_selector "div[aria-orientation='horizontal']"
    assert_selector "div[data-orientation='horizontal']"
    assert_selector "div[data-slot='separator']"

    class_attribute = page.find("div")["class"]
    assert_includes class_attribute, "data-[orientation=horizontal]:h-px"
    refute_includes class_attribute, "h-[1px]"
  end

  def test_renders_vertical_separator
    render_inline(Shadcn::SeparatorComponent.new(orientation: :vertical))

    assert_selector "div[aria-orientation='vertical']"
    assert_selector "div[data-orientation='vertical']"

    class_attribute = page.find("div")["class"]
    assert_includes class_attribute, "data-[orientation=vertical]:w-px"
    refute_includes class_attribute, "w-[1px]"
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
