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

    classes = page.find("svg")[:class].split

    assert_includes classes, "size-4"
    refute_includes classes, "h-4"
    refute_includes classes, "w-4"
    refute_includes classes, "text-muted-foreground"
  end

  def test_renders_with_small_size
    render_inline(Shadcn::SpinnerComponent.new(size: :sm))

    classes = page.find("svg")[:class].split

    assert_includes classes, "size-4"
    refute_includes classes, "h-4"
    refute_includes classes, "w-4"
  end

  def test_renders_with_large_size
    render_inline(Shadcn::SpinnerComponent.new(size: :lg))

    assert_selector "svg.size-8"
  end

  def test_renders_with_xl_size
    render_inline(Shadcn::SpinnerComponent.new(size: :xl))

    assert_selector "svg.size-12"
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
