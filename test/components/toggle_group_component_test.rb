# frozen_string_literal: true

require "test_helper"

class ToggleGroupComponentTest < ViewComponent::TestCase
  def test_renders_toggle_group_container
    render_inline(Shadcn::ToggleGroupComponent.new)

    assert_selector "div[role='group']"
    assert_selector "div[data-controller='shadcn--toggle-group']"
  end

  def test_renders_new_york_v4_group_wrapper_classes
    render_inline(Shadcn::ToggleGroupComponent.new)

    group = page.find("div[role='group']")
    classes = group[:class]

    assert_includes classes, "group/toggle-group"
    assert_includes classes, "flex"
    assert_includes classes, "w-fit"
    assert_includes classes, "items-center"
    assert_includes classes, "gap-[--spacing(var(--gap))]"
    assert_includes classes, "rounded-md"
    assert_includes classes, "data-[spacing=default]:data-[variant=outline]:shadow-xs"
    refute_includes classes, "inline-flex"
    refute_includes classes, "justify-center"
    refute_includes classes, "gap-1"
    refute_includes classes, "rounded-lg"
  end

  def test_renders_new_york_v4_group_data_attributes
    render_inline(Shadcn::ToggleGroupComponent.new(variant: :outline, size: :sm, spacing: 2))

    assert_selector "div[data-slot='toggle-group']"
    assert_selector "div[data-variant='outline']"
    assert_selector "div[data-size='sm']"
    assert_selector "div[data-spacing='2']"
    assert_selector "div[style='--gap: 2;']"
  end

  def test_renders_with_items
    render_inline(Shadcn::ToggleGroupComponent.new) do |group|
      group.with_item(value: "left") { "L" }
      group.with_item(value: "center") { "C" }
      group.with_item(value: "right") { "R" }
    end

    assert_selector "button", count: 3
    assert_selector "button[data-value='left']", text: "L"
    assert_selector "button[data-value='center']", text: "C"
    assert_selector "button[data-value='right']", text: "R"
  end

  def test_renders_with_single_type
    render_inline(Shadcn::ToggleGroupComponent.new(type: :single))

    assert_selector "[data-shadcn--toggle-group-type-value='single']"
  end

  def test_renders_with_multiple_type
    render_inline(Shadcn::ToggleGroupComponent.new(type: :multiple))

    assert_selector "[data-shadcn--toggle-group-type-value='multiple']"
  end

  def test_renders_with_selected_value
    render_inline(Shadcn::ToggleGroupComponent.new(value: "center")) do |group|
      group.with_item(value: "left") { "L" }
      group.with_item(value: "center") { "C" }
    end

    assert_selector "[data-shadcn--toggle-group-value-value='center']"
  end

  def test_renders_item_with_pressed_state
    render_inline(Shadcn::ToggleGroupComponent.new) do |group|
      group.with_item(value: "test", pressed: true) { "Pressed" }
    end

    assert_selector "button[aria-pressed='true']"
    assert_selector "button[data-state='on']"
  end

  def test_renders_item_with_outline_variant
    render_inline(Shadcn::ToggleGroupComponent.new(variant: :outline)) do |group|
      group.with_item(value: "test") { "Test" }
    end

    assert_selector "button.border"
  end

  def test_item_classes_match_toggle_new_york_v4
    render_inline(Shadcn::ToggleGroupComponent.new) do |group|
      group.with_item(value: "test") { "Test" }
    end

    assert_selector "button[data-slot='toggle-group-item']"
    assert_includes rendered_content, "gap-2"
    assert_includes rendered_content, "focus-visible:ring-[3px]"
    assert_includes rendered_content, "min-w-9"
    assert_includes rendered_content, "px-2"
    refute_includes rendered_content, "focus-visible:ring-1"
    refute_includes rendered_content, "px-3"
  end

  def test_item_outline_variant_uses_toggle_new_york_v4_shadow
    render_inline(Shadcn::ToggleGroupComponent.new(variant: :outline)) do |group|
      group.with_item(value: "test") { "Test" }
    end

    assert_includes rendered_content, "shadow-xs"
    refute_includes rendered_content, "shadow-sm"
  end

  def test_renders_with_small_size
    render_inline(Shadcn::ToggleGroupComponent.new(size: :sm)) do |group|
      group.with_item(value: "test") { "T" }
    end

    assert_selector "button.h-8"
  end

  def test_renders_hidden_input_when_name_provided
    render_inline(Shadcn::ToggleGroupComponent.new(name: "alignment", value: "left"))

    assert_selector "input[type='hidden'][name='alignment'][value='left']", visible: :all
  end

  def test_renders_item_with_aria_label
    render_inline(Shadcn::ToggleGroupComponent.new) do |group|
      group.with_item(value: "bold", aria_label: "Toggle bold") { "B" }
    end

    assert_selector "button[aria-label='Toggle bold']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::ToggleGroupComponent.new(class_name: "my-toggle-group"))

    assert_selector "div.my-toggle-group"
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::ToggleGroupComponent.new(class: "alias-class"))

    assert_selector "div.alias-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::ToggleGroupComponent.new(data: { testid: "toggle-group" }))

    assert_selector "[data-testid='toggle-group']"
  end

  def test_item_appends_host_data_action_without_losing_toggle_action
    render_inline(Shadcn::ToggleGroupComponent.new) do |group|
      group.with_item(value: "left", data: { action: "analytics#track" }) { "Left" }
    end

    assert_selector "button[data-action='click->shadcn--toggle-group#toggle analytics#track']"
  end
end
