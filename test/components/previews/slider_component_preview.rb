# frozen_string_literal: true

# @label Slider
# @display bg_color "#ffffff"
class SliderComponentPreview < ViewComponent::Preview
  # @label Default
  # Default slider with value of 50
  def default
    render(Shadcn::SliderComponent.new(name: "volume", value: 50, max: 100))
  end

  # @label Custom Range
  # Slider with custom min, max, and step values
  # @param value number
  # @param min number
  # @param max number
  # @param step number
  def custom_range(value: 50, min: 0, max: 100, step: 1)
    render(Shadcn::SliderComponent.new(
      name: "custom",
      value: value,
      min: min,
      max: max,
      step: step
    ))
  end

  # @label Rating
  # Slider for rating (1-5 stars)
  def rating
    render(Shadcn::SliderComponent.new(
      name: "rating",
      value: 3,
      min: 1,
      max: 5,
      step: 1
    ))
  end

  # @label Volume Control
  # Slider for volume control (0-100)
  def volume
    render(Shadcn::SliderComponent.new(
      name: "volume",
      value: 75,
      min: 0,
      max: 100,
      step: 5
    ))
  end

  # @label Disabled
  # Disabled slider
  def disabled
    render(Shadcn::SliderComponent.new(
      name: "disabled",
      value: 50,
      max: 100,
      disabled: true
    ))
  end

  # @label Temperature
  # Slider with decimal values
  def temperature
    render(Shadcn::SliderComponent.new(
      name: "temperature",
      value: 20.5,
      min: 15.0,
      max: 30.0,
      step: 0.5
    ))
  end

  # @label With Label
  # Slider with label and value display
  def with_label
    render_with_template
  end
end
