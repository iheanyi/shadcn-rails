# frozen_string_literal: true

require "test_helper"

class ProgressComponentTest < ViewComponent::TestCase
  def test_renders_progress_bar
    render_inline(Shadcn::ProgressComponent.new(value: 50))

    assert_selector "div[role='progressbar']"
    assert_selector "div[aria-valuenow='50']"
    assert_selector "div[aria-valuemin='0']"
    assert_selector "div[aria-valuemax='100']"
  end

  def test_renders_with_custom_max
    render_inline(Shadcn::ProgressComponent.new(value: 25, max: 50))

    assert_selector "div[aria-valuemax='50']"
    assert_selector "div[data-value='25']"
  end

  def test_renders_indeterminate_state
    render_inline(Shadcn::ProgressComponent.new(indeterminate: true))

    assert_selector "div[data-state='indeterminate']"
    assert_no_selector "div[aria-valuenow]"
  end

  def test_renders_with_zero_value
    render_inline(Shadcn::ProgressComponent.new(value: 0))

    assert_selector "div[aria-valuenow='0']"
  end

  def test_renders_with_full_value
    render_inline(Shadcn::ProgressComponent.new(value: 100))

    assert_selector "div[aria-valuenow='100']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::ProgressComponent.new(value: 50, class_name: "my-progress"))

    assert_selector "div.my-progress"
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::ProgressComponent.new(value: 50, class: "alias-class"))

    assert_selector "div.alias-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::ProgressComponent.new(value: 50, data: { testid: "progress" }))

    assert_selector "[data-testid='progress']"
  end
end
