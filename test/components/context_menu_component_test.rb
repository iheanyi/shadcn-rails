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

  def test_renders_context_menu_data_slots
    render_inline(Shadcn::ContextMenuComponent.new) do |menu|
      menu.with_trigger { "Right click area" }
      menu.with_menu do |content|
        content.with_item { "Menu Item" }
      end
    end

    assert_selector "[data-slot='context-menu']"
    assert_selector "[data-slot='context-menu-trigger']"
    assert_selector "[data-slot='context-menu-content']", visible: :all
    assert_selector "[data-slot='context-menu-item']", visible: :all
  end

  def test_content_classes_match_new_york_v4_and_keep_motion_hook
    render_inline(Shadcn::ContextMenuContentComponent.new)

    classes = class_tokens("[data-slot='context-menu-content']")

    assert_includes classes, "shadcn-context-menu"
    assert_includes classes, "max-h-(--radix-context-menu-content-available-height)"
    assert_includes classes, "origin-(--radix-context-menu-content-transform-origin)"
    assert_includes classes, "overflow-x-hidden"
    assert_includes classes, "overflow-y-auto"
    assert_includes classes, "shadow-md"
    assert_includes classes, "data-[side=bottom]:slide-in-from-top-2"
    assert_includes classes, "data-[side=left]:slide-in-from-right-2"
    assert_includes classes, "data-[side=right]:slide-in-from-left-2"
    assert_includes classes, "data-[side=top]:slide-in-from-bottom-2"
    assert_includes classes, "data-[state=closed]:animate-out"
    assert_includes classes, "data-[state=closed]:fade-out-0"
    assert_includes classes, "data-[state=closed]:zoom-out-95"
    assert_includes classes, "data-[state=open]:animate-in"
    assert_includes classes, "data-[state=open]:fade-in-0"
    assert_includes classes, "data-[state=open]:zoom-in-95"
    refute_includes classes, "overflow-hidden"
  end

  def test_item_classes_match_new_york_v4
    render_inline(Shadcn::ContextMenuItemComponent.new(inset: true)) { "Menu Item" }

    item = page.find("[data-slot='context-menu-item']", visible: :all)
    classes = item[:class].split

    assert_equal "default", item["data-variant"]
    assert_equal "", item["data-inset"]
    assert_includes classes, "outline-hidden"
    assert_includes classes, "data-[inset]:pl-8"
    assert_includes classes, "[&_svg]:pointer-events-none"
    assert_includes classes, "[&_svg]:shrink-0"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"
    assert_includes classes, "[&_svg:not([class*='text-'])]:text-muted-foreground"
    refute_includes classes, "outline-none"
    refute_includes classes, "transition-colors"
    refute_includes classes, "hover:bg-accent"
    refute_includes classes, "hover:text-accent-foreground"
  end

  def test_destructive_item_uses_upstream_data_variant_classes
    render_inline(Shadcn::ContextMenuItemComponent.new(variant: :destructive)) { "Delete" }

    item = page.find("[data-slot='context-menu-item']", visible: :all)
    classes = item[:class].split

    assert_equal "destructive", item["data-variant"]
    assert_includes classes, "data-[variant=destructive]:text-destructive"
    assert_includes classes, "data-[variant=destructive]:focus:bg-destructive/10"
    assert_includes classes, "data-[variant=destructive]:focus:text-destructive"
    assert_includes classes, "dark:data-[variant=destructive]:focus:bg-destructive/20"
    assert_includes classes, "data-[variant=destructive]:*:[svg]:text-destructive!"
    refute_includes classes, "hover:bg-destructive"
    refute_includes classes, "hover:text-destructive-foreground"
    refute_includes classes, "focus:bg-destructive"
    refute_includes classes, "focus:text-destructive-foreground"
  end

  def test_checkbox_item_classes_and_indicator_match_new_york_v4
    render_inline(Shadcn::ContextMenuCheckboxItemComponent.new(checked: true)) { "Checked" }

    classes = class_tokens("[data-slot='context-menu-checkbox-item']")
    indicator_classes = class_tokens("[data-slot='context-menu-checkbox-item'] span")
    icon_classes = class_tokens("[data-slot='context-menu-checkbox-item'] svg")

    assert_includes classes, "gap-2"
    assert_includes classes, "outline-hidden"
    assert_includes classes, "[&_svg]:pointer-events-none"
    assert_includes classes, "[&_svg]:shrink-0"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"
    assert_includes indicator_classes, "pointer-events-none"
    assert_includes indicator_classes, "size-3.5"
    assert_includes icon_classes, "size-4"
    refute_includes classes, "outline-none"
  end

  def test_radio_group_and_item_classes_match_new_york_v4
    render_inline(Shadcn::ContextMenuRadioGroupComponent.new(value: "top")) do |group|
      group.with_item(value: "top", checked: true) { "Top" }
    end

    assert_selector "[data-slot='context-menu-radio-group']", visible: :all

    classes = class_tokens("[data-slot='context-menu-radio-item']")
    indicator_classes = class_tokens("[data-slot='context-menu-radio-item'] span")
    icon_classes = class_tokens("[data-slot='context-menu-radio-item'] svg")

    assert_includes classes, "gap-2"
    assert_includes classes, "outline-hidden"
    assert_includes classes, "[&_svg]:pointer-events-none"
    assert_includes classes, "[&_svg]:shrink-0"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"
    assert_includes indicator_classes, "pointer-events-none"
    assert_includes indicator_classes, "size-3.5"
    assert_includes icon_classes, "size-2"
    assert_includes icon_classes, "fill-current"
    refute_includes classes, "outline-none"
  end

  def test_label_classes_match_new_york_v4
    render_inline(Shadcn::ContextMenuLabelComponent.new(inset: true)) { "Label" }

    label = page.find("[data-slot='context-menu-label']", visible: :all)
    classes = label[:class].split

    assert_equal "", label["data-inset"]
    assert_includes classes, "font-medium"
    assert_includes classes, "text-foreground"
    assert_includes classes, "data-[inset]:pl-8"
    refute_includes classes, "font-semibold"
    refute_includes classes, "pl-8"
  end

  def test_separator_classes_match_new_york_v4
    render_inline(Shadcn::ContextMenuSeparatorComponent.new)

    classes = class_tokens("[data-slot='context-menu-separator']")

    assert_includes classes, "bg-border"
    refute_includes classes, "bg-muted"
  end

  def test_shortcut_classes_match_new_york_v4
    render_inline(Shadcn::ContextMenuShortcutComponent.new) { "Cmd K" }

    classes = class_tokens("[data-slot='context-menu-shortcut']")

    assert_includes classes, "text-muted-foreground"
    refute_includes classes, "opacity-60"
  end

  private

  def class_tokens(selector)
    page.find(selector, visible: :all)[:class].split
  end
end
