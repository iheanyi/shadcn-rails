# frozen_string_literal: true

require "test_helper"

class SpinnerComponentTest < ViewComponent::TestCase
  def test_renders_spinner
    render_inline(Shadcn::SpinnerComponent.new)

    assert_selector "svg[role='status']"
    assert_selector "svg[aria-label='Loading']"
  end

  def test_renders_with_animation
    render_inline(Shadcn::SpinnerComponent.new)

    assert_selector "svg.animate-spin"
  end

  def test_renders_with_default_size
    render_inline(Shadcn::SpinnerComponent.new)

    assert_selector "svg.h-6.w-6"
  end

  def test_renders_with_small_size
    render_inline(Shadcn::SpinnerComponent.new(size: :sm))

    assert_selector "svg.h-4.w-4"
  end

  def test_renders_with_large_size
    render_inline(Shadcn::SpinnerComponent.new(size: :lg))

    assert_selector "svg.h-8.w-8"
  end

  def test_renders_with_xl_size
    render_inline(Shadcn::SpinnerComponent.new(size: :xl))

    assert_selector "svg.h-12.w-12"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::SpinnerComponent.new(class_name: "text-primary"))

    assert_selector "svg.text-primary"
  end

  def test_renders_svg_elements
    render_inline(Shadcn::SpinnerComponent.new)

    assert_selector "svg circle"
    assert_selector "svg path"
  end
end
