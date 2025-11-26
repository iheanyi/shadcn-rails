# frozen_string_literal: true

require "test_helper"

class RadioGroupComponentTest < ViewComponent::TestCase
  def test_renders_radio_group_container
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan"))

    assert_selector "div[role='radiogroup']"
    assert_selector "div[data-controller='shadcn--radio-group']"
  end

  def test_renders_with_items
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan")) do |group|
      group.with_item(value: "free", id: "plan-free")
      group.with_item(value: "pro", id: "plan-pro")
    end

    assert_selector "button[role='radio']", count: 2
    assert_selector "button#plan-free"
    assert_selector "button#plan-pro"
  end

  def test_renders_with_selected_value
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan", value: "pro")) do |group|
      group.with_item(value: "free", id: "plan-free")
      group.with_item(value: "pro", id: "plan-pro")
    end

    assert_selector "button[data-value='free'][aria-checked='false']"
    assert_selector "button[data-value='pro'][aria-checked='true']"
    assert_selector "button[data-value='pro'][data-state='checked']"
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

    assert_selector "button[disabled]"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan", class_name: "my-radio-group"))

    assert_selector "div.my-radio-group"
  end

  def test_renders_stimulus_targets
    render_inline(Shadcn::RadioGroupComponent.new(name: "plan")) do |group|
      group.with_item(value: "test", id: "test-radio")
    end

    assert_selector "button[data-shadcn--radio-group-target='item']"
    assert_selector "span[data-shadcn--radio-group-target='indicator']"
  end
end
