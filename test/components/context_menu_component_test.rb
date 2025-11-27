# frozen_string_literal: true

require "test_helper"

class ContextMenuComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_context_menu_container
    render_inline(Shadcn::ContextMenuComponent.new)

    assert_selector "div[data-controller='shadcn--context-menu']"
  end

  def test_renders_with_relative_inline_block_class
    render_inline(Shadcn::ContextMenuComponent.new)

    assert_selector "div.relative.inline-block"
  end

  # Trigger slot
  def test_renders_with_trigger_slot
    render_inline(Shadcn::ContextMenuComponent.new) do |menu|
      menu.with_trigger { "Right click here" }
    end

    assert_selector "[data-shadcn--context-menu-target='trigger']", text: "Right click here"
  end

  def test_trigger_has_contextmenu_action
    render_inline(Shadcn::ContextMenuComponent.new) do |menu|
      menu.with_trigger { "Click me" }
    end

    assert_selector "[data-action='contextmenu->shadcn--context-menu#show:prevent']"
  end

  # Menu slot
  def test_renders_with_menu_slot
    render_inline(Shadcn::ContextMenuComponent.new) do |menu|
      menu.with_trigger { "Trigger" }
      menu.with_menu do |content|
        content.with_item { "Menu content" }
      end
    end

    # Menu content is rendered (may be hidden)
    assert_text "Menu content"
  end

  # Keyboard handling
  def test_has_escape_key_action
    render_inline(Shadcn::ContextMenuComponent.new)

    assert_selector "[data-action*='keydown.escape->shadcn--context-menu#close']"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::ContextMenuComponent.new(class_name: "my-context-menu"))

    assert_selector "div.my-context-menu"
  end

  # Combined trigger and menu
  def test_renders_both_trigger_and_menu
    render_inline(Shadcn::ContextMenuComponent.new) do |menu|
      menu.with_trigger { "Right click area" }
      menu.with_menu do |content|
        content.with_item { "Menu Item" }
      end
    end

    assert_selector "[data-shadcn--context-menu-target='trigger']"
    assert_text "Menu Item"
  end
end
