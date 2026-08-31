# frozen_string_literal: true

require "test_helper"

class SidebarComponentTest < ViewComponent::TestCase
  def test_renders_basic_sidebar
    render_inline(Shadcn::SidebarComponent.new) do |sidebar|
      sidebar.with_header { "Header" }
      sidebar.with_sidebar_content { "Content" }
      sidebar.with_footer { "Footer" }
    end

    assert_selector "aside[data-controller='shadcn--sidebar']"
    assert_text "Header"
    assert_text "Content"
    assert_text "Footer"
  end

  def test_renders_with_default_attributes
    render_inline(Shadcn::SidebarComponent.new)

    assert_selector "aside[data-side='left']"
    assert_selector "aside[data-variant='sidebar']"
    assert_selector "aside[data-collapsible='offcanvas']"
    assert_selector "aside[data-state='expanded']"
  end

  def test_renders_collapsed_by_default
    render_inline(Shadcn::SidebarComponent.new(default_open: false))

    assert_selector "aside[data-state='collapsed']"
  end

  def test_renders_with_right_side
    render_inline(Shadcn::SidebarComponent.new(side: :right))

    assert_selector "aside[data-side='right']"
  end

  def test_renders_with_floating_variant
    render_inline(Shadcn::SidebarComponent.new(variant: :floating))

    assert_selector "aside[data-variant='floating']"
  end

  def test_renders_with_inset_variant
    render_inline(Shadcn::SidebarComponent.new(variant: :inset))

    assert_selector "aside[data-variant='inset']"
  end

  def test_renders_with_icon_collapsible
    render_inline(Shadcn::SidebarComponent.new(collapsible: :icon))

    assert_selector "aside[data-collapsible='icon']"
  end

  def test_renders_with_none_collapsible
    render_inline(Shadcn::SidebarComponent.new(collapsible: :none))

    assert_selector "aside[data-collapsible='none']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::SidebarComponent.new(class_name: "custom-sidebar"))

    assert_selector "aside.custom-sidebar"
  end

  def test_renders_rail_slot
    render_inline(Shadcn::SidebarComponent.new) do |sidebar|
      sidebar.with_rail
    end

    assert_selector "aside"
  end

  def test_renders_keyboard_shortcut_actions
    render_inline(Shadcn::SidebarComponent.new)

    assert_selector "aside[data-action*='keydown.ctrl+b@window->shadcn--sidebar#toggle']"
    assert_selector "aside[data-action*='keydown.meta+b@window->shadcn--sidebar#toggle']"
  end

  def test_provider_uses_upstream_inset_variant_selector_and_slot
    render_inline(Shadcn::SidebarProviderComponent.new) { "Content" }

    provider = page.find("[data-slot='sidebar-wrapper']")
    classes = provider["class"].split

    assert_includes classes, "has-data-[variant=inset]:bg-sidebar"
    refute_includes classes, "has-[[data-variant=inset]]:bg-sidebar"
  end

  def test_sidebar_uses_upstream_width_tokens_and_slots
    render_inline(Shadcn::SidebarComponent.new)

    sidebar = page.find("aside[data-slot='sidebar']", visible: :all)
    sidebar_classes = sidebar["class"].split

    assert_includes sidebar_classes, "w-(--sidebar-width)"
    assert_includes sidebar_classes, "group-data-[collapsible=icon]:w-(--sidebar-width-icon)"
    assert_includes sidebar_classes, "group-data-[side=left]:border-r"
    assert_includes sidebar_classes, "group-data-[side=right]:border-l"
    refute_includes sidebar_classes, "w-[--sidebar-width]"
    refute_includes sidebar_classes, "group-data-[collapsible=icon]:w-[--sidebar-width-icon]"
    refute_includes sidebar_classes, "border-r"

    inner_classes = page.find("[data-slot='sidebar-inner']", visible: :all)["class"].split
    assert_includes inner_classes, "group-data-[variant=floating]:shadow-sm"
    assert_selector "[data-sidebar='sidebar'][data-slot='sidebar-inner']", visible: :all
  end

  def test_floating_and_inset_variants_use_upstream_padding_and_icon_width_calc
    render_inline(Shadcn::SidebarComponent.new(variant: :floating))
    floating_classes = page.find("aside[data-slot='sidebar']", visible: :all)["class"].split

    assert_includes floating_classes, "p-2"
    assert_includes floating_classes, "group-data-[collapsible=icon]:w-[calc(var(--sidebar-width-icon)+(--spacing(4))+2px)]"
    refute_includes floating_classes, "group-data-[collapsible=icon]:w-(--sidebar-width-icon)"
    refute_includes floating_classes, "border-r"

    render_inline(Shadcn::SidebarComponent.new(variant: :inset))
    inset_classes = page.find("aside[data-slot='sidebar']", visible: :all)["class"].split

    assert_includes inset_classes, "p-2"
    assert_includes inset_classes, "group-data-[collapsible=icon]:w-[calc(var(--sidebar-width-icon)+(--spacing(4))+2px)]"
    refute_includes inset_classes, "group-data-[collapsible=icon]:w-(--sidebar-width-icon)"
    refute_includes inset_classes, "border-r"
    refute_includes inset_classes, "bg-transparent"
  end

  def test_trigger_uses_upstream_size_token_and_slot
    render_inline(Shadcn::SidebarTriggerComponent.new)

    trigger = page.find("[data-sidebar='trigger'][data-slot='sidebar-trigger']")
    classes = trigger["class"].split

    assert_includes classes, "size-7"
    refute_includes classes, "h-7"
    refute_includes classes, "w-7"
  end

  def test_rail_uses_upstream_cursor_and_hover_tokens
    render_inline(Shadcn::SidebarRailComponent.new)

    rail = page.find("[data-sidebar='rail'][data-slot='sidebar-rail']", visible: :all)
    classes = rail["class"].split

    assert_includes classes, "in-data-[side=left]:cursor-w-resize"
    assert_includes classes, "in-data-[side=right]:cursor-e-resize"
    assert_includes classes, "hover:group-data-[collapsible=offcanvas]:bg-sidebar"
    refute_includes classes, "[[data-side=left]_&]:cursor-w-resize"
    refute_includes classes, "[[data-side=right]_&]:cursor-e-resize"
    refute_includes classes, "group-data-[collapsible=offcanvas]:hover:bg-sidebar"
  end

  def test_inset_uses_upstream_peer_shadow_and_omits_old_calc_token
    render_inline(Shadcn::SidebarInsetComponent.new) { "Content" }

    inset = page.find("main[data-sidebar='inset'][data-slot='sidebar-inset']")
    classes = inset["class"].split

    assert_includes classes, "w-full"
    assert_includes classes, "md:peer-data-[variant=inset]:shadow-sm"
    assert_includes classes, "md:peer-data-[variant=inset]:peer-data-[state=collapsed]:ml-2"
    refute_includes classes, "md:peer-data-[variant=inset]:shadow"
    refute_includes classes, "peer-data-[variant=inset]:min-h-[calc(100svh-theme(spacing.4))]"
  end

  def test_menu_button_uses_upstream_new_york_v4_tokens
    render_inline(Shadcn::SidebarMenuButtonComponent.new(variant: :outline, size: :lg)) { "Projects" }

    button = page.find("[data-sidebar='menu-button'][data-slot='sidebar-menu-button']")
    classes = button["class"].split

    assert_includes classes, "outline-hidden"
    assert_includes classes, "group-has-data-[sidebar=menu-action]/menu-item:pr-8"
    assert_includes classes, "group-data-[collapsible=icon]:size-8!"
    assert_includes classes, "group-data-[collapsible=icon]:p-2!"
    assert_includes classes, "group-data-[collapsible=icon]:p-0!"
    assert_includes classes, "shadow-[0_0_0_1px_var(--sidebar-border)]"
    assert_includes classes, "hover:shadow-[0_0_0_1px_var(--sidebar-accent)]"
    refute_includes classes, "outline-none"
    refute_includes classes, "group-has-[[data-sidebar=menu-action]]/menu-item:pr-8"
    refute_includes classes, "group-data-[collapsible=icon]:!size-8"
    refute_includes classes, "group-data-[collapsible=icon]:!p-2"
    refute_includes classes, "group-data-[collapsible=icon]:!p-0"
    refute_includes classes, "shadow-[0_0_0_1px_hsl(var(--sidebar-border))]"
    refute_includes classes, "hover:shadow-[0_0_0_1px_hsl(var(--sidebar-accent))]"
  end

  def test_group_label_and_actions_use_upstream_outline_and_size_tokens
    render_inline(Shadcn::SidebarGroupLabelComponent.new) { "Platform" }
    label_classes = page.find("[data-sidebar='group-label'][data-slot='sidebar-group-label']")["class"].split

    assert_includes label_classes, "outline-hidden"
    assert_includes label_classes, "transition-[margin,opacity]"
    refute_includes label_classes, "outline-none"
    refute_includes label_classes, "transition-[margin,opa]"

    render_inline(Shadcn::SidebarGroupActionComponent.new) { "Add" }
    group_action_classes = page.find("[data-sidebar='group-action'][data-slot='sidebar-group-action']")["class"].split

    assert_includes group_action_classes, "outline-hidden"
    assert_includes group_action_classes, "after:absolute"
    assert_includes group_action_classes, "md:after:hidden"
    refute_includes group_action_classes, "outline-none"

    render_inline(Shadcn::SidebarMenuActionComponent.new(show_on_hover: true)) { "More" }
    menu_action_classes = page.find("[data-sidebar='menu-action'][data-slot='sidebar-menu-action']")["class"].split

    assert_includes menu_action_classes, "outline-hidden"
    assert_includes menu_action_classes, "after:absolute"
    assert_includes menu_action_classes, "md:after:hidden"
    assert_includes menu_action_classes, "peer-data-[size=sm]/menu-button:top-1"
    assert_includes menu_action_classes, "peer-data-[size=lg]/menu-button:top-2.5"
    refute_includes menu_action_classes, "outline-none"
    refute_includes menu_action_classes, "after:md:hidden"
    refute_includes menu_action_classes, "peer-data-[size=default]/menu-button:top-1.5"
  end

  def test_menu_badge_uses_upstream_offsets_without_default_size_variant
    render_inline(Shadcn::SidebarMenuBadgeComponent.new) { "3" }

    badge = page.find("[data-sidebar='menu-badge'][data-slot='sidebar-menu-badge']")
    classes = badge["class"].split

    assert_includes classes, "top-1.5"
    assert_includes classes, "peer-data-[size=sm]/menu-button:top-1"
    assert_includes classes, "peer-data-[size=lg]/menu-button:top-2.5"
    refute_includes classes, "peer-data-[size=default]/menu-button:top-1.5"
  end

  def test_menu_skeleton_inners_use_skeleton_bg_and_variable_width_tokens
    render_inline(Shadcn::SidebarMenuSkeletonComponent.new(show_icon: true))

    skeleton = page.find("[data-sidebar='menu-skeleton'][data-slot='sidebar-menu-skeleton']")
    assert_includes skeleton["class"].split, "flex"

    icon_classes = page.find("[data-sidebar='menu-skeleton-icon'][data-slot='skeleton']")["class"].split
    text = page.find("[data-sidebar='menu-skeleton-text'][data-slot='skeleton']")
    text_classes = text["class"].split

    assert_includes icon_classes, "bg-accent"
    assert_includes text_classes, "bg-accent"
    assert_includes text_classes, "max-w-(--skeleton-width)"
    assert_includes text["style"], "--skeleton-width:"
    refute_includes icon_classes, "bg-sidebar-accent"
    refute_includes text_classes, "bg-sidebar-accent"
  end

  def test_submenu_components_use_upstream_slots_and_tokens
    render_inline(Shadcn::SidebarMenuSubComponent.new)
    assert_selector "[data-sidebar='menu-sub'][data-slot='sidebar-menu-sub']", visible: :all

    render_inline(Shadcn::SidebarMenuSubItemComponent.new) { "Archive" }
    sub_item_classes = page.find("[data-sidebar='menu-sub-item'][data-slot='sidebar-menu-sub-item']")["class"].split
    assert_includes sub_item_classes, "group/menu-sub-item"
    assert_includes sub_item_classes, "relative"

    render_inline(Shadcn::SidebarMenuSubButtonComponent.new) { "Archive" }
    sub_button_classes = page.find("[data-sidebar='menu-sub-button'][data-slot='sidebar-menu-sub-button']")["class"].split
    assert_includes sub_button_classes, "outline-hidden"
    assert_includes sub_button_classes, "group-data-[collapsible=icon]:hidden"
    refute_includes sub_button_classes, "outline-none"
  end
end
