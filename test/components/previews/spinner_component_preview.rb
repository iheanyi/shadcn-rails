# frozen_string_literal: true

# @label Spinner
# @display bg_color "#ffffff"
class SpinnerComponentPreview < ViewComponent::Preview
  # @label Default
  # Default spinner size
  def default
    render(Shadcn::SpinnerComponent.new)
  end

  # @label Small
  # Small spinner variant
  def small
    render(Shadcn::SpinnerComponent.new(size: :sm))
  end

  # @label Large
  # Large spinner variant
  def large
    render(Shadcn::SpinnerComponent.new(size: :lg))
  end

  # @label Extra Large
  # Extra large spinner variant
  def extra_large
    render(Shadcn::SpinnerComponent.new(size: :xl))
  end

  # @label All Sizes
  # All available spinner sizes
  # @param size select { choices: [sm, default, lg, xl] }
  def sizes(size: :default)
    render(Shadcn::SpinnerComponent.new(size: size.to_sym))
  end

  # @label With Button
  # Spinner inside a loading button
  def with_button
    render(Shadcn::SpinnerComponent.new(size: :sm))
  end
end
