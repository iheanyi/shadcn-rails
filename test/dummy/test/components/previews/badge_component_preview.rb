# frozen_string_literal: true

# @label Badge
class BadgeComponentPreview < ViewComponent::Preview
  # @label Default
  def default
    render Ui::BadgeComponent.new do
      "Badge"
    end
  end

  # @label Variants
  def variants
    render_with_template
  end

  # @label Secondary
  def secondary
    render Ui::BadgeComponent.new(variant: :secondary) do
      "Secondary"
    end
  end

  # @label Destructive
  def destructive
    render Ui::BadgeComponent.new(variant: :destructive) do
      "Destructive"
    end
  end

  # @label Outline
  def outline
    render Ui::BadgeComponent.new(variant: :outline) do
      "Outline"
    end
  end

  # @!group Playground
  # @param variant select { choices: [default, secondary, destructive, outline] }
  # @param text text
  def playground(variant: :default, text: "Badge")
    render Ui::BadgeComponent.new(variant: variant.to_sym) do
      text
    end
  end
  # @!endgroup
end
