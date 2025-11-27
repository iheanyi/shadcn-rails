# frozen_string_literal: true

require "test_helper"

class InputGroupComponentTest < ViewComponent::TestCase
  def test_renders_input_group_container
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_input(placeholder: "Search")
    end

    assert_selector "div.flex.items-center"
    assert_selector "div.rounded-md"
    assert_selector "div.border"
  end

  def test_renders_with_prefix
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix { "$" }
      group.with_input(placeholder: "Amount")
    end

    assert_selector "span", text: "$"
    assert_selector "input[placeholder='Amount']"
  end

  def test_renders_with_suffix
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_input(type: :email)
      group.with_suffix { "@example.com" }
    end

    assert_selector "span", text: "@example.com"
    assert_selector "input[type='email']"
  end

  def test_renders_with_both_prefix_and_suffix
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix { "$" }
      group.with_input(type: :number, placeholder: "0.00")
      group.with_suffix { "USD" }
    end

    assert_selector "span", text: "$"
    assert_selector "span", text: "USD"
    assert_selector "input[type='number']"
  end

  def test_input_has_no_border
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_input
    end

    assert_selector "input.border-0"
    assert_selector "input.shadow-none"
  end

  def test_renders_addon_with_muted_text
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix { "https://" }
      group.with_input
    end

    assert_selector "span.text-muted-foreground"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::InputGroupComponent.new(class_name: "my-input-group")) do |group|
      group.with_input
    end

    assert_selector "div.my-input-group"
  end
end
