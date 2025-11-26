# frozen_string_literal: true

# @label Avatar
# @display bg_color "#ffffff"
class AvatarComponentPreview < ViewComponent::Preview
  # @label Default
  # Avatar with image and automatic fallback
  def default
    render(Shadcn::AvatarComponent.new(
      src: "https://github.com/shadcn.png",
      alt: "shadcn"
    ))
  end

  # @label All Sizes
  # Shows all available avatar sizes
  # @param size select { choices: [sm, default, lg, xl] }
  def sizes(size: :default)
    render(Shadcn::AvatarComponent.new(
      src: "https://github.com/shadcn.png",
      alt: "shadcn",
      size: size.to_sym
    ))
  end

  # @label With Fallback
  # Avatar with custom fallback text when image fails
  def with_fallback
    render(Shadcn::AvatarComponent.new(
      src: "https://invalid-url-for-demo.png",
      alt: "John Doe",
      fallback: "JD"
    ))
  end

  # @label Fallback Only
  # Avatar showing only fallback initials without image
  def fallback_only
    render(Shadcn::AvatarComponent.new(
      alt: "Jane Smith"
    ))
  end

  # @label Custom Fallback with Slot
  # Avatar using slot-based fallback
  def custom_fallback_with_slot
    render(Shadcn::AvatarComponent.new(size: :lg)) do |avatar|
      avatar.with_fallback { "CN" }
    end
  end

  # @label Multiple Avatars
  # Display multiple avatars with different sizes and states
  def multiple_avatars
    tag.div(class: "flex items-center gap-4") do
      safe_join([
        render(Shadcn::AvatarComponent.new(
          src: "https://github.com/shadcn.png",
          alt: "shadcn",
          size: :sm
        )),
        render(Shadcn::AvatarComponent.new(
          src: "https://github.com/vercel.png",
          alt: "vercel",
          size: :default
        )),
        render(Shadcn::AvatarComponent.new(
          alt: "Jane Doe",
          size: :lg
        )),
        render(Shadcn::AvatarComponent.new(
          alt: "Alex Smith",
          size: :xl
        ))
      ])
    end
  end

  # @label Avatar Group
  # Stack of overlapping avatars
  def avatar_group
    tag.div(class: "flex -space-x-4") do
      safe_join([
        render(Shadcn::AvatarComponent.new(
          src: "https://github.com/shadcn.png",
          alt: "User 1",
          class_name: "ring-2 ring-background"
        )),
        render(Shadcn::AvatarComponent.new(
          src: "https://github.com/vercel.png",
          alt: "User 2",
          class_name: "ring-2 ring-background"
        )),
        render(Shadcn::AvatarComponent.new(
          alt: "User 3",
          class_name: "ring-2 ring-background"
        )),
        render(Shadcn::AvatarComponent.new(
          alt: "User 4",
          class_name: "ring-2 ring-background"
        ))
      ])
    end
  end
end
