# frozen_string_literal: true

# @label Progress
class ProgressComponentPreview < ViewComponent::Preview
  # @label Default
  def default
    render Ui::ProgressComponent.new(value: 33)
  end

  # @label Values
  def values
    render_with_template
  end

  # @!group Playground
  # @param value range { min: 0, max: 100, step: 1 }
  def playground(value: 50)
    render Ui::ProgressComponent.new(value: value.to_i)
  end
  # @!endgroup
end
