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

  def test_content_uses_v4_origin_available_height_tokens
    render_inline(Shadcn::ContextMenuContentComponent.new)

    assert_includes rendered_content, "max-h-(--radix-context-menu-content-available-height)"
    assert_includes rendered_content, "origin-(--radix-context-menu-content-transform-origin)"
    assert_selector "[data-side='bottom']", visible: :all
  end

  def test_item_uses_v4_inset_destructive_svg_tokens
    render_inline(Shadcn::ContextMenuItemComponent.new(inset: true, variant: :destructive)) { "Delete" }

    assert_includes rendered_content, "outline-hidden"
    assert_includes rendered_content, "data-[inset]:pl-8"
    assert_selector "[data-inset]", visible: :all
    assert_selector "[data-variant='destructive']", visible: :all
  end

  def test_separator_and_indicators_use_v4_tokens
    render_inline(Shadcn::ContextMenuSeparatorComponent.new)
    assert_selector ".bg-border"

    render_inline(Shadcn::ContextMenuRadioItemComponent.new(checked: true)) { "Selected" }
    assert_includes rendered_content, "size-3.5"
    assert_includes rendered_content, "size-4"
  end
end
