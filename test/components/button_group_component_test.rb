# frozen_string_literal: true

require "test_helper"

class ButtonGroupComponentTest < ViewComponent::TestCase
  def test_renders_button_group
    render_inline(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button(variant: :outline) { "Left" }
      group.with_button(variant: :outline) { "Right" }
    end

    assert_selector "div[role='group']"
    assert_selector "button", count: 2
  end

  def test_renders_horizontal_orientation_by_default
    render_inline(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button { "One" }
      group.with_button { "Two" }
    end

    assert_selector "div.flex-row"
  end

  def test_renders_vertical_orientation
    render_inline(Shadcn::ButtonGroupComponent.new(orientation: :vertical)) do |group|
      group.with_button { "Top" }
      group.with_button { "Bottom" }
    end

    assert_selector "div.flex-col"
  end

  def test_renders_buttons_with_collapsed_borders
    render_inline(Shadcn::ButtonGroupComponent.new) do |group|
      group.with_button(variant: :outline) { "Left" }
      group.with_button(variant: :outline) { "Right" }
    end

    # Buttons should have rounded-none class for collapsed borders
    assert_selector "button.rounded-none", count: 2
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
end
