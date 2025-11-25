# frozen_string_literal: true

# @label Button
class ButtonComponentPreview < ViewComponent::Preview
  # @label Default
  # @display bg_color "#ffffff"
  def default
    render Ui::ButtonComponent.new do
      "Button"
    end
  end

  # @label Variants
  # Shows all button variants
  def variants
    render_with_template
  end

  # @label Sizes
  # Shows all button sizes
  def sizes
    render_with_template
  end

  # @label Destructive
  def destructive
    render Ui::ButtonComponent.new(variant: :destructive) do
      "Delete"
    end
  end

  # @label Outline
  def outline
    render Ui::ButtonComponent.new(variant: :outline) do
      "Outline"
    end
  end

  # @label Secondary
  def secondary
    render Ui::ButtonComponent.new(variant: :secondary) do
      "Secondary"
    end
  end

  # @label Ghost
  def ghost
    render Ui::ButtonComponent.new(variant: :ghost) do
      "Ghost"
    end
  end

  # @label Link
  def link
    render Ui::ButtonComponent.new(variant: :link) do
      "Link"
    end
  end

  # @label Disabled
  def disabled
    render Ui::ButtonComponent.new(disabled: true) do
      "Disabled"
    end
  end

  # @label With Icon
  def with_icon
    render_with_template
  end

  # @!group Playground
  # @param variant select { choices: [default, destructive, outline, secondary, ghost, link] }
  # @param size select { choices: [default, sm, lg, icon] }
  # @param disabled toggle
  # @param text text
  def playground(variant: :default, size: :default, disabled: false, text: "Button")
    render Ui::ButtonComponent.new(variant: variant.to_sym, size: size.to_sym, disabled: disabled) do
      text
    end
  end
  # @!endgroup
end
