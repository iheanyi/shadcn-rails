# frozen_string_literal: true

# @label Spinner
class SpinnerComponentPreview < ViewComponent::Preview
  # @label Default
  def default
    render Ui::SpinnerComponent.new
  end

  # @label Sizes
  def sizes
    render_with_template
  end

  # @!group Playground
  # @param size select { choices: [sm, default, lg, xl] }
  def playground(size: :default)
    render Ui::SpinnerComponent.new(size: size.to_sym)
  end
  # @!endgroup
end
