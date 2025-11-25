# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class SpinnerComponentTest < ViewComponent::TestCase
  def test_renders_spinner
    render_inline(Ui::SpinnerComponent.new)

    assert_selector "svg.animate-spin"
  end

  def test_renders_small_size
    render_inline(Ui::SpinnerComponent.new(size: :sm))

    assert_selector "svg.h-4"
    assert_selector "svg.w-4"
  end

  def test_renders_default_size
    render_inline(Ui::SpinnerComponent.new(size: :default))

    assert_selector "svg.h-6"
    assert_selector "svg.w-6"
  end

  def test_renders_large_size
    render_inline(Ui::SpinnerComponent.new(size: :lg))

    assert_selector "svg.h-8"
    assert_selector "svg.w-8"
  end

  def test_renders_xl_size
    render_inline(Ui::SpinnerComponent.new(size: :xl))

    assert_selector "svg.h-12"
    assert_selector "svg.w-12"
  end

  def test_accepts_custom_classes
    render_inline(Ui::SpinnerComponent.new(class_name: "text-blue-500"))

    assert_selector "svg.text-blue-500"
  end

  def test_has_svg_structure
    render_inline(Ui::SpinnerComponent.new)

    assert_selector "svg circle"
    assert_selector "svg path"
  end
end
