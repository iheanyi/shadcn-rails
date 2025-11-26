# frozen_string_literal: true

require "test_helper"

class SliderComponentTest < ViewComponent::TestCase
  def test_renders_slider_container
    render_inline(Shadcn::SliderComponent.new)

    assert_selector "div[role='slider']"
    assert_selector "div[data-controller='shadcn--slider']"
  end

  def test_renders_with_aria_attributes
    render_inline(Shadcn::SliderComponent.new(min: 0, max: 100, value: 50))

    assert_selector "div[aria-valuemin='0.0']"
    assert_selector "div[aria-valuemax='100.0']"
    assert_selector "div[aria-valuenow='50.0']"
  end

  def test_renders_with_custom_range
    render_inline(Shadcn::SliderComponent.new(min: 1, max: 10, value: 5, step: 1))

    assert_selector "div[data-shadcn--slider-min-value='1.0']"
    assert_selector "div[data-shadcn--slider-max-value='10.0']"
    assert_selector "div[data-shadcn--slider-step-value='1.0']"
  end

  def test_renders_track_and_thumb
    render_inline(Shadcn::SliderComponent.new)

    assert_selector "div[data-shadcn--slider-target='track']"
    assert_selector "div[data-shadcn--slider-target='range']"
    assert_selector "div[data-shadcn--slider-target='thumb']"
  end

  def test_renders_hidden_input_when_name_provided
    render_inline(Shadcn::SliderComponent.new(name: "volume", value: 50))

    assert_selector "input[type='hidden'][name='volume'][value='50.0']", visible: :all
  end

  def test_does_not_render_hidden_input_without_name
    result = render_inline(Shadcn::SliderComponent.new(value: 50))

    refute result.css("input[type='hidden']").any?
  end

  def test_renders_with_disabled_state
    render_inline(Shadcn::SliderComponent.new(disabled: true))

    assert_selector "div[aria-disabled='true']"
    assert_selector "div[data-shadcn--slider-disabled-value='true']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::SliderComponent.new(class_name: "my-slider"))

    assert_selector "div.my-slider"
  end

  def test_calculates_percentage_correctly
    render_inline(Shadcn::SliderComponent.new(min: 0, max: 100, value: 25))

    # The range should have 25% width
    assert_selector "div[data-shadcn--slider-target='range'][style*='width: 25.0%']"
  end
end
