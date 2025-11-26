# frozen_string_literal: true

require "test_helper"

class ButtonComponentTest < ViewComponent::TestCase
  def test_renders_default_button
    render_inline(Shadcn::ButtonComponent.new) { "Click me" }

    assert_selector "button", text: "Click me"
    assert_selector "button[type='button']"
    assert_selector "button.bg-primary"
  end

  def test_renders_with_variants
    # Default
    render_inline(Shadcn::ButtonComponent.new(variant: :default)) { "Default" }
    assert_selector "button.bg-primary"

    # Destructive
    render_inline(Shadcn::ButtonComponent.new(variant: :destructive)) { "Delete" }
    assert_selector "button.bg-destructive"

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

    # Icon
    render_inline(Shadcn::ButtonComponent.new(size: :icon)) { "+" }
    assert_selector "button.w-9"
  end

  def test_renders_as_link
    render_inline(Shadcn::ButtonComponent.new(href: "/path")) { "Go" }

    assert_selector "a[href='/path']", text: "Go"
    assert_selector "a[role='button']"
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

  def test_renders_with_data_attributes
    render_inline(Shadcn::ButtonComponent.new(data: { action: "click->test#action" })) { "Data" }

    assert_selector "button[data-action='click->test#action']"
  end
end
