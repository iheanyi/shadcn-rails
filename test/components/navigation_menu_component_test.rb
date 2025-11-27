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
end
