# frozen_string_literal: true

require "test_helper"

class NavigationMenuComponentTest < ViewComponent::TestCase
  def test_renders_nav_element
    render_inline(Shadcn::NavigationMenuComponent.new) do |nav|
      nav.with_list do |list|
        list.with_item do |item|
          item.with_link(href: "/docs") { "Docs" }
        end
      end
    end

    assert_selector "nav[aria-label='Main']"
  end

  def test_renders_with_stimulus_controller
    render_inline(Shadcn::NavigationMenuComponent.new) do |nav|
      nav.with_list do |list|
        list.with_item do |item|
          item.with_link(href: "/") { "Home" }
        end
      end
    end

    assert_selector "nav[data-controller='shadcn--navigation-menu']"
  end

  def test_renders_navigation_list
    render_inline(Shadcn::NavigationMenuComponent.new) do |nav|
      nav.with_list do |list|
        list.with_item do |item|
          item.with_link(href: "/home") { "Home" }
        end
        list.with_item do |item|
          item.with_link(href: "/about") { "About" }
        end
      end
    end

    assert_selector "ul"
    assert_selector "li", minimum: 2
  end

  def test_renders_with_viewport
    render_inline(Shadcn::NavigationMenuComponent.new) do |nav|
      nav.with_list do |list|
        list.with_item do |item|
          item.with_link(href: "/") { "Home" }
        end
      end
    end

    # Viewport is hidden by default until triggered
    assert_selector "div[data-shadcn--navigation-menu-target='viewport']", visible: :all
    assert_selector "div[data-slot='navigation-menu-viewport']", visible: :all
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::NavigationMenuComponent.new(class_name: "my-nav")) do |nav|
      nav.with_list do |list|
        list.with_item do |item|
          item.with_link(href: "/") { "Home" }
        end
      end
    end

    assert_selector "nav.my-nav"
  end

  def test_renders_with_base_styles
    render_inline(Shadcn::NavigationMenuComponent.new) do |nav|
      nav.with_list do |list|
        list.with_item do |item|
          item.with_link(href: "/") { "Home" }
        end
      end
    end

    assert_selector "nav.flex"
    assert_selector "nav.items-center"
    assert_selector "nav.justify-center"
  end

  def test_list_uses_v4_gap_token
    render_inline(Shadcn::NavigationMenuListComponent.new)

    assert_selector "ul.gap-1"
    assert_no_selector "ul.space-x-1"
  end

  def test_trigger_uses_v4_transition_focus_and_chevron_size_tokens
    render_inline(Shadcn::NavigationMenuTriggerComponent.new) { "Docs" }

    assert_includes rendered_content, "transition-[color,box-shadow]"
    assert_includes rendered_content, "focus-visible:ring-[3px]"
    assert_selector "svg.size-3"
    assert_selector "[data-slot='navigation-menu-trigger']"
  end

  def test_link_and_content_use_v4_viewport_structure_tokens
    render_inline(Shadcn::NavigationMenuLinkComponent.new(href: "/docs")) { "Docs" }
    assert_selector "a[data-slot='navigation-menu-link']"
    assert_includes rendered_content, "focus-visible:outline-1"

    render_inline(Shadcn::NavigationMenuContentComponent.new) { "Content" }
    assert_selector "[data-slot='navigation-menu-content']", visible: :all
    assert_includes rendered_content, "group-data-[viewport=false]/navigation-menu:rounded-md"
  end
end
