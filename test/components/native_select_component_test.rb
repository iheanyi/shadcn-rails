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

    assert_selector "div[data-slot='native-select-wrapper'].relative"
    assert_selector "svg[data-slot='native-select-icon'][aria-hidden='true']" # chevron icon
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

  def test_select_uses_new_york_v4_native_select_classes
    render_inline(Shadcn::NativeSelectComponent.new(name: "test")) do |select|
      select.with_option(value: "1") { "One" }
    end

    classes = page.find("select[name='test']")["class"].split

    assert_includes classes, "h-9"
    assert_includes classes, "w-full"
    assert_includes classes, "min-w-0"
    assert_includes classes, "appearance-none"
    assert_includes classes, "rounded-md"
    assert_includes classes, "border"
    assert_includes classes, "border-input"
    assert_includes classes, "bg-transparent"
    assert_includes classes, "px-3"
    assert_includes classes, "py-2"
    assert_includes classes, "pr-9"
    assert_includes classes, "text-sm"
    assert_includes classes, "shadow-xs"
    assert_includes classes, "transition-[color,box-shadow]"
    assert_includes classes, "outline-none"
    assert_includes classes, "selection:bg-primary"
    assert_includes classes, "selection:text-primary-foreground"
    assert_includes classes, "placeholder:text-muted-foreground"
    assert_includes classes, "disabled:pointer-events-none"
    assert_includes classes, "disabled:cursor-not-allowed"
    assert_includes classes, "data-[size=sm]:h-8"
    assert_includes classes, "data-[size=sm]:py-1"
    assert_includes classes, "dark:bg-input/30"
    assert_includes classes, "dark:hover:bg-input/50"
    assert_includes classes, "aria-invalid:border-destructive"
    assert_includes classes, "aria-invalid:ring-destructive/20"
    assert_includes classes, "dark:aria-invalid:ring-destructive/40"

    refute_includes classes, "pl-3"
    refute_includes classes, "pr-8"
    refute_includes classes, "shadow-sm"
    refute_includes classes, "data-[size=default]:h-9"
    refute_includes classes, "data-[size=default]:py-2"
  end

  def test_select_uses_v4_focus_visible_ring_styles
    render_inline(Shadcn::NativeSelectComponent.new(name: "test")) do |select|
      select.with_option(value: "1") { "One" }
    end

    classes = page.find("select[name='test']")["class"].split
    assert_includes classes, "focus-visible:border-ring"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "focus-visible:ring-ring/50"
    refute_includes classes, "focus:ring-1"
    refute_includes classes, "focus:ring-ring"
  end

  def test_wrapper_and_icon_use_new_york_v4_native_select_classes
    render_inline(Shadcn::NativeSelectComponent.new(name: "test")) do |select|
      select.with_option(value: "1") { "One" }
    end

    wrapper_classes = page.find("div[data-slot='native-select-wrapper']")["class"].split
    icon_classes = page.find("svg[data-slot='native-select-icon']")["class"].split

    assert_includes wrapper_classes, "group/native-select"
    assert_includes wrapper_classes, "relative"
    assert_includes wrapper_classes, "w-fit"
    assert_includes wrapper_classes, "has-[select:disabled]:opacity-50"

    assert_includes icon_classes, "pointer-events-none"
    assert_includes icon_classes, "absolute"
    assert_includes icon_classes, "top-1/2"
    assert_includes icon_classes, "right-3.5"
    assert_includes icon_classes, "size-4"
    assert_includes icon_classes, "-translate-y-1/2"
    assert_includes icon_classes, "text-muted-foreground"
    assert_includes icon_classes, "opacity-50"
    assert_includes icon_classes, "select-none"
  end

  def test_options_and_optgroups_use_new_york_v4_native_select_classes
    render_inline(Shadcn::NativeSelectComponent.new(name: "test")) do |select|
      select.with_optgroup(label: "Group") do |group|
        group.with_option(value: "2") { "Two" }
      end
    end

    option_classes = page.find("option[value='2']")["class"].split
    optgroup_classes = page.find("optgroup[label='Group']")["class"].split

    assert_includes option_classes, "bg-[Canvas]"
    assert_includes option_classes, "text-[CanvasText]"
    assert_includes optgroup_classes, "bg-[Canvas]"
    assert_includes optgroup_classes, "text-[CanvasText]"
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
