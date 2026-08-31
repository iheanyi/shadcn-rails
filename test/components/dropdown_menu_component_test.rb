# frozen_string_literal: true

require "test_helper"

class DropdownMenuComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_dropdown_container
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "div[data-controller='shadcn--dropdown']"
    assert_selector "[data-slot='dropdown-menu']"
  end

  def test_renders_with_relative_inline_block_class
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "div.relative.inline-block"
  end

  # Trigger slot
  def test_renders_with_trigger_slot
    render_inline(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger { "Open Menu" }
    end

    assert_selector "[data-shadcn--dropdown-target='trigger']", text: "Open Menu"
    assert_selector "[data-slot='dropdown-menu-trigger']", text: "Open Menu"
  end

  def test_trigger_has_toggle_action
    render_inline(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger { "Toggle" }
    end

    assert_selector "[data-action='click->shadcn--dropdown#toggle']"
  end

  # Menu slot
  def test_renders_with_menu_slot
    render_inline(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger { "Open" }
      menu.with_menu { "Menu content" }
    end

    # Menu content is rendered (may be hidden)
    assert_text "Menu content"
  end

  # Open state
  def test_renders_closed_by_default
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "[data-shadcn--dropdown-open-value='false']"
  end

  def test_renders_open_when_specified
    render_inline(Shadcn::DropdownMenuComponent.new(open: true))

    assert_selector "[data-shadcn--dropdown-open-value='true']"
  end

  # Align variants
  def test_renders_with_end_align_by_default
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "[data-shadcn--dropdown-align-value='end']"
  end

  def test_renders_with_start_align
    render_inline(Shadcn::DropdownMenuComponent.new(align: :start))

    assert_selector "[data-shadcn--dropdown-align-value='start']"
  end

  def test_renders_with_center_align
    render_inline(Shadcn::DropdownMenuComponent.new(align: :center))

    assert_selector "[data-shadcn--dropdown-align-value='center']"
  end

  # Side variants
  def test_renders_with_bottom_side_by_default
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "[data-shadcn--dropdown-side-value='bottom']"
  end

  def test_renders_with_top_side
    render_inline(Shadcn::DropdownMenuComponent.new(side: :top))

    assert_selector "[data-shadcn--dropdown-side-value='top']"
  end

  def test_renders_with_left_side
    render_inline(Shadcn::DropdownMenuComponent.new(side: :left))

    assert_selector "[data-shadcn--dropdown-side-value='left']"
  end

  def test_renders_with_right_side
    render_inline(Shadcn::DropdownMenuComponent.new(side: :right))

    assert_selector "[data-shadcn--dropdown-side-value='right']"
  end

  # Keyboard handling
  def test_has_escape_key_action
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "[data-action*='keydown.escape->shadcn--dropdown#close']"
  end

  def test_has_click_outside_action
    render_inline(Shadcn::DropdownMenuComponent.new)

    assert_selector "[data-action*='clickOutside->shadcn--dropdown#close']"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::DropdownMenuComponent.new(class_name: "my-dropdown"))

    assert_selector "div.my-dropdown"
  end

  # Combined trigger and menu
  def test_renders_both_trigger_and_menu
    render_inline(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger { "Open" }
      menu.with_menu { "Content" }
    end

    assert_selector "[data-shadcn--dropdown-target='trigger']"
    assert_text "Content"
  end

  def test_content_classes_match_new_york_v4_and_keep_motion_hook
    render_inline(Shadcn::DropdownMenuContentComponent.new) { "Menu content" }

    classes = classes_for("[data-slot='dropdown-menu-content']")
    assert_includes classes, "shadcn-dropdown"
    assert_includes classes, "max-h-(--radix-dropdown-menu-content-available-height)"
    assert_includes classes, "origin-(--radix-dropdown-menu-content-transform-origin)"
    assert_includes classes, "overflow-x-hidden"
    assert_includes classes, "overflow-y-auto"
    assert_includes classes, "shadow-md"
    refute_includes classes, "overflow-hidden"
    refute_includes classes, "max-h-[calc("
  end

  def test_item_classes_match_new_york_v4_tokens
    render_inline(Shadcn::DropdownMenuItemComponent.new(variant: :destructive, inset: true)) { "Delete" }

    classes = classes_for("[data-slot='dropdown-menu-item']")
    assert_includes classes, "outline-hidden"
    assert_includes classes, "data-[inset]:pl-8"
    assert_includes classes, "data-[variant=destructive]:focus:bg-destructive/10"
    assert_includes classes, "dark:data-[variant=destructive]:focus:bg-destructive/20"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"
    assert_includes classes, "[&_svg:not([class*='text-'])]:text-muted-foreground"
    assert_selector "[data-slot='dropdown-menu-item'][data-inset][data-variant='destructive']"
    refute_includes class_tokens(classes), "outline-none"
    refute_includes class_tokens(classes), "transition-colors"
    refute_includes class_tokens(classes), "focus:bg-destructive"
    refute_includes class_tokens(classes), "focus:text-destructive-foreground"
    refute_includes class_tokens(classes), "[&>svg]:size-4"
  end

  def test_checkbox_item_classes_match_new_york_v4_tokens
    render_inline(Shadcn::DropdownMenuCheckboxItemComponent.new(checked: true)) { "Show toolbar" }

    classes = classes_for("[data-slot='dropdown-menu-checkbox-item']")
    indicator_classes = classes_for("[data-slot='dropdown-menu-checkbox-item'] span")
    icon_classes = classes_for("[data-slot='dropdown-menu-checkbox-item'] svg")
    assert_includes classes, "gap-2"
    assert_includes classes, "outline-hidden"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"
    assert_includes indicator_classes, "pointer-events-none"
    assert_includes indicator_classes, "size-3.5"
    assert_includes icon_classes, "size-4"
    refute_includes class_tokens(classes), "outline-none"
    refute_includes class_tokens(classes), "hover:bg-accent"
    refute_includes class_tokens(indicator_classes), "h-3.5"
    refute_includes class_tokens(indicator_classes), "w-3.5"
    refute_includes class_tokens(icon_classes), "h-4"
    refute_includes class_tokens(icon_classes), "w-4"
  end

  def test_radio_item_classes_match_new_york_v4_tokens
    render_inline(Shadcn::DropdownMenuRadioItemComponent.new(checked: true, value: "top")) { "Top" }

    classes = classes_for("[data-slot='dropdown-menu-radio-item']")
    indicator_classes = classes_for("[data-slot='dropdown-menu-radio-item'] span")
    icon_classes = classes_for("[data-slot='dropdown-menu-radio-item'] svg")
    assert_includes classes, "gap-2"
    assert_includes classes, "outline-hidden"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"
    assert_includes indicator_classes, "pointer-events-none"
    assert_includes indicator_classes, "size-3.5"
    assert_includes icon_classes, "size-2"
    assert_includes icon_classes, "fill-current"
    refute_includes class_tokens(classes), "outline-none"
    refute_includes class_tokens(classes), "hover:bg-accent"
    refute_includes class_tokens(icon_classes), "h-4"
    refute_includes class_tokens(icon_classes), "w-4"
  end

  def test_label_separator_and_shortcut_classes_match_new_york_v4_tokens
    render_inline(Shadcn::DropdownMenuLabelComponent.new(inset: true)) { "My Account" }
    label_classes = classes_for("[data-slot='dropdown-menu-label']")
    assert_includes label_classes, "font-medium"
    assert_includes label_classes, "data-[inset]:pl-8"
    assert_selector "[data-slot='dropdown-menu-label'][data-inset]"
    refute_includes class_tokens(label_classes), "font-semibold"
    refute_includes class_tokens(label_classes), "pl-8"

    render_inline(Shadcn::DropdownMenuSeparatorComponent.new)
    separator_classes = classes_for("[data-slot='dropdown-menu-separator']")
    assert_includes separator_classes, "bg-border"
    refute_includes separator_classes, "bg-muted"

    render_inline(Shadcn::DropdownMenuShortcutComponent.new) { "Cmd+K" }
    shortcut_classes = classes_for("[data-slot='dropdown-menu-shortcut']")
    assert_includes shortcut_classes, "text-muted-foreground"
    refute_includes class_tokens(shortcut_classes), "opacity-60"
  end

  def test_group_components_render_data_slots
    render_inline(Shadcn::DropdownMenuGroupComponent.new) { "Group" }
    assert_selector "[data-slot='dropdown-menu-group']", text: "Group"

    render_inline(Shadcn::DropdownMenuRadioGroupComponent.new(value: "top")) { "Radio group" }
    assert_selector "[data-slot='dropdown-menu-radio-group'][data-value='top']", text: "Radio group"
  end

  private

  def classes_for(selector)
    assert_selector selector, visible: :all
    page.find(selector, visible: :all)[:class]
  end

  def class_tokens(classes)
    classes.split
  end
end
