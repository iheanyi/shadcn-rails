# frozen_string_literal: true

require "test_helper"

class ButtonGroupComponentTest < ViewComponent::TestCase
  def test_renders_button_group
    render_inline(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button(variant: :outline) { "Left" }
      group.with_button(variant: :outline) { "Right" }
    end

    assert_selector "div[role='group'][data-slot='button-group']"
    assert_selector "button", count: 2
  end

  def test_renders_horizontal_orientation_by_default
    render_inline(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button { "One" }
      group.with_button { "Two" }
    end

    classes = button_group_classes

    assert_includes classes, "flex"
    assert_includes classes, "w-fit"
    assert_includes classes, "items-stretch"
    assert_includes classes, "has-[>[data-slot=button-group]]:gap-2"
    assert_includes classes, "[&>*]:focus-visible:relative"
    assert_includes classes, "[&>*]:focus-visible:z-10"
    assert_includes classes, "has-[select[aria-hidden=true]:last-child]:[&>[data-slot=select-trigger]:last-of-type]:rounded-r-md"
    assert_includes classes, "[&>[data-slot=select-trigger]:not([class*='w-'])]:w-fit"
    assert_includes classes, "[&>input]:flex-1"
    assert_includes classes, "[&>*:not(:first-child)]:rounded-l-none"
    assert_includes classes, "[&>*:not(:first-child)]:border-l-0"
    assert_includes classes, "[&>*:not(:last-child)]:rounded-r-none"
    refute_includes classes, "inline-flex"
    refute_includes classes, "flex-row"
  end

  def test_renders_vertical_orientation
    render_inline(Shadcn::ButtonGroupComponent.new(orientation: :vertical)) do |group|
      group.with_button { "Top" }
      group.with_button { "Bottom" }
    end

    classes = button_group_classes

    assert_includes classes, "flex-col"
    assert_includes classes, "[&>*:not(:first-child)]:rounded-t-none"
    assert_includes classes, "[&>*:not(:first-child)]:border-t-0"
    assert_includes classes, "[&>*:not(:last-child)]:rounded-b-none"
    refute_includes classes, "first:[&>*]:rounded-t-md"
    refute_includes classes, "last:[&>*]:rounded-b-md"
    refute_includes classes, "[&>*]:rounded-none"
    refute_includes classes, "[&>*]:-mt-px"
  end

  def test_renders_buttons_without_legacy_collapsed_border_classes
    render_inline(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button(variant: :outline) { "Left" }
      group.with_button(variant: :outline) { "Right" }
    end

    button_classes.each do |classes|
      refute_includes classes, "rounded-none"
      refute_includes classes, "first:rounded-l-md"
      refute_includes classes, "last:rounded-r-md"
      refute_includes classes, "-ml-px"
      refute_includes classes, "first:ml-0"
    end
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::ButtonGroupComponent.new(class_name: "my-custom-class")) do |group|
      group.with_button { "Test" }
    end

    assert_selector "div.my-custom-class"
  end

  def test_renders_buttons_with_different_variants
    render_inline(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button(variant: :default) { "Primary" }
      group.with_button(variant: :outline) { "Outline" }
      group.with_button(variant: :secondary) { "Secondary" }
    end

    assert_selector "button", count: 3
    assert_selector "button.bg-primary"
    assert_selector "button.border"
    assert_selector "button.bg-secondary"
  end

  def test_renders_text_slot_with_upstream_classes
    render_inline(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_text { "Selected" }
    end

    classes = page.find("div.bg-muted", text: "Selected")[:class].split

    assert_includes classes, "flex"
    assert_includes classes, "items-center"
    assert_includes classes, "gap-2"
    assert_includes classes, "rounded-md"
    assert_includes classes, "border"
    assert_includes classes, "bg-muted"
    assert_includes classes, "px-4"
    assert_includes classes, "text-sm"
    assert_includes classes, "font-medium"
    assert_includes classes, "shadow-xs"
    assert_includes classes, "[&_svg]:pointer-events-none"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"
  end

  def test_renders_separator_slot_with_upstream_button_group_classes
    render_inline(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button { "Left" }
      group.with_separator
      group.with_button { "Right" }
    end

    separator = page.find("[data-slot='button-group-separator']")
    classes = separator[:class].split

    assert_equal "vertical", separator["data-orientation"]
    assert_includes classes, "relative"
    assert_includes classes, "m-0!"
    assert_includes classes, "self-stretch"
    assert_includes classes, "bg-input"
    assert_includes classes, "data-[orientation=vertical]:h-auto"
  end

  private

  def button_group_classes
    page.find("div[role='group']")[:class].split
  end

  def button_classes
    page.all("button").map { |button| button[:class].split }
  end
end
