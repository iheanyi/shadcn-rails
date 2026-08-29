# frozen_string_literal: true

# @label Badge
# @display bg_color "#ffffff"
class BadgeComponentPreview < ViewComponent::Preview
  # @label Default
  # Default badge style
  def default
    render(Shadcn::BadgeComponent.new) { "Badge" }
  end

  # @label All Variants
  # Shows all available badge variants
  # @param variant select { choices: [default, secondary, destructive, outline] }
  def variants(variant: :default)
    render(Shadcn::BadgeComponent.new(variant: variant.to_sym)) { variant.to_s.titleize }
  end

  # @label Secondary
  # Secondary badge variant
  def secondary
    render(Shadcn::BadgeComponent.new(variant: :secondary)) { "Secondary" }
  end

  # @label Destructive
  # Destructive badge variant
  def destructive
    render(Shadcn::BadgeComponent.new(variant: :destructive)) { "Destructive" }
  end

  # @label Outline
  # Outline badge variant
  def outline
    render(Shadcn::BadgeComponent.new(variant: :outline)) { "Outline" }
  end

  # @label Collection
  # Multiple badges together
  def collection
    render(Shadcn::BadgeComponent.new(variant: :secondary)) { "Secondary" }
  end
end
