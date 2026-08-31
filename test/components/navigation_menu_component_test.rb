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

  def test_renders_root_with_upstream_v4_classes_and_slot
    render_navigation_menu

    nav = page.find("nav[data-controller='shadcn--navigation-menu']")
    class_tokens = nav[:class].split

    assert_equal "navigation-menu", nav["data-slot"]
    assert_equal "true", nav["data-viewport"]
    assert_includes class_tokens, "group/navigation-menu"
    assert_includes class_tokens, "relative"
    assert_includes class_tokens, "flex"
    assert_includes class_tokens, "max-w-max"
    assert_includes class_tokens, "flex-1"
    assert_includes class_tokens, "items-center"
    assert_includes class_tokens, "justify-center"
    refute_includes class_tokens, "z-10"
  end

  def test_renders_list_and_item_with_upstream_v4_classes_and_slots
    render_navigation_menu

    list = page.find("ul[data-shadcn--navigation-menu-target='list']")
    list_class_tokens = list[:class].split
    item = page.find("li[data-shadcn--navigation-menu-target='item']")
    item_class_tokens = item[:class].split

    assert_equal "navigation-menu-list", list["data-slot"]
    assert_includes list_class_tokens, "group"
    assert_includes list_class_tokens, "flex"
    assert_includes list_class_tokens, "flex-1"
    assert_includes list_class_tokens, "list-none"
    assert_includes list_class_tokens, "items-center"
    assert_includes list_class_tokens, "justify-center"
    assert_includes list_class_tokens, "gap-1"
    refute_includes list_class_tokens, "space-x-1"

    assert_equal "navigation-menu-item", item["data-slot"]
    assert_includes item_class_tokens, "relative"
  end

  def test_renders_trigger_with_upstream_v4_classes_slot_and_chevron
    render_inline(Shadcn::NavigationMenuComponent.new) do |nav|
      nav.with_list do |list|
        list.with_item do |item|
          item.with_trigger { "Products" }
          item.with_dropdown { "Product links" }
        end
      end
    end

    trigger = page.find("button[data-shadcn--navigation-menu-target='trigger']")
    class_tokens = trigger[:class].split
    chevron = trigger.find("svg", visible: :all)
    chevron_class_tokens = chevron[:class].split

    assert_equal "navigation-menu-trigger", trigger["data-slot"]
    assert_includes class_tokens, "group"
    assert_includes class_tokens, "inline-flex"
    assert_includes class_tokens, "h-9"
    assert_includes class_tokens, "w-max"
    assert_includes class_tokens, "transition-[color,box-shadow]"
    assert_includes class_tokens, "outline-none"
    assert_includes class_tokens, "focus-visible:ring-[3px]"
    assert_includes class_tokens, "focus-visible:ring-ring/50"
    assert_includes class_tokens, "focus-visible:outline-1"
    assert_includes class_tokens, "data-[state=open]:text-accent-foreground"
    assert_includes class_tokens, "data-[state=open]:hover:bg-accent"
    assert_includes class_tokens, "data-[state=open]:focus:bg-accent"
    refute_includes class_tokens, "transition-colors"
    refute_includes class_tokens, "focus:outline-none"

    assert_includes chevron_class_tokens, "size-3"
    refute_includes chevron_class_tokens, "h-3"
    refute_includes chevron_class_tokens, "w-3"
  end

  def test_renders_link_with_upstream_v4_recipe_and_slot
    render_navigation_menu(active: true)

    link = page.find("a[href='/']")
    class_tokens = link[:class].split

    assert_equal "navigation-menu-link", link["data-slot"]
    assert_equal "true", link["data-active"]
    assert_includes class_tokens, "flex"
    assert_includes class_tokens, "flex-col"
    assert_includes class_tokens, "gap-1"
    assert_includes class_tokens, "rounded-sm"
    assert_includes class_tokens, "p-2"
    assert_includes class_tokens, "text-sm"
    assert_includes class_tokens, "transition-all"
    assert_includes class_tokens, "outline-none"
    assert_includes class_tokens, "focus-visible:ring-[3px]"
    assert_includes class_tokens, "focus-visible:ring-ring/50"
    assert_includes class_tokens, "focus-visible:outline-1"
    assert_includes class_tokens, "data-[active=true]:bg-accent/50"
    assert_includes class_tokens, "data-[active=true]:text-accent-foreground"
    assert_includes class_tokens, "data-[active=true]:hover:bg-accent"
    assert_includes class_tokens, "data-[active=true]:focus:bg-accent"
    assert_includes class_tokens, "[&_svg:not([class*='size-'])]:size-4"
    assert_includes class_tokens, "[&_svg:not([class*='text-'])]:text-muted-foreground"
    refute_includes class_tokens, "inline-flex"
    refute_includes class_tokens, "h-9"
    refute_includes class_tokens, "w-max"
    refute_includes class_tokens, "rounded-md"
    refute_includes class_tokens, "bg-background"
    refute_includes class_tokens, "px-4"
    refute_includes class_tokens, "py-2"
    refute_includes class_tokens, "transition-colors"
    refute_includes class_tokens, "focus:outline-none"
  end

  def test_renders_content_and_viewport_with_upstream_v4_classes_and_slots
    render_inline(Shadcn::NavigationMenuComponent.new) do |nav|
      nav.with_list do |list|
        list.with_item do |item|
          item.with_trigger { "Products" }
          item.with_dropdown { "Product links" }
        end
      end
    end

    content = page.find("div[data-shadcn--navigation-menu-target='content']", visible: :all)
    content_class_tokens = content[:class].split
    viewport_wrapper = page.find("nav > div.absolute", visible: :all)
    wrapper_class_tokens = viewport_wrapper[:class].split
    viewport = page.find("div[data-shadcn--navigation-menu-target='viewport']", visible: :all)

    assert_equal "navigation-menu-content", content["data-slot"]
    assert_includes content_class_tokens, "top-0"
    assert_includes content_class_tokens, "left-0"
    assert_includes content_class_tokens, "w-full"
    assert_includes content_class_tokens, "p-2"
    assert_includes content_class_tokens, "pr-2.5"
    assert_includes content_class_tokens, "group-data-[viewport=false]/navigation-menu:top-full"
    assert_includes content_class_tokens, "group-data-[viewport=false]/navigation-menu:rounded-md"
    assert_includes content_class_tokens, "**:data-[slot=navigation-menu-link]:focus:ring-0"
    assert_includes content_class_tokens, "**:data-[slot=navigation-menu-link]:focus:outline-none"

    assert_includes wrapper_class_tokens, "absolute"
    assert_includes wrapper_class_tokens, "top-full"
    assert_includes wrapper_class_tokens, "left-0"
    assert_includes wrapper_class_tokens, "isolate"
    assert_includes wrapper_class_tokens, "z-50"
    assert_includes wrapper_class_tokens, "flex"
    assert_includes wrapper_class_tokens, "justify-center"

    assert_equal "navigation-menu-viewport", viewport["data-slot"]
  end

  private

  def render_navigation_menu(active: false)
    render_inline(Shadcn::NavigationMenuComponent.new) do |nav|
      nav.with_list do |list|
        list.with_item do |item|
          item.with_link(href: "/", active: active) { "Home" }
        end
      end
    end
  end
end
