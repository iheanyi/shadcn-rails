# frozen_string_literal: true

require "test_helper"

class SidebarComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_sidebar_container
    render_inline(Shadcn::SidebarComponent.new)

    assert_selector "aside[data-controller='shadcn--sidebar']"
  end

  # Side variants
  def test_renders_on_left_by_default
    render_inline(Shadcn::SidebarComponent.new)

    assert_selector "[data-side='left']"
    assert_selector "[data-shadcn--sidebar-side-value='left']"
  end

  def test_renders_on_right
    render_inline(Shadcn::SidebarComponent.new(side: :right))

    assert_selector "[data-side='right']"
    assert_selector "[data-shadcn--sidebar-side-value='right']"
  end

  # Variant options
  def test_renders_sidebar_variant_by_default
    render_inline(Shadcn::SidebarComponent.new)

    assert_selector "[data-variant='sidebar']"
    assert_selector "[data-shadcn--sidebar-variant-value='sidebar']"
  end

  def test_renders_floating_variant
    render_inline(Shadcn::SidebarComponent.new(variant: :floating))

    assert_selector "[data-variant='floating']"
    assert_selector "[data-shadcn--sidebar-variant-value='floating']"
  end

  def test_renders_inset_variant
    render_inline(Shadcn::SidebarComponent.new(variant: :inset))

    assert_selector "[data-variant='inset']"
    assert_selector "[data-shadcn--sidebar-variant-value='inset']"
  end

  # Collapsible modes
  def test_renders_offcanvas_collapsible_by_default
    render_inline(Shadcn::SidebarComponent.new)

    assert_selector "[data-collapsible='offcanvas']"
    assert_selector "[data-shadcn--sidebar-collapsible-value='offcanvas']"
  end

  def test_renders_icon_collapsible
    render_inline(Shadcn::SidebarComponent.new(collapsible: :icon))

    assert_selector "[data-collapsible='icon']"
    assert_selector "[data-shadcn--sidebar-collapsible-value='icon']"
  end

  def test_renders_none_collapsible
    render_inline(Shadcn::SidebarComponent.new(collapsible: :none))

    assert_selector "[data-collapsible='none']"
    assert_selector "[data-shadcn--sidebar-collapsible-value='none']"
  end

  # Default open state
  def test_renders_expanded_by_default
    render_inline(Shadcn::SidebarComponent.new)

    assert_selector "[data-state='expanded']"
    assert_selector "[data-shadcn--sidebar-open-value='true']"
  end

  def test_renders_collapsed_when_specified
    render_inline(Shadcn::SidebarComponent.new(default_open: false))

    assert_selector "[data-state='collapsed']"
    assert_selector "[data-shadcn--sidebar-open-value='false']"
  end

  # Keyboard shortcuts
  def test_has_keyboard_toggle_action
    render_inline(Shadcn::SidebarComponent.new)

    action = page.find("aside")["data-action"]
    assert_includes action, "keydown.ctrl+b@window->shadcn--sidebar#toggle"
    assert_includes action, "keydown.meta+b@window->shadcn--sidebar#toggle"
  end

  # Header slot
  def test_renders_with_header
    render_inline(Shadcn::SidebarComponent.new) do |sidebar|
      sidebar.with_header { "Header Content" }
    end

    assert_text "Header Content"
  end

  # Sidebar content slot
  def test_renders_with_sidebar_content
    render_inline(Shadcn::SidebarComponent.new) do |sidebar|
      sidebar.with_sidebar_content { "Main Content" }
    end

    assert_text "Main Content"
  end

  # Footer slot
  def test_renders_with_footer
    render_inline(Shadcn::SidebarComponent.new) do |sidebar|
      sidebar.with_footer { "Footer Content" }
    end

    assert_text "Footer Content"
  end

  # Rail slot
  def test_renders_with_rail
    render_inline(Shadcn::SidebarComponent.new) do |sidebar|
      sidebar.with_rail { "Rail Content" }
    end

    assert_text "Rail Content"
  end

  # Inner structure
  def test_renders_inner_container
    render_inline(Shadcn::SidebarComponent.new)

    assert_selector "[data-shadcn--sidebar-target='inner']"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::SidebarComponent.new(class_name: "my-sidebar"))

    assert_selector "aside.my-sidebar"
  end

  # Complete sidebar
  def test_renders_complete_sidebar
    render_inline(Shadcn::SidebarComponent.new) do |sidebar|
      sidebar.with_header { "Logo" }
      sidebar.with_sidebar_content { "Navigation" }
      sidebar.with_footer { "User" }
    end

    assert_selector "[data-controller='shadcn--sidebar']"
    assert_text "Logo"
    assert_text "Navigation"
    assert_text "User"
  end
end
