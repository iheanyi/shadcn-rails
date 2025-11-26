# frozen_string_literal: true

require "test_helper"

class AlertComponentTest < ViewComponent::TestCase
  def test_renders_default_alert
    render_inline(Shadcn::AlertComponent.new) do |alert|
      alert.with_title { "Title" }
      alert.with_description { "Description" }
    end

    assert_selector "div[role='alert']"
    assert_selector "h5", text: "Title"
    assert_selector "div", text: "Description"
  end

  def test_renders_destructive_variant
    render_inline(Shadcn::AlertComponent.new(variant: :destructive)) do |alert|
      alert.with_title { "Error" }
      alert.with_description { "Something went wrong" }
    end

    assert_selector "div.border-destructive\\/50"
    assert_selector "div.text-destructive"
  end

  def test_renders_with_icon
    render_inline(Shadcn::AlertComponent.new) do |alert|
      alert.with_icon { "<svg></svg>".html_safe }
      alert.with_title { "With Icon" }
    end

    assert_selector "svg"
    assert_selector "h5", text: "With Icon"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::AlertComponent.new(class_name: "my-alert")) do |alert|
      alert.with_title { "Custom" }
    end

    assert_selector "div.my-alert"
  end

  def test_has_role_alert
    render_inline(Shadcn::AlertComponent.new) do |alert|
      alert.with_title { "Accessible" }
    end

    assert_selector "[role='alert']"
  end
end
