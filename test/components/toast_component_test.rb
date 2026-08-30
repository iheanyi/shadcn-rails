# frozen_string_literal: true

require "test_helper"

class ToastComponentTest < ViewComponent::TestCase
  def test_renders_toast_container
    render_inline(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Notification" }
    end

    assert_selector "li[data-controller='shadcn--toast']"
    assert_selector "li[role='status']"
    assert_selector "li[aria-live='polite']"
  end

  def test_renders_with_title
    render_inline(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Success" }
    end

    assert_text "Success"
  end

  def test_renders_with_description
    render_inline(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Saved" }
      toast.with_description { "Your changes have been saved." }
    end

    assert_text "Saved"
    assert_text "Your changes have been saved."
  end

  def test_renders_default_variant
    render_inline(Shadcn::ToastComponent.new(variant: :default)) do |toast|
      toast.with_title { "Info" }
    end

    assert_selector "li.bg-background"
    assert_selector "li.border"
  end

  def test_renders_destructive_variant
    render_inline(Shadcn::ToastComponent.new(variant: :destructive)) do |toast|
      toast.with_title { "Error" }
    end

    assert_selector "li.destructive"
    assert_selector "li.border-destructive"
    assert_selector "li.bg-destructive"
  end

  def test_renders_with_action
    render_inline(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Update available" }
      toast.with_action(alt_text: "Update now") do
        "<button>Update</button>".html_safe
      end
    end

    assert_text "Update available"
    assert_selector "button", text: "Update"
  end

  def test_renders_close_button
    render_inline(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Notice" }
    end

    assert_selector "button[aria-label='Close']"
    assert_selector "button[data-action='click->shadcn--toast#close']"
  end

  def test_close_button_uses_ghost_hover_and_keyboard_focus_styles
    render_inline(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Notice" }
    end

    classes = page.find("button[aria-label='Close']")["class"].split
    assert_includes classes, "border-0"
    assert_includes classes, "bg-transparent"
    assert_includes classes, "hover:bg-accent"
    assert_includes classes, "hover:text-accent-foreground"
    assert_includes classes, "focus-visible:ring-2"
    assert_includes classes, "focus-visible:opacity-100"
    assert_includes classes, "focus-visible:ring-ring"
    refute_includes classes, "focus:ring-1"
    refute_includes classes, "focus:outline-none"
    refute_includes classes, "ring-offset-2"
    refute_includes classes, "ring-offset-background"
  end

  def test_renders_with_duration_value
    render_inline(Shadcn::ToastComponent.new(duration: 3000)) do |toast|
      toast.with_title { "Quick" }
    end

    assert_selector "li[data-shadcn--toast-duration-value='3000']"
  end

  def test_renders_open_state
    render_inline(Shadcn::ToastComponent.new(open: true)) do |toast|
      toast.with_title { "Open" }
    end

    assert_selector "li[data-state='open']"
    assert_selector "li[data-shadcn--toast-open-value='true']"
  end

  def test_renders_closed_state
    render_inline(Shadcn::ToastComponent.new(open: false)) do |toast|
      toast.with_title { "Closed" }
    end

    assert_selector "li[data-state='closed']"
    assert_selector "li[data-shadcn--toast-open-value='false']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::ToastComponent.new(class_name: "my-toast")) do |toast|
      toast.with_title { "Custom" }
    end

    assert_selector "li.my-toast"
  end

  def test_renders_with_animation_classes
    render_inline(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Animated" }
    end

    assert_selector "li.transition-all"
  end
end
