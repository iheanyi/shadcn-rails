# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class AvatarComponentTest < ViewComponent::TestCase
  def test_renders_avatar
    render_inline(Ui::AvatarComponent.new)

    assert_selector "span.rounded-full"
    assert_selector "span.overflow-hidden"
  end

  def test_renders_default_size
    render_inline(Ui::AvatarComponent.new(size: :default))

    assert_selector "span.h-10"
    assert_selector "span.w-10"
  end

  def test_renders_small_size
    render_inline(Ui::AvatarComponent.new(size: :sm))

    assert_selector "span.h-8"
    assert_selector "span.w-8"
  end

  def test_renders_large_size
    render_inline(Ui::AvatarComponent.new(size: :lg))

    assert_selector "span.h-14"
    assert_selector "span.w-14"
  end

  def test_renders_xl_size
    render_inline(Ui::AvatarComponent.new(size: :xl))

    assert_selector "span.h-20"
    assert_selector "span.w-20"
  end

  def test_renders_with_image
    render_inline(Ui::AvatarComponent.new) do |avatar|
      avatar.with_image(src: "https://example.com/avatar.jpg", alt: "User")
    end

    assert_selector "img[src='https://example.com/avatar.jpg']"
    assert_selector "img[alt='User']"
  end

  def test_renders_with_fallback
    render_inline(Ui::AvatarComponent.new) do |avatar|
      avatar.with_fallback { "JD" }
    end

    assert_selector "span.bg-muted", text: "JD"
  end

  def test_accepts_custom_classes
    render_inline(Ui::AvatarComponent.new(class_name: "custom-avatar"))

    assert_selector "span.custom-avatar"
  end
end
