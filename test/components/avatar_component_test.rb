# frozen_string_literal: true

require "test_helper"

class AvatarComponentTest < ViewComponent::TestCase
  def test_renders_avatar_with_image
    render_inline(Shadcn::AvatarComponent.new(
      src: "https://example.com/avatar.jpg",
      alt: "John Doe"
    ))

    assert_selector "span.relative.flex.shrink-0.overflow-hidden.rounded-full"
    assert_selector "img[src='https://example.com/avatar.jpg']"
    assert_selector "img[alt='John Doe']"
  end

  def test_renders_fallback_when_no_src
    render_inline(Shadcn::AvatarComponent.new(alt: "John Doe"))

    assert_selector "span.flex.items-center.justify-center", text: "JD"
  end

  def test_generates_initials_from_name
    render_inline(Shadcn::AvatarComponent.new(alt: "Jane Smith"))

    assert_selector "span", text: "JS"
  end

  def test_renders_custom_fallback
    render_inline(Shadcn::AvatarComponent.new(alt: "User", fallback: "US"))

    assert_selector "span", text: "US"
  end

  def test_renders_different_sizes
    # Small
    render_inline(Shadcn::AvatarComponent.new(alt: "User", size: :sm))
    assert_selector "span.h-8.w-8"

    # Default
    render_inline(Shadcn::AvatarComponent.new(alt: "User", size: :default))
    assert_selector "span.h-10.w-10"

    # Large
    render_inline(Shadcn::AvatarComponent.new(alt: "User", size: :lg))
    assert_selector "span.h-12.w-12"

    # XL
    render_inline(Shadcn::AvatarComponent.new(alt: "User", size: :xl))
    assert_selector "span.h-16.w-16"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::AvatarComponent.new(alt: "User", class_name: "my-avatar"))

    assert_selector "span.my-avatar"
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::AvatarComponent.new(alt: "User", class: "alias-class"))

    assert_selector "span.alias-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::AvatarComponent.new(alt: "User", data: { testid: "avatar" }))

    assert_selector "[data-testid='avatar']"
  end
end
