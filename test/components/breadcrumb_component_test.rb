# frozen_string_literal: true

require "test_helper"

class BreadcrumbComponentTest < ViewComponent::TestCase
  def test_renders_breadcrumb_nav
    render_inline(Shadcn::BreadcrumbComponent.new)

    assert_selector "nav[aria-label='breadcrumb'][data-slot='breadcrumb']"
    assert_selector "nav ol[data-slot='breadcrumb-list']"
  end

  def test_list_uses_upstream_new_york_v4_classes
    render_inline(Shadcn::BreadcrumbComponent.new)

    list = page.find("ol[data-slot='breadcrumb-list']")
    assert_equal "flex flex-wrap items-center gap-1.5 text-sm break-words text-muted-foreground sm:gap-2.5", list[:class]
  end

  def test_renders_breadcrumb_items
    render_inline(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(href: "/products") { "Products" }
    end

    assert_selector "li", count: 3 # 2 items + 1 separator
    assert_selector "li[data-slot='breadcrumb-item']", count: 2
    assert_selector "a[href='/'][data-slot='breadcrumb-link']", text: "Home"
    assert_selector "a[href='/products'][data-slot='breadcrumb-link']", text: "Products"
  end

  def test_renders_current_page
    render_inline(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(current: true) { "Current Page" }
    end

    assert_selector "span[aria-current='page'][data-slot='breadcrumb-page']", text: "Current Page"
    assert_selector "span[aria-disabled='true']"
  end

  def test_renders_separators_between_items
    render_inline(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(href: "/products") { "Products" }
      breadcrumb.with_item(current: true) { "Widget" }
    end

    # 3 items should have 2 separators
    assert_selector "li[aria-hidden='true'][data-slot='breadcrumb-separator']", count: 2
    assert_selector "svg", count: 2
  end

  def test_separator_uses_upstream_new_york_v4_classes
    render_inline(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(current: true) { "Current Page" }
    end

    separator = page.find("li[data-slot='breadcrumb-separator']")
    separator_classes = separator[:class].split

    assert_includes separator_classes, "[&>svg]:size-3.5"
    refute_includes separator_classes, "text-muted-foreground"

    svg_classes = separator.find("svg")[:class].to_s.split
    refute_includes svg_classes, "h-3.5"
    refute_includes svg_classes, "w-3.5"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::BreadcrumbComponent.new(class_name: "my-breadcrumb"))

    assert_selector "nav.my-breadcrumb"
  end

  def test_link_has_hover_styles
    render_inline(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
    end

    assert_selector "a.transition-colors"
  end

  def test_does_not_add_separator_after_last_item
    render_inline(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(current: true) { "Only Item" }
    end

    # Single item should have no separators
    refute_selector "li[aria-hidden='true']"
  end
end
