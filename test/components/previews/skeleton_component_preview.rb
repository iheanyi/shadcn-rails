# frozen_string_literal: true

# @label Skeleton
# @display bg_color "#ffffff"
class SkeletonComponentPreview < ViewComponent::Preview
  # @label Default
  # Default skeleton loader
  def default
    render(Shadcn::SkeletonComponent.new(class_name: "h-4 w-[250px]"))
  end

  # @label Circle
  # Circular skeleton (for avatars)
  def circle
    render(Shadcn::SkeletonComponent.new(class_name: "h-12 w-12 rounded-full"))
  end

  # @label Rectangle
  # Rectangular skeleton
  def rectangle
    render(Shadcn::SkeletonComponent.new(class_name: "h-[125px] w-[250px] rounded-xl"))
  end

  # @label Text Line
  # Skeleton for a line of text
  def text_line
    render(Shadcn::SkeletonComponent.new(class_name: "h-4 w-full"))
  end

  # @label Button
  # Skeleton for a button
  def button
    render(Shadcn::SkeletonComponent.new(class_name: "h-10 w-[120px] rounded-md"))
  end

  # @label Card
  # Complete card skeleton with image and text
  def card
    render(Shadcn::SkeletonComponent.new(class_name: "h-[180px] w-[320px] rounded-xl"))
  end

  # @label Profile
  # Profile skeleton with avatar and text
  def profile
    render(Shadcn::SkeletonComponent.new(class_name: "h-12 w-12 rounded-full"))
  end

  # @label Article
  # Article skeleton with multiple text lines
  def article
    render(Shadcn::SkeletonComponent.new(class_name: "h-4 w-[320px]"))
  end
end
