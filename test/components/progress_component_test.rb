# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class ProgressComponentTest < ViewComponent::TestCase
  def test_renders_progress
    render_inline(Ui::ProgressComponent.new(value: 50))

    assert_selector "div[role='progressbar']"
    assert_selector "div[aria-valuenow='50']"
    assert_selector "div[aria-valuemin='0']"
    assert_selector "div[aria-valuemax='100']"
  end

  def test_renders_with_zero_value
    render_inline(Ui::ProgressComponent.new(value: 0))

    assert_selector "div[aria-valuenow='0']"
  end

  def test_renders_with_full_value
    render_inline(Ui::ProgressComponent.new(value: 100))

    assert_selector "div[aria-valuenow='100']"
  end

  def test_renders_with_custom_max
    render_inline(Ui::ProgressComponent.new(value: 50, max: 200))

    assert_selector "div[aria-valuemax='200']"
  end

  def test_has_indicator
    render_inline(Ui::ProgressComponent.new(value: 50))

    assert_selector "div.bg-primary"
  end

  def test_accepts_custom_classes
    render_inline(Ui::ProgressComponent.new(value: 50, class_name: "custom-progress"))

    assert_selector "div.custom-progress"
  end

  def test_has_proper_structure
    render_inline(Ui::ProgressComponent.new(value: 50))

    assert_selector "div.h-2"
    assert_selector "div.rounded-full"
    assert_selector "div.bg-primary\\/20"
  end
end
