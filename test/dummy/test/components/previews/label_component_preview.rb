# frozen_string_literal: true

# @label Label
class LabelComponentPreview < ViewComponent::Preview
  # @label Default
  def default
    render Ui::LabelComponent.new do
      "Email"
    end
  end

  # @label Required
  def required
    render Ui::LabelComponent.new(required: true) do
      "Name"
    end
  end

  # @label With Input
  def with_input
    render_with_template
  end
end
