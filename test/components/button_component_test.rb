# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class ButtonComponentTest < ViewComponent::TestCase
  def test_renders_default_button
    render_inline(Ui::ButtonComponent.new) { "Click me" }

    assert_selector "button", text: "Click me"
    assert_selector "button.bg-primary"
    assert_selector "button.text-primary-foreground"
    assert_selector "button.h-9"
    assert_selector "button[type='button']"
  end

  def test_renders_destructive_variant
    render_inline(Ui::ButtonComponent.new(variant: :destructive)) { "Delete" }

    assert_selector "button.bg-destructive"
    assert_selector "button.text-destructive-foreground"
  end

  def test_renders_outline_variant
    render_inline(Ui::ButtonComponent.new(variant: :outline)) { "Outline" }

    assert_selector "button.border"
    assert_selector "button.border-input"
    assert_selector "button.bg-background"
  end

  def test_renders_secondary_variant
    render_inline(Ui::ButtonComponent.new(variant: :secondary)) { "Secondary" }

    assert_selector "button.bg-secondary"
    assert_selector "button.text-secondary-foreground"
  end

  def test_renders_ghost_variant
    render_inline(Ui::ButtonComponent.new(variant: :ghost)) { "Ghost" }

    assert_no_selector "button.bg-primary"
    assert_no_selector "button.border"
  end

  def test_renders_link_variant
    render_inline(Ui::ButtonComponent.new(variant: :link)) { "Link" }

    assert_selector "button.text-primary"
    assert_selector "button.underline-offset-4"
  end

  def test_renders_small_size
    render_inline(Ui::ButtonComponent.new(size: :sm)) { "Small" }

    assert_selector "button.h-8"
  end

  def test_renders_large_size
    render_inline(Ui::ButtonComponent.new(size: :lg)) { "Large" }

    assert_selector "button.h-10"
  end

  def test_renders_icon_size
    render_inline(Ui::ButtonComponent.new(size: :icon)) { "🔍" }

    assert_selector "button.h-9"
    assert_selector "button.w-9"
  end

  def test_renders_disabled_button
    render_inline(Ui::ButtonComponent.new(disabled: true)) { "Disabled" }

    assert_selector "button[disabled]"
  end

  def test_renders_submit_type
    render_inline(Ui::ButtonComponent.new(type: "submit")) { "Submit" }

    assert_selector "button[type='submit']"
  end

  def test_accepts_custom_classes
    render_inline(Ui::ButtonComponent.new(class_name: "custom-class")) { "Custom" }

    assert_selector "button.custom-class"
  end

  def test_accepts_html_options
    render_inline(Ui::ButtonComponent.new(id: "my-button", data: { action: "click" })) { "Click" }

    assert_selector "button#my-button"
    assert_selector "button[data-action='click']"
  end
end
