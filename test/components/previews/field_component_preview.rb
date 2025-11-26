# frozen_string_literal: true

# @label Field
# @display bg_color "#ffffff"
class FieldComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic field with label and input
  def default
    render_with_template
  end

  # @label With Description
  # Field with helpful description text
  def with_description
    render_with_template
  end

  # @label With Error
  # Field showing validation error
  def with_error
    render_with_template
  end

  # @label Email Field
  # Email field with placeholder
  def email
    render_with_template
  end

  # @label Required Field
  # Field marked as required
  def required
    render_with_template
  end
end
