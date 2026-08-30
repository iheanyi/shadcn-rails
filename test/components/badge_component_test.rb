# frozen_string_literal: true

require "test_helper"

class BadgeComponentTest < ViewComponent::TestCase
  def test_renders_default_badge
    render_inline(Shadcn::BadgeComponent.new) { "Badge" }

    assert_selector "span", text: "Badge"
    assert_selector "span.inline-flex.items-center.rounded-md"
    assert_selector "span.bg-primary"
  end

  def test_uses_v4_focus_visible_ring_styles
    render_inline(Shadcn::BadgeComponent.new) { "Badge" }

    classes = page.find("span", text: "Badge")["class"].split
    assert_includes classes, "focus-visible:border-ring"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "focus-visible:ring-ring/50"
    refute_includes classes, "focus:ring-2"
    refute_includes classes, "focus:ring-offset-2"
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
