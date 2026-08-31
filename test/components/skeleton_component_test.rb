# frozen_string_literal: true

require "test_helper"

class SkeletonComponentTest < ViewComponent::TestCase
  def test_renders_skeleton
    render_inline(Shadcn::SkeletonComponent.new)

    assert_selector "div.animate-pulse.rounded-md"
    assert_selector "div.bg-accent"
    refute_selector "div.bg-primary\\/10"
    assert_selector "div[data-slot='skeleton']"
  end

  def test_renders_with_custom_dimensions
    render_inline(Shadcn::SkeletonComponent.new(class_name: "h-4 w-[250px]"))

    assert_selector "div.h-4"
    assert_selector "div.w-\\[250px\\]"
  end

  def test_renders_rounded_full
    render_inline(Shadcn::SkeletonComponent.new(class_name: "h-12 w-12 rounded-full"))

    assert_selector "div.rounded-full"
  end

  def test_renders_with_content
    render_inline(Shadcn::SkeletonComponent.new) { "Loading..." }

    assert_selector "div", text: "Loading..."
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::SkeletonComponent.new(class_name: "my-skeleton"))

    assert_selector "div.my-skeleton"
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::SkeletonComponent.new(class: "alias-class"))

    assert_selector "div.alias-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::SkeletonComponent.new(data: { testid: "skeleton" }))

    assert_selector "[data-testid='skeleton']"
  end
end
