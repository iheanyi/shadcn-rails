# frozen_string_literal: true

# @label Separator
class SeparatorComponentPreview < ViewComponent::Preview
  # @label Horizontal
  def horizontal
    render Ui::SeparatorComponent.new
  end

  # @label Vertical
  def vertical
    render_with_template
  end
end
