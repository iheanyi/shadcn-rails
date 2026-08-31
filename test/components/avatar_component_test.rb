# frozen_string_literal: true

require "test_helper"

class AvatarComponentTest < ViewComponent::TestCase
  def test_renders_avatar_with_image
    render_inline(Shadcn::AvatarComponent.new(
      src: "https://example.com/avatar.jpg",
      alt: "John Doe"
    ))

    assert_selector "span[data-slot='avatar']"
    assert_includes rendered_content, "group/avatar relative flex size-8 shrink-0 overflow-hidden rounded-full select-none data-[size=lg]:size-10 data-[size=sm]:size-6"
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
    assert_selector "span[data-slot='avatar'][data-size='sm']"
    assert_includes rendered_content, "data-[size=sm]:size-6"

    # Default
    render_inline(Shadcn::AvatarComponent.new(alt: "User", size: :default))
    assert_selector "span[data-slot='avatar'][data-size='default']"
    assert_includes rendered_content, "size-8"
    assert_no_includes rendered_content, "h-10 w-10"
    assert_no_includes rendered_content, "data-[size=default]"

    # Large
    render_inline(Shadcn::AvatarComponent.new(alt: "User", size: :lg))
    assert_selector "span[data-slot='avatar'][data-size='lg']"
    assert_includes rendered_content, "data-[size=lg]:size-10"

    # XL
    render_inline(Shadcn::AvatarComponent.new(alt: "User", size: :xl))
    assert_selector "span[data-slot='avatar'][data-size='xl']"
    assert_includes rendered_content, "size-16"
  end

  def test_renders_new_york_v4_default_slot_and_size_classes
    render_inline(Shadcn::AvatarComponent.new(alt: "User"))

    assert_selector "span[data-slot='avatar'][data-size='default']"
    assert_includes rendered_content, "size-8"
    assert_no_includes rendered_content, "h-10 w-10"
    assert_no_includes rendered_content, "data-[size=default]"
  end

  def test_renders_new_york_v4_image_slot_and_size_class
    render_inline(Shadcn::AvatarComponent.new(
      src: "https://example.com/avatar.jpg",
      alt: "User"
    ))

    assert_selector "img[data-slot='avatar-image']"
    assert_includes rendered_content, "aspect-square size-full"
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
