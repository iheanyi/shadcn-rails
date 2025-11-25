# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class AlertComponentTest < ViewComponent::TestCase
  def test_renders_default_alert
    render_inline(Ui::AlertComponent.new) { "Alert content" }

    assert_selector "div[role='alert']"
    assert_selector "div.rounded-lg"
    assert_selector "div.border"
    assert_text "Alert content"
  end

  def test_renders_destructive_variant
    render_inline(Ui::AlertComponent.new(variant: :destructive)) { "Error" }

    assert_selector "div.text-destructive"
    assert_selector "div.border-destructive\\/50"
  end

  def test_renders_with_title
    render_inline(Ui::AlertComponent.new) do |alert|
      alert.with_title { "Alert Title" }
    end

    assert_selector "h5", text: "Alert Title"
    assert_selector "h5.font-medium"
  end

  def test_renders_with_description
    render_inline(Ui::AlertComponent.new) do |alert|
      alert.with_description { "Alert description" }
    end

    assert_selector "div.text-sm", text: "Alert description"
  end

  def test_renders_complete_alert
    render_inline(Ui::AlertComponent.new) do |alert|
      alert.with_title { "Title" }
      alert.with_description { "Description" }
    end

    assert_text "Title"
    assert_text "Description"
  end

  def test_accepts_custom_classes
    render_inline(Ui::AlertComponent.new(class_name: "custom-alert")) { "Alert" }

    assert_selector "div.custom-alert"
  end

  def test_has_accessibility_role
    render_inline(Ui::AlertComponent.new) { "Alert" }

    assert_selector "div[role='alert']"
  end
end
