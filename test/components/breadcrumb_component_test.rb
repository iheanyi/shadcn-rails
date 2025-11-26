# frozen_string_literal: true

require "test_helper"

class BreadcrumbComponentTest < ViewComponent::TestCase
  def test_renders_breadcrumb_nav
    render_inline(Shadcn::BreadcrumbComponent.new)

    assert_selector "nav[aria-label='Breadcrumb']"
    assert_selector "nav ol"
  end

  def test_renders_breadcrumb_items
    render_inline(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(href: "/products") { "Products" }
    end

    assert_selector "li", count: 3 # 2 items + 1 separator
    assert_selector "a[href='/']", text: "Home"
    assert_selector "a[href='/products']", text: "Products"
  end

  def test_renders_current_page
    render_inline(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(current: true) { "Current Page" }
    end

    assert_selector "span[aria-current='page']", text: "Current Page"
    assert_selector "span[aria-disabled='true']"
  end

  def test_renders_separators_between_items
    render_inline(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(href: "/products") { "Products" }
      breadcrumb.with_item(current: true) { "Widget" }
    end

    # 3 items should have 2 separators
    assert_selector "li[aria-hidden='true']", count: 2
    assert_selector "svg", count: 2
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
