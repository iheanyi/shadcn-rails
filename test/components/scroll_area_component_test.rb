# frozen_string_literal: true

require "test_helper"

class ScrollAreaComponentTest < ViewComponent::TestCase
  def test_renders_scroll_area_container
    render_inline(Shadcn::ScrollAreaComponent.new) { "Content" }

    assert_selector "div[data-controller='shadcn--scroll-area']"
    assert_selector "div.relative"
  end

  def test_renders_viewport
    render_inline(Shadcn::ScrollAreaComponent.new) { "Scrollable content" }

    assert_selector "div[data-shadcn--scroll-area-target='viewport']"
    viewport = page.find("div[data-shadcn--scroll-area-target='viewport']")
    assert_includes viewport["class"], "size-full"
    assert_includes viewport["class"], "transition-[color,box-shadow]"
    assert_includes viewport["class"], "focus-visible:ring-[3px]"
  end

  def test_renders_vertical_scrollbar_by_default
    render_inline(Shadcn::ScrollAreaComponent.new) { "Content" }

    assert_selector "div[data-orientation='vertical']"
    assert_selector "div[data-shadcn--scroll-area-target='scrollbar']"
    scrollbar = page.find("div[data-orientation='vertical']")
    assert_includes scrollbar["class"], "p-px"
  end

  def test_renders_horizontal_scrollbar
    render_inline(Shadcn::ScrollAreaComponent.new(orientation: :horizontal)) { "Content" }

    assert_selector "div[data-orientation='horizontal']"
    assert_selector "div[data-shadcn--scroll-area-orientation-value='horizontal']"
  end

  def test_renders_both_scrollbars
    render_inline(Shadcn::ScrollAreaComponent.new(orientation: :both)) { "Content" }

    assert_selector "div[data-orientation='vertical']"
    assert_selector "div[data-orientation='horizontal']"
    assert_selector "div[data-shadcn--scroll-area-orientation-value='both']"
  end

  def test_renders_scrollbar_thumb
    render_inline(Shadcn::ScrollAreaComponent.new) { "Content" }

    assert_selector "div[data-shadcn--scroll-area-target='thumb']"
    assert_selector "div.rounded-full.bg-border"
  end

  def test_renders_with_hover_type_by_default
    render_inline(Shadcn::ScrollAreaComponent.new) { "Content" }

    assert_selector "div[data-shadcn--scroll-area-type-value='hover']"
  end

  def test_renders_with_always_type
    render_inline(Shadcn::ScrollAreaComponent.new(type: :always)) { "Content" }

    assert_selector "div[data-shadcn--scroll-area-type-value='always']"
  end

  def test_renders_corner_for_both_orientation
    render_inline(Shadcn::ScrollAreaComponent.new(orientation: :both)) { "Content" }

    # Corner element should be present when both scrollbars are shown
    assert_selector "div.absolute.right-0.bottom-0"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::ScrollAreaComponent.new(class_name: "h-72 w-48")) { "Content" }

    assert_selector "div.h-72.w-48"
  end

  def test_renders_content
    render_inline(Shadcn::ScrollAreaComponent.new) { "Test content here" }

    assert_text "Test content here"
  end
end
