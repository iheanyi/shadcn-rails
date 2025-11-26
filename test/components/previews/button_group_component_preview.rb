# frozen_string_literal: true

# @label Button Group
# @display bg_color "#ffffff"
class ButtonGroupComponentPreview < ViewComponent::Preview
  # @label Default
  # Horizontal button group
  def default
    render_with_template
  end

  # @label Outline Variant
  # Button group with outline buttons
  def outline
    render_with_template
  end

  # @label Vertical
  # Vertical button group
  def vertical
    render_with_template
  end

  # @label Mixed Variants
  # Button group with mixed variants
  def mixed
    render_with_template
  end

  # @label With Icons
  # Button group with icon buttons
  def with_icons
    render_with_template
  end
end
