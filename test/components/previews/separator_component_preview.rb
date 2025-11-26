# frozen_string_literal: true

# @label Separator
# @display bg_color "#ffffff"
class SeparatorComponentPreview < ViewComponent::Preview
  # @label Default
  # Default horizontal separator
  def default
    render(Shadcn::SeparatorComponent.new)
  end

  # @label Orientations
  # Separator with different orientations
  # @param orientation select { choices: [horizontal, vertical] }
  def orientations(orientation: :horizontal)
    render(Shadcn::SeparatorComponent.new(orientation: orientation.to_sym))
  end

  # @label Horizontal
  # Horizontal separator
  def horizontal
    render(Shadcn::SeparatorComponent.new(orientation: :horizontal))
  end

  # @label Vertical
  # Vertical separator (requires parent with height)
  def vertical
    render(Shadcn::SeparatorComponent.new(orientation: :vertical))
  end

  # @label Decorative
  # Decorative separator (no semantic meaning)
  def decorative
    render(Shadcn::SeparatorComponent.new(decorative: true))
  end

  # @label In Content
  # Separator between content sections
  def in_content
    render_with_template
  end

  # @label With Text
  # Separator with text in between
  def with_text
    render_with_template
  end

  # @label Vertical in Toolbar
  # Vertical separator in a toolbar layout
  def vertical_in_toolbar
    render_with_template
  end
end
