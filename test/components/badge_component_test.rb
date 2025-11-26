# frozen_string_literal: true

require "test_helper"

class BadgeComponentTest < ViewComponent::TestCase
  def test_renders_default_badge
    render_inline(Shadcn::BadgeComponent.new) { "Badge" }

    assert_selector "span", text: "Badge"
    assert_selector "span.inline-flex.items-center.rounded-md"
    assert_selector "span.bg-primary"
  end

  def test_renders_secondary_variant
    render_inline(Shadcn::BadgeComponent.new(variant: :secondary)) { "Secondary" }

    assert_selector "span.bg-secondary"
  end

  def test_renders_destructive_variant
    render_inline(Shadcn::BadgeComponent.new(variant: :destructive)) { "Error" }

    assert_selector "span.bg-destructive"
  end

  def test_renders_outline_variant
    render_inline(Shadcn::BadgeComponent.new(variant: :outline)) { "Outline" }

    assert_selector "span.text-foreground"
    assert_no_selector "span.bg-primary"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::BadgeComponent.new(class_name: "my-badge")) { "Custom" }

    assert_selector "span.my-badge"
  end
end
