# frozen_string_literal: true

require "test_helper"

class AspectRatioComponentTest < ViewComponent::TestCase
  def test_renders_aspect_ratio_container
    render_inline(Shadcn::AspectRatioComponent.new) { "Content" }

    assert_selector "div.relative"
    assert_selector "div.absolute"
  end

  def test_renders_with_16_9_ratio
    render_inline(Shadcn::AspectRatioComponent.new(ratio: 16.0 / 9.0)) { "Video" }

    # 9/16 * 100 = 56.25%
    assert_selector "div[style*='padding-bottom: 56.25%']"
  end

  def test_renders_with_square_ratio
    render_inline(Shadcn::AspectRatioComponent.new(ratio: 1)) { "Square" }

    # 1/1 * 100 = 100%
    assert_selector "div[style*='padding-bottom: 100.0%']"
  end

  def test_renders_with_4_3_ratio
    render_inline(Shadcn::AspectRatioComponent.new(ratio: 4.0 / 3.0)) { "Photo" }

    # 3/4 * 100 = 75%
    assert_selector "div[style*='padding-bottom: 75.0%']"
  end

  def test_renders_content_in_inner_div
    render_inline(Shadcn::AspectRatioComponent.new) { "Image goes here" }

    assert_selector "div.absolute", text: "Image goes here"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::AspectRatioComponent.new(class_name: "bg-muted")) { "Content" }

    assert_selector "div.bg-muted"
  end
end
