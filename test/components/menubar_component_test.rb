# frozen_string_literal: true

require "test_helper"

class MenubarComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_menubar_container
    render_inline(Shadcn::MenubarComponent.new)

    assert_selector "div[data-controller='shadcn--menubar']"
  end

  def test_renders_with_menubar_role
    render_inline(Shadcn::MenubarComponent.new)

    assert_selector "div[role='menubar']"
  end

  def test_renders_with_base_classes
    render_inline(Shadcn::MenubarComponent.new)

    assert_selector "div.flex"
    assert_selector "div.items-center"
    assert_selector "div.rounded-md"
    assert_selector "div.border"
    assert_selector "div.bg-background"
    assert_selector "div.shadow-sm"
  end

  # Menu slots
  def test_renders_with_single_menu
    render_inline(Shadcn::MenubarComponent.new) do |menubar|
      menubar.with_menu { "File Menu" }
    end

    assert_text "File Menu"
  end

  def test_renders_with_multiple_menus
    render_inline(Shadcn::MenubarComponent.new) do |menubar|
      menubar.with_menu { "File" }
      menubar.with_menu { "Edit" }
      menubar.with_menu { "View" }
    end

    assert_text "File"
    assert_text "Edit"
    assert_text "View"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::MenubarComponent.new(class_name: "my-menubar"))

    assert_selector "div.my-menubar"
  end

  # Stimulus controller
  def test_has_stimulus_controller
    render_inline(Shadcn::MenubarComponent.new)

    assert_selector "[data-controller='shadcn--menubar']"
  end
end
