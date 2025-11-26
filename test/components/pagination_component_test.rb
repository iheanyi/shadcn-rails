# frozen_string_literal: true

require "test_helper"

class PaginationComponentTest < ViewComponent::TestCase
  def test_renders_pagination_nav
    render_inline(Shadcn::PaginationComponent.new)

    assert_selector "nav[role='navigation']"
    assert_selector "nav[aria-label='pagination']"
  end

  def test_renders_pagination_content
    render_inline(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_item(href: "/page/1") { "1" }
      end
    end

    assert_selector "ul"
    assert_selector "li"
  end

  def test_renders_pagination_items
    render_inline(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_item(href: "/page/1") { "1" }
        content.with_item(href: "/page/2") { "2" }
        content.with_item(href: "/page/3") { "3" }
      end
    end

    assert_selector "li", count: 3
    assert_selector "a[href='/page/1']", text: "1"
    assert_selector "a[href='/page/2']", text: "2"
    assert_selector "a[href='/page/3']", text: "3"
  end

  def test_renders_active_page
    render_inline(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_item(href: "/page/1") { "1" }
        content.with_item(href: "/page/2", active: true) { "2" }
      end
    end

    assert_selector "a[aria-current='page']", text: "2"
  end

  def test_renders_previous_button
    render_inline(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_previous(href: "/page/1")
      end
    end

    assert_selector "a[href='/page/1']", text: /Previous/
    assert_selector "svg" # Chevron icon
  end

  def test_renders_next_button
    render_inline(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_next_page(href: "/page/3")
      end
    end

    assert_selector "a[href='/page/3']", text: /Next/
    assert_selector "svg" # Chevron icon
  end

  def test_renders_disabled_previous
    render_inline(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_previous(disabled: true)
      end
    end

    assert_selector "span[aria-disabled='true']", text: /Previous/
  end

  def test_renders_ellipsis
    render_inline(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_ellipse
      end
    end

    assert_selector "span[aria-hidden='true']"
    assert_selector ".sr-only", text: "More pages", visible: :all
  end
end
