# frozen_string_literal: true

require "test_helper"

class MenubarComponentTest < ViewComponent::TestCase
  ROOT_CLASSES = "flex h-9 items-center gap-1 rounded-md border bg-background p-1 shadow-xs"
  TRIGGER_CLASSES = "flex items-center rounded-sm px-2 py-1 text-sm font-medium outline-hidden select-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground"
  CONTENT_CLASSES = "z-50 min-w-[12rem] origin-(--radix-menubar-content-transform-origin) overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95"
  ITEM_CLASSES = "relative flex cursor-default items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-hidden select-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 data-[inset]:pl-8 data-[variant=destructive]:text-destructive data-[variant=destructive]:focus:bg-destructive/10 data-[variant=destructive]:focus:text-destructive dark:data-[variant=destructive]:focus:bg-destructive/20 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4 [&_svg:not([class*='text-'])]:text-muted-foreground data-[variant=destructive]:*:[svg]:text-destructive!"
  CHECKBOX_ITEM_CLASSES = "relative flex cursor-default items-center gap-2 rounded-xs py-1.5 pr-2 pl-8 text-sm outline-hidden select-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"
  SUB_CONTENT_CLASSES = "z-50 min-w-[8rem] origin-(--radix-menubar-content-transform-origin) overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95"

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

    classes = page.find("[data-slot='menubar']")["class"]

    assert_equal ROOT_CLASSES, classes
    assert_includes classes, "gap-1"
    assert_includes classes, "shadow-xs"
    refute_includes classes, "space-x-1"
    refute_includes classes, "shadow-sm"
  end

  # Menu slots
  def test_renders_with_single_menu
    render_inline(Shadcn::MenubarComponent.new) do |menubar|
      menubar.with_menu do |menu|
        menu.with_trigger { "File" }
      end
    end

    assert_selector "[data-shadcn--menubar-target='menu']"
  end

  def test_renders_with_multiple_menus
    render_inline(Shadcn::MenubarComponent.new) do |menubar|
      menubar.with_menu do |menu|
        menu.with_trigger { "File" }
      end
      menubar.with_menu do |menu|
        menu.with_trigger { "Edit" }
      end
      menubar.with_menu do |menu|
        menu.with_trigger { "View" }
      end
    end

    assert_selector "[data-shadcn--menubar-target='menu']", count: 3
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

  def test_trigger_classes_match_upstream_new_york_v4
    render_inline(Shadcn::MenubarTriggerComponent.new) { "File" }

    classes = page.find("[data-slot='menubar-trigger']")["class"]

    assert_equal TRIGGER_CLASSES, classes
    assert_includes classes, "px-2"
    assert_includes classes, "outline-hidden"
    refute_includes classes, "px-3"
    refute_includes classes, "outline-none"
    refute_includes classes, "cursor-default"
  end

  def test_content_classes_keep_motion_hooks_and_match_upstream_new_york_v4
    render_inline(Shadcn::MenubarContentComponent.new)

    classes = page.find("[data-slot='menubar-content']", visible: false)["class"]

    assert_equal CONTENT_CLASSES, classes
    assert_includes classes, "origin-(--radix-menubar-content-transform-origin)"
    assert_includes classes, "data-[side=bottom]:slide-in-from-top-2"
    refute_includes classes, "data-[state=closed]:animate-out"
  end

  def test_item_classes_match_upstream_new_york_v4
    render_inline(Shadcn::MenubarItemComponent.new(inset: true, variant: :destructive)) { "Delete" }

    item = page.find("[data-slot='menubar-item']")
    classes = item["class"]

    assert_equal ITEM_CLASSES, classes
    assert_equal "destructive", item["data-variant"]
    assert_equal "", item["data-inset"]
    assert_includes classes, "gap-2"
    assert_includes classes, "outline-hidden"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"
    refute_includes classes, "outline-none"
    refute_includes classes, "focus:bg-destructive focus:text-destructive-foreground"
  end

  def test_checkbox_item_classes_and_icon_sizes_match_upstream_new_york_v4
    render_inline(Shadcn::MenubarCheckboxItemComponent.new(checked: true)) { "Show Toolbar" }

    item = page.find("[data-slot='menubar-checkbox-item']")
    indicator = item.find("span", visible: false)
    icon = indicator.find("svg", visible: false)
    classes = item["class"]

    assert_equal CHECKBOX_ITEM_CLASSES, classes
    assert_includes classes, "rounded-xs"
    assert_includes classes, "outline-hidden"
    assert_equal "pointer-events-none absolute left-2 flex size-3.5 items-center justify-center", indicator["class"]
    assert_equal "size-4", icon["class"]
    refute_includes classes, "rounded-sm"
    refute_includes classes, "outline-none"
    refute_includes indicator["class"], "h-3.5"
    refute_includes icon["class"], "h-4 w-4"
  end

  def test_radio_item_classes_and_icon_sizes_match_upstream_new_york_v4
    render_inline(Shadcn::MenubarRadioItemComponent.new(value: "andy", checked: true)) { "Andy" }

    item = page.find("[data-slot='menubar-radio-item']")
    indicator = item.find("span", visible: false)
    icon = indicator.find("svg", visible: false)
    classes = item["class"]

    assert_equal CHECKBOX_ITEM_CLASSES, classes
    assert_equal "pointer-events-none absolute left-2 flex size-3.5 items-center justify-center", indicator["class"]
    assert_equal "size-2 fill-current", icon["class"]
    refute_includes classes, "rounded-sm"
    refute_includes classes, "outline-none"
    refute_includes icon["class"], "h-4 w-4"
  end

  def test_label_and_separator_classes_match_upstream_new_york_v4
    render_inline(Shadcn::MenubarLabelComponent.new(inset: true)) { "Appearance" }
    label = page.find("[data-slot='menubar-label']")

    assert_equal "px-2 py-1.5 text-sm font-medium data-[inset]:pl-8", label["class"]
    assert_equal "", label["data-inset"]
    refute_includes label["class"], "font-semibold"

    render_inline(Shadcn::MenubarSeparatorComponent.new)
    separator = page.find("[data-slot='menubar-separator']")

    assert_equal "-mx-1 my-1 h-px bg-border", separator["class"]
    refute_includes separator["class"], "bg-muted"
  end

  def test_shortcut_and_submenu_classes_match_upstream_new_york_v4
    render_inline(Shadcn::MenubarShortcutComponent.new) { "Cmd+T" }

    shortcut = page.find("[data-slot='menubar-shortcut']")
    assert_equal "ml-auto text-xs tracking-widest text-muted-foreground", shortcut["class"]

    render_inline(Shadcn::MenubarSubTriggerComponent.new(inset: true)) { "More Tools" }
    sub_trigger = page.find("[data-slot='menubar-sub-trigger']")

    assert_equal "flex cursor-default items-center rounded-sm px-2 py-1.5 text-sm outline-none select-none focus:bg-accent focus:text-accent-foreground data-[inset]:pl-8 data-[state=open]:bg-accent data-[state=open]:text-accent-foreground", sub_trigger["class"]
    assert_equal "", sub_trigger["data-inset"]
    refute_includes sub_trigger["class"], "select-none items-center"

    render_inline(Shadcn::MenubarSubContentComponent.new)
    sub_content = page.find("[data-slot='menubar-sub-content']", visible: false)

    assert_equal SUB_CONTENT_CLASSES, sub_content["class"]
    assert_includes sub_content["class"], "data-[state=closed]:animate-out"
    assert_includes sub_content["class"], "data-[side=right]:slide-in-from-left-2"
  end
end
