# frozen_string_literal: true

require "test_helper"

class SliderComponentTest < ViewComponent::TestCase
  def test_renders_native_range_input
    render_inline(Shadcn::SliderComponent.new)

    assert_selector "input[type='range']"
    assert_selector "input[data-controller='shadcn--slider']"
  end

  def test_renders_with_value_attributes
    render_inline(Shadcn::SliderComponent.new(min: 0, max: 100, value: 50))

    assert_selector "input[min='0.0']"
    assert_selector "input[max='100.0']"
    assert_selector "input[value='50.0']"
  end

  def test_renders_with_custom_range
    render_inline(Shadcn::SliderComponent.new(min: 1, max: 10, value: 5, step: 1))

    assert_selector "input[min='1.0']"
    assert_selector "input[max='10.0']"
    assert_selector "input[step='1.0']"
    assert_selector "input[value='5.0']"
  end

  def test_renders_with_name_attribute
    render_inline(Shadcn::SliderComponent.new(name: "volume", value: 50))

    assert_selector "input[type='range'][name='volume'][value='50.0']"
  end

  def test_does_not_render_name_without_name_param
    result = render_inline(Shadcn::SliderComponent.new(value: 50))

    refute result.css("input[name]").any?
  end

  def test_renders_with_disabled_state
    render_inline(Shadcn::SliderComponent.new(disabled: true))

    assert_selector "input[disabled]"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::SliderComponent.new(class_name: "my-slider"))

    assert_selector "input.my-slider"
  end

  def test_calculates_percentage_style
    result = render_inline(Shadcn::SliderComponent.new(min: 0, max: 100, value: 25))

    # The style should include the fill percentage
    html = result.to_html
    assert html.include?("--slider-fill: 25.0%")
  end

  def test_renders_with_stimulus_action
    render_inline(Shadcn::SliderComponent.new)

    assert_selector "input[data-action='input->shadcn--slider#updateStyle']"
  end

  def test_renders_base_classes
    render_inline(Shadcn::SliderComponent.new)

    assert_selector "input.shadcn-slider"
    assert_selector "input.w-full"
  end
end
