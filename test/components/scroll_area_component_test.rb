# frozen_string_literal: true

require "test_helper"

class ScrollAreaComponentTest < ViewComponent::TestCase
  def test_renders_scroll_area_container
    render_inline(Shadcn::ScrollAreaComponent.new) { "Content" }

    root = page.find("div[data-controller='shadcn--scroll-area']")
    class_tokens = root["class"].split

    assert_equal "scroll-area", root["data-slot"]
    assert_equal ["relative"], class_tokens
    refute_includes class_tokens, "overflow-hidden"
  end

  def test_renders_viewport
    render_inline(Shadcn::ScrollAreaComponent.new) { "Scrollable content" }

    viewport = page.find("div[data-shadcn--scroll-area-target='viewport']")
    class_tokens = viewport["class"].split

    assert_equal "scroll-area-viewport", viewport["data-slot"]
    assert_equal [
      "size-full",
      "rounded-[inherit]",
      "transition-[color,box-shadow]",
      "outline-none",
      "focus-visible:ring-[3px]",
      "focus-visible:ring-ring/50",
      "focus-visible:outline-1"
    ], class_tokens
    refute_includes class_tokens, "h-full"
    refute_includes class_tokens, "w-full"
    refute_includes class_tokens, "overflow-y-auto"
  end

  def test_renders_vertical_scrollbar_by_default
    render_inline(Shadcn::ScrollAreaComponent.new) { "Content" }

    scrollbar = page.find("div[data-orientation='vertical']")
    class_tokens = scrollbar["class"].split

    assert_equal "scroll-area-scrollbar", scrollbar["data-slot"]
    assert_equal [
      "flex",
      "touch-none",
      "p-px",
      "transition-colors",
      "select-none",
      "h-full",
      "w-2.5",
      "border-l",
      "border-l-transparent"
    ], class_tokens
    assert_equal "scrollbar", scrollbar["data-shadcn--scroll-area-target"]
    refute_includes class_tokens, "p-[1px]"
  end

  def test_renders_horizontal_scrollbar
    render_inline(Shadcn::ScrollAreaComponent.new(orientation: :horizontal)) { "Content" }

    scrollbar = page.find("div[data-orientation='horizontal']")
    class_tokens = scrollbar["class"].split

    assert_equal "scroll-area-scrollbar", scrollbar["data-slot"]
    assert_equal [
      "flex",
      "touch-none",
      "p-px",
      "transition-colors",
      "select-none",
      "h-2.5",
      "flex-col",
      "border-t",
      "border-t-transparent"
    ], class_tokens
    assert_selector "div[data-shadcn--scroll-area-orientation-value='horizontal']"
    refute_includes class_tokens, "p-[1px]"
  end

  def test_renders_both_scrollbars
    render_inline(Shadcn::ScrollAreaComponent.new(orientation: :both)) { "Content" }

    assert_selector "div[data-orientation='vertical']"
    assert_selector "div[data-orientation='horizontal']"
    assert_selector "div[data-shadcn--scroll-area-orientation-value='both']"
  end

  def test_renders_scrollbar_thumb
    render_inline(Shadcn::ScrollAreaComponent.new) { "Content" }

    thumb = page.find("div[data-shadcn--scroll-area-target='thumb']")

    assert_equal "scroll-area-thumb", thumb["data-slot"]
    assert_equal [
      "relative",
      "flex-1",
      "rounded-full",
      "bg-border"
    ], thumb["class"].split
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
