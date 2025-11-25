# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class SkeletonComponentTest < ViewComponent::TestCase
  def test_renders_skeleton
    render_inline(Ui::SkeletonComponent.new)

    assert_selector "div.animate-pulse"
    assert_selector "div.rounded-md"
    assert_selector "div.bg-primary\\/10"
  end

  def test_accepts_custom_dimensions
    render_inline(Ui::SkeletonComponent.new(class_name: "h-12 w-12"))

    assert_selector "div.h-12"
    assert_selector "div.w-12"
  end

  def test_accepts_custom_shape
    render_inline(Ui::SkeletonComponent.new(class_name: "rounded-full"))

    assert_selector "div.rounded-full"
  end

  def test_accepts_custom_classes
    render_inline(Ui::SkeletonComponent.new(class_name: "custom-skeleton"))

    assert_selector "div.custom-skeleton"
  end
end
