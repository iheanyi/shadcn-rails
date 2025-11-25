# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class BadgeComponentTest < ViewComponent::TestCase
  def test_renders_default_badge
    render_inline(Ui::BadgeComponent.new) { "Badge" }

    assert_selector "span", text: "Badge"
    assert_selector "span.bg-primary"
    assert_selector "span.text-primary-foreground"
    assert_selector "span.rounded-full"
  end

  def test_renders_secondary_variant
    render_inline(Ui::BadgeComponent.new(variant: :secondary)) { "Secondary" }

    assert_selector "span.bg-secondary"
    assert_selector "span.text-secondary-foreground"
  end

  def test_renders_destructive_variant
    render_inline(Ui::BadgeComponent.new(variant: :destructive)) { "Destructive" }

    assert_selector "span.bg-destructive"
    assert_selector "span.text-destructive-foreground"
  end

  def test_renders_outline_variant
    render_inline(Ui::BadgeComponent.new(variant: :outline)) { "Outline" }

    assert_selector "span.text-foreground"
    assert_no_selector "span.bg-primary"
  end

  def test_accepts_custom_classes
    render_inline(Ui::BadgeComponent.new(class_name: "custom-badge")) { "Custom" }

    assert_selector "span.custom-badge"
  end

  def test_has_proper_structure
    render_inline(Ui::BadgeComponent.new) { "Test" }

    assert_selector "span.inline-flex"
    assert_selector "span.items-center"
    assert_selector "span.border"
    assert_selector "span.text-xs"
    assert_selector "span.font-semibold"
  end
end
