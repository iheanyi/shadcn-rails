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

  def test_group_label_uses_v4_margin_opacity_transition_token
    render_inline(Shadcn::SidebarGroupLabelComponent.new) { "Projects" }

    label = page.find("[data-sidebar='group-label']")
    assert_includes label["class"], "transition-[margin,opacity]"
    refute_includes label["class"], "transition-[margin,opa]"
  end
end
