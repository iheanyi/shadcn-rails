# frozen_string_literal: true

require "test_helper"

class NativeSelectComponentTest < ViewComponent::TestCase
  def test_renders_select_element
    render_inline(Shadcn::NativeSelectComponent.new(name: "country")) do |select|
      select.with_option(value: "us") { "United States" }
    end

    assert_selector "select[name='country']"
    assert_selector "option[value='us']", text: "United States"
  end

  def test_renders_with_wrapper_and_chevron
    render_inline(Shadcn::NativeSelectComponent.new(name: "test")) do |select|
      select.with_option(value: "1") { "One" }
    end

    assert_selector "div.relative"
    assert_selector "svg" # chevron icon
  end

  def test_renders_multiple_options
    render_inline(Shadcn::NativeSelectComponent.new(name: "size")) do |select|
      select.with_option(value: "s") { "Small" }
      select.with_option(value: "m") { "Medium" }
      select.with_option(value: "l") { "Large" }
    end

    assert_selector "option", count: 3
    assert_selector "option[value='s']", text: "Small"
    assert_selector "option[value='m']", text: "Medium"
    assert_selector "option[value='l']", text: "Large"
  end

  def test_renders_disabled_option
    render_inline(Shadcn::NativeSelectComponent.new(name: "test")) do |select|
      select.with_option(value: "", disabled: true) { "Select one" }
      select.with_option(value: "1") { "One" }
    end

    assert_selector "option[disabled]", text: "Select one"
  end

  def test_renders_selected_option
    render_inline(Shadcn::NativeSelectComponent.new(name: "test")) do |select|
      select.with_option(value: "1") { "One" }
      select.with_option(value: "2", selected: true) { "Two" }
    end

    assert_selector "option[selected]", text: "Two"
  end

  def test_renders_optgroups
    render_inline(Shadcn::NativeSelectComponent.new(name: "car")) do |select|
      select.with_optgroup(label: "Swedish Cars") do |group|
        group.with_option(value: "volvo") { "Volvo" }
        group.with_option(value: "saab") { "Saab" }
      end
      select.with_optgroup(label: "German Cars") do |group|
        group.with_option(value: "mercedes") { "Mercedes" }
      end
    end

    assert_selector "optgroup[label='Swedish Cars']"
    assert_selector "optgroup[label='German Cars']"
    assert_selector "optgroup option", count: 3
  end

  def test_renders_disabled_select
    render_inline(Shadcn::NativeSelectComponent.new(name: "test", disabled: true)) do |select|
      select.with_option(value: "1") { "One" }
    end

    assert_selector "select[disabled]"
  end

  def test_renders_required_select
    render_inline(Shadcn::NativeSelectComponent.new(name: "test", required: true)) do |select|
      select.with_option(value: "1") { "One" }
    end

    assert_selector "select[required]"
  end

  def test_renders_with_id
    render_inline(Shadcn::NativeSelectComponent.new(name: "test", id: "my-select")) do |select|
      select.with_option(value: "1") { "One" }
    end

    assert_selector "select[id='my-select']"
  end

  def test_renders_with_styled_appearance
    render_inline(Shadcn::NativeSelectComponent.new(name: "test")) do |select|
      select.with_option(value: "1") { "One" }
    end

    assert_selector "select.appearance-none"
    assert_selector "select.rounded-md"
    assert_selector "select.border"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::NativeSelectComponent.new(name: "test", class_name: "my-select")) do |select|
      select.with_option(value: "1") { "One" }
    end

    assert_selector "div.my-select"
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::NativeSelectComponent.new(name: "test", class: "alias-class")) do |select|
      select.with_option(value: "1") { "One" }
    end

    assert_selector "div.alias-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::NativeSelectComponent.new(name: "test", data: { testid: "native-select" })) do |select|
      select.with_option(value: "1") { "One" }
    end

    assert_selector "[data-testid='native-select']"
  end
end
