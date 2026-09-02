# frozen_string_literal: true

require "test_helper"

class ButtonComponentTest < ViewComponent::TestCase
  def test_renders_default_button
    render_inline(Shadcn::ButtonComponent.new) { "Click me" }

    assert_selector "button", text: "Click me"
    assert_selector "button[type='button']"
    assert_selector "button.bg-primary"
    assert_selector "button[data-slot='button'][data-variant='default'][data-size='default']"

    classes = page.find("button", text: "Click me")["class"].split
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "has-[>svg]:px-3"
    refute_includes classes, "focus-visible:ring-1"
    refute_includes classes, "shadow-xs"
  end

  def test_renders_with_variants
    # Default
    render_inline(Shadcn::ButtonComponent.new(variant: :default)) { "Default" }
    assert_selector "button.bg-primary"

    # Destructive
    render_inline(Shadcn::ButtonComponent.new(variant: :destructive)) { "Delete" }
    assert_selector "button.bg-destructive"
    destructive_classes = page.find("button", text: "Delete")["class"].split
    assert_includes destructive_classes, "text-white"
    refute_includes destructive_classes, "text-destructive-foreground"

    # Outline
    render_inline(Shadcn::ButtonComponent.new(variant: :outline)) { "Outline" }
    assert_selector "button.border"

    # Secondary
    render_inline(Shadcn::ButtonComponent.new(variant: :secondary)) { "Secondary" }
    assert_selector "button.bg-secondary"

    # Ghost
    render_inline(Shadcn::ButtonComponent.new(variant: :ghost)) { "Ghost" }
    assert_selector "button.hover\\:bg-accent"

    # Link
    render_inline(Shadcn::ButtonComponent.new(variant: :link)) { "Link" }
    assert_selector "button.underline-offset-4"
  end

  def test_renders_with_sizes
    # Small
    render_inline(Shadcn::ButtonComponent.new(size: :sm)) { "Small" }
    assert_selector "button.h-8"

    # Default
    render_inline(Shadcn::ButtonComponent.new(size: :default)) { "Default" }
    assert_selector "button.h-9"

    # Large
    render_inline(Shadcn::ButtonComponent.new(size: :lg)) { "Large" }
    assert_selector "button.h-10"
    large_classes = page.find("button", text: "Large")["class"].split
    assert_includes large_classes, "px-6"
    refute_includes large_classes, "px-8"

    # Icon
    render_inline(Shadcn::ButtonComponent.new(size: :icon)) { "+" }
    assert_selector "button.size-9"
  end

  def test_renders_as_link
    render_inline(Shadcn::ButtonComponent.new(href: "/path")) { "Go" }

    assert_selector "a[href='/path']", text: "Go"
    assert_selector "a[role='button']"
    assert_selector "a[data-slot='button'][data-variant='default'][data-size='default']"
  end

  def test_renders_disabled_state
    render_inline(Shadcn::ButtonComponent.new(disabled: true)) { "Disabled" }

    assert_selector "button[disabled]"
    assert_selector "button[aria-disabled='true']"
  end

  def test_renders_loading_state
    render_inline(Shadcn::ButtonComponent.new(loading: true)) { "Loading" }

    assert_selector "button[disabled]"
    assert_selector "button[aria-busy='true']"
    assert_selector "span.animate-spin"
  end

  def test_renders_with_type
    render_inline(Shadcn::ButtonComponent.new(type: "submit")) { "Submit" }

    assert_selector "button[type='submit']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::ButtonComponent.new(class_name: "my-custom-class")) { "Custom" }

    assert_selector "button.my-custom-class"
  end

  def test_class_option_overrides_default_padding
    render_inline(Shadcn::Button.new(class: "p-0")) { "Flush" }

    classes = page.find("button", text: "Flush")["class"].split
    assert_includes classes, "p-0"
    refute_includes classes, "px-4"
    refute_includes classes, "py-2"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::ButtonComponent.new(data: { action: "click->test#action" })) { "Data" }

    assert_selector "button[data-action='click->test#action']"
  end
end
