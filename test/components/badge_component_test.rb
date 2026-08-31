# frozen_string_literal: true

require "test_helper"

class BadgeComponentTest < ViewComponent::TestCase
  def test_renders_default_badge
    render_inline(Shadcn::BadgeComponent.new) { "Badge" }

    assert_selector "span[data-slot='badge'][data-variant='default']", text: "Badge"
    assert_selector "span.inline-flex.items-center.rounded-full"
    assert_selector "span.bg-primary"
  end

  def test_default_badge_uses_new_york_v4_classes
    render_inline(Shadcn::BadgeComponent.new) { "Badge" }

    classes = page.find("span[data-slot='badge']", text: "Badge")["class"].split

    assert_includes classes, "inline-flex"
    assert_includes classes, "w-fit"
    assert_includes classes, "shrink-0"
    assert_includes classes, "justify-center"
    assert_includes classes, "gap-1"
    assert_includes classes, "overflow-hidden"
    assert_includes classes, "rounded-full"
    assert_includes classes, "border-transparent"
    assert_includes classes, "px-2"
    assert_includes classes, "font-medium"
    assert_includes classes, "whitespace-nowrap"
    assert_includes classes, "transition-[color,box-shadow]"
    assert_includes classes, "aria-invalid:border-destructive"
    assert_includes classes, "aria-invalid:ring-destructive/20"
    assert_includes classes, "dark:aria-invalid:ring-destructive/40"
    assert_includes classes, "[&>svg]:pointer-events-none"
    assert_includes classes, "[&>svg]:size-3"
    assert_includes classes, "[a&]:hover:bg-primary/90"
    refute_includes classes, "rounded-md"
    refute_includes classes, "px-2.5"
    refute_includes classes, "font-semibold"
    refute_includes classes, "transition-colors"
    refute_includes classes, "shadow"
    refute_includes classes, "hover:bg-primary/80"
  end

  def test_uses_v4_focus_visible_ring_styles
    render_inline(Shadcn::BadgeComponent.new) { "Badge" }

    classes = page.find("span[data-slot='badge']", text: "Badge")["class"].split
    assert_includes classes, "focus-visible:border-ring"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "focus-visible:ring-ring/50"
    refute_includes classes, "focus:ring-2"
    refute_includes classes, "focus:ring-offset-2"
  end

  def test_renders_secondary_variant
    render_inline(Shadcn::BadgeComponent.new(variant: :secondary)) { "Secondary" }

    assert_selector "span[data-slot='badge'][data-variant='secondary'].bg-secondary"
    classes = page.find("span[data-slot='badge']", text: "Secondary")["class"].split
    assert_includes classes, "[a&]:hover:bg-secondary/90"
    refute_includes classes, "hover:bg-secondary/80"
  end

  def test_renders_destructive_variant
    render_inline(Shadcn::BadgeComponent.new(variant: :destructive)) { "Error" }

    assert_selector "span[data-slot='badge'][data-variant='destructive'].bg-destructive"
    classes = page.find("span[data-slot='badge']", text: "Error")["class"].split
    assert_includes classes, "text-white"
    assert_includes classes, "dark:bg-destructive/60"
    assert_includes classes, "dark:focus-visible:ring-destructive/40"
    assert_includes classes, "[a&]:hover:bg-destructive/90"
    refute_includes classes, "text-destructive-foreground"
    refute_includes classes, "shadow"
    refute_includes classes, "hover:bg-destructive/80"
  end

  def test_renders_outline_variant
    render_inline(Shadcn::BadgeComponent.new(variant: :outline)) { "Outline" }

    assert_selector "span[data-slot='badge'][data-variant='outline'].text-foreground"
    classes = page.find("span[data-slot='badge']", text: "Outline")["class"].split
    assert_includes classes, "border-border"
    assert_includes classes, "[a&]:hover:bg-accent"
    assert_includes classes, "[a&]:hover:text-accent-foreground"
    assert_no_selector "span.bg-primary"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::BadgeComponent.new(class_name: "my-badge")) { "Custom" }

    assert_selector "span.my-badge"
  end
end
