# frozen_string_literal: true

require "test_helper"

class RadioGroupComponentTest < ViewComponent::TestCase
  # Basic rendering tests
  def test_renders_radio_group_container
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan"))

    assert_selector "div[role='radiogroup'][data-slot='radio-group']"
  end

  def test_renders_v4_native_radio_item_classes
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan")) do |group|
      group.with_item(value: "free", id: "plan-free")
    end

    item = page.find("input[type='radio'][data-slot='radio-group-item']")
    classes = item["class"].split

    assert_includes classes, "size-4"
    assert_includes classes, "border-input"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "shadow-xs"

    refute_includes classes, "h-4"
    refute_includes classes, "w-4"
    refute_includes classes, "border-primary"
  end

  def test_renders_with_items_using_slot_dsl
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan")) do |group|
      group.with_item(value: "free", id: "plan-free")
      group.with_item(value: "pro", id: "plan-pro")
    end

    assert_selector "input[type='radio']", count: 2
    assert_selector "input#plan-free"
    assert_selector "input#plan-pro"
  end

  def test_renders_with_selected_value
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan", value: "pro")) do |group|
      group.with_item(value: "free", id: "plan-free")
      group.with_item(value: "pro", id: "plan-pro")
    end

    assert_selector "input[value='free']:not([checked])"
    assert_selector "input[value='pro'][checked]"
  end

  def test_renders_with_required_attribute
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan", required: true))

    assert_selector "div[aria-required='true']"
  end

  def test_renders_with_horizontal_orientation
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan", orientation: :horizontal))

    assert_selector "div.flex.flex-row"
  end

  def test_renders_item_with_disabled_state
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan")) do |group|
      group.with_item(value: "disabled", id: "disabled-option", disabled: true)
    end

    assert_selector "input[disabled]"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan", class_name: "my-radio-group"))

    assert_selector "div.my-radio-group"
  end

  # Tier 1: Data-driven API tests
  def test_renders_items_from_data_array
    render_inline(Shadcn::RadioGroupComponent.new(
      name: "plan",
      items: [
        { value: "free", label: "Free" },
        { value: "pro", label: "Pro" },
        { value: "enterprise", label: "Enterprise" }
      ]
    ))

    assert_selector "input[type='radio']", count: 3
    assert_selector "label", text: "Free"
    assert_selector "label", text: "Pro"
    assert_selector "label", text: "Enterprise"
  end

  def test_data_driven_with_selected_value
    render_inline(Shadcn::RadioGroupComponent.new(
      name: "plan",
      value: "pro",
      items: [
        { value: "free", label: "Free" },
        { value: "pro", label: "Pro" }
      ]
    ))

    assert_selector "input[value='free']:not([checked])"
    assert_selector "input[value='pro'][checked]"
  end

  def test_data_driven_with_disabled_item
    render_inline(Shadcn::RadioGroupComponent.new(
      name: "plan",
      items: [
        { value: "free", label: "Free" },
        { value: "enterprise", label: "Enterprise", disabled: true }
      ]
    ))

    assert_selector "input[value='free']:not([disabled])"
    assert_selector "input[value='enterprise'][disabled]"
  end

  def test_data_driven_generates_ids
    render_inline(Shadcn::RadioGroupComponent.new(
      name: "plan",
      items: [
        { value: "free", label: "Free" }
      ]
    ))

    assert_selector "input#plan-free"
  end

  # Tier 2: Simple DSL with label parameter
  def test_renders_with_label_parameter
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan")) do |group|
      group.with_item(value: "free", label: "Free Plan")
      group.with_item(value: "pro", label: "Pro Plan")
    end

    assert_selector "label", text: "Free Plan"
    assert_selector "label", text: "Pro Plan"
  end

  def test_auto_generates_item_ids
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan")) do |group|
      group.with_item(value: "free", label: "Free")
    end

    # Should auto-generate ID as plan-free
    assert_selector "input#plan-free"
  end

  # Tier 3: Block content (backward compatible)
  def test_renders_with_block_content
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan")) do |group|
      group.with_item(value: "free") { "Free Plan" }
      group.with_item(value: "pro") { "Pro Plan" }
    end

    assert_selector "label", text: "Free Plan"
    assert_selector "label", text: "Pro Plan"
  end

  # Group-level disabled
  def test_group_disabled_disables_all_items
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan", disabled: true)) do |group|
      group.with_item(value: "free", label: "Free")
      group.with_item(value: "pro", label: "Pro")
    end

    assert_selector "div[aria-disabled='true']"
    assert_selector "input[disabled]", count: 2
  end

  def test_group_disabled_with_data_driven_items
    render_inline(Shadcn::RadioGroupComponent.new(
      name: "plan",
      disabled: true,
      items: [
        { value: "free", label: "Free" },
        { value: "pro", label: "Pro" }
      ]
    ))

    assert_selector "input[disabled]", count: 2
  end

  # Accessibility tests
  def test_renders_with_aria_required
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan", required: true))

    assert_selector "div[role='radiogroup'][aria-required='true']"
  end

  def test_radio_inputs_have_name_attribute
    render_inline(Shadcn::RadioGroupComponent.new(name: "subscription")) do |group|
      group.with_item(value: "monthly", label: "Monthly")
    end

    assert_selector "input[name='subscription']"
  end

  # Combined slot and data-driven
  def test_can_combine_data_items_and_slot_items
    render_inline(Shadcn::RadioGroupComponent.new(
      name: "plan",
      items: [{ value: "free", label: "Free" }]
    )) do |group|
      group.with_item(value: "custom", label: "Custom Plan")
    end

    assert_selector "input[type='radio']", count: 2
    assert_selector "label", text: "Free"
    assert_selector "label", text: "Custom Plan"
  end

  # Orientation tests
  def test_vertical_orientation_classes
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan", orientation: :vertical))

    assert_selector "div.grid.gap-3"
  end

  def test_horizontal_orientation_classes
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan", orientation: :horizontal))

    assert_selector "div.flex.flex-row.gap-4"
  end
end
