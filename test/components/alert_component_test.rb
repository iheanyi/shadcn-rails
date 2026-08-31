# frozen_string_literal: true

require "test_helper"

class AlertComponentTest < ViewComponent::TestCase
  def test_renders_default_alert
    render_inline(Shadcn::AlertComponent.new) do |alert|
      alert.with_title { "Title" }
      alert.with_description { "Description" }
    end

    assert_selector "div[data-slot='alert'][role='alert']"
    assert_selector "div[data-slot='alert-title']", text: "Title"
    assert_selector "div[data-slot='alert-description']", text: "Description"
    assert_no_selector "h5", text: "Title"
  end

  def test_renders_destructive_variant
    render_inline(Shadcn::AlertComponent.new(variant: :destructive)) do |alert|
      alert.with_title { "Error" }
      alert.with_description { "Something went wrong" }
    end

    classes = page.find("div[data-slot='alert'][role='alert']")["class"].split
    assert_includes classes, "bg-card"
    assert_includes classes, "text-destructive"
    assert_includes classes, "*:data-[slot=alert-description]:text-destructive/90"
    assert_includes classes, "[&>svg]:text-current"
  end

  def test_renders_with_icon
    render_inline(Shadcn::AlertComponent.new) do |alert|
      alert.with_icon { "<svg></svg>".html_safe }
      alert.with_title { "With Icon" }
    end

    assert_selector "svg"
    assert_selector "div[data-slot='alert-title']", text: "With Icon"
  end

  def test_renders_unslotted_content_in_body_column
    render_inline(Shadcn::AlertComponent.new) do
      "Unslotted body text"
    end

    assert_selector "div[data-slot='alert'][role='alert'] > div[data-slot='alert-description'].col-start-2", text: "Unslotted body text"
    assert_no_selector "div[data-slot='alert'][role='alert'] > div.col-start-2:not([data-slot])", text: "Unslotted body text"

    classes = page.find("div[data-slot='alert-description']", text: "Unslotted body text")["class"].split
    assert_includes classes, "grid"
    assert_includes classes, "justify-items-start"
    assert_includes classes, "gap-1"
    assert_includes classes, "text-muted-foreground"
  end

  def test_does_not_render_unslotted_content_when_description_slot_is_present
    render_inline(Shadcn::AlertComponent.new) do |alert|
      alert.with_description { "Description slot" }
      "Unslotted body text"
    end

    assert_selector "div[data-slot='alert-description']", text: "Description slot", count: 1
    assert_no_text "Unslotted body text"
  end

  def test_default_variant_uses_new_york_v4_classes
    render_inline(Shadcn::AlertComponent.new) do |alert|
      alert.with_title { "Title" }
      alert.with_description { "Description" }
    end

    classes = page.find("div[data-slot='alert'][role='alert']")["class"].split

    assert_includes classes, "grid"
    assert_includes classes, "grid-cols-[0_1fr]"
    assert_includes classes, "items-start"
    assert_includes classes, "gap-y-0.5"
    assert_includes classes, "bg-card"
    assert_includes classes, "text-card-foreground"
    assert_includes classes, "has-[>svg]:grid-cols-[calc(var(--spacing)*4)_1fr]"
    assert_includes classes, "has-[>svg]:gap-x-3"
    assert_includes classes, "[&>svg]:size-4"
    assert_includes classes, "[&>svg]:translate-y-0.5"
    assert_includes classes, "[&>svg]:text-current"

    refute_includes classes, "bg-background"
    refute_includes classes, "[&>svg]:absolute"
    refute_includes classes, "[&>svg]:left-4"
    refute_includes classes, "[&>svg]:top-4"
  end

  def test_title_and_description_use_new_york_v4_classes
    render_inline(Shadcn::AlertComponent.new) do |alert|
      alert.with_title { "Title" }
      alert.with_description { "Description" }
    end

    title_classes = page.find("div[data-slot='alert-title']")["class"].split
    assert_includes title_classes, "col-start-2"
    assert_includes title_classes, "line-clamp-1"
    assert_includes title_classes, "min-h-4"
    assert_includes title_classes, "font-medium"
    assert_includes title_classes, "tracking-tight"
    refute_includes title_classes, "mb-1"
    refute_includes title_classes, "leading-none"

    description_classes = page.find("div[data-slot='alert-description']")["class"].split
    assert_includes description_classes, "col-start-2"
    assert_includes description_classes, "grid"
    assert_includes description_classes, "justify-items-start"
    assert_includes description_classes, "gap-1"
    assert_includes description_classes, "text-sm"
    assert_includes description_classes, "text-muted-foreground"
    assert_includes description_classes, "[&_p]:leading-relaxed"
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
