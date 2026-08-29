# frozen_string_literal: true

# @label Button Group
# @display bg_color "#ffffff"
class ButtonGroupComponentPreview < ViewComponent::Preview
  # @label Default
  # Horizontal button group
  def default
    render(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button(variant: :outline) { "Left" }
      group.with_button(variant: :outline) { "Center" }
      group.with_button(variant: :outline) { "Right" }
    end
  end

  # @label Outline Variant
  # Button group with outline buttons
  def outline
    render(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button(variant: :outline) { "Bold" }
      group.with_button(variant: :outline) { "Italic" }
      group.with_button(variant: :outline) { "Underline" }
    end
  end

  # @label Vertical
  # Vertical button group
  def vertical
    render(Shadcn::ButtonGroupComponent.new(orientation: :vertical)) do |group|
      group.with_button(variant: :outline) { "Top" }
      group.with_button(variant: :outline) { "Middle" }
      group.with_button(variant: :outline) { "Bottom" }
    end
  end

  # @label Mixed Variants
  # Button group with mixed variants
  def mixed
    render(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button { "Save" }
      group.with_button(variant: :outline) { "Cancel" }
    end
  end

  # @label With Icons
  # Button group with icon buttons
  def with_icons
    render(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button(variant: :outline, size: :icon) { icon("M15 6l-6 6 6 6") }
      group.with_button(variant: :outline, size: :icon) { icon("M9 18l6-6-6-6") }
    end
  end

  private

  def icon(path)
    %(<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="#{path}"></path></svg>).html_safe
  end
end
