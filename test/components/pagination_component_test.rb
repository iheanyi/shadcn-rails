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

  # ============================================
  # Tests for Pagination Gem Integration
  # ============================================

  # Mock class that mimics Kaminari's collection API
  class MockKaminariCollection
    attr_reader :current_page, :total_pages, :prev_page, :next_page

    def initialize(current_page:, total_pages:)
      @current_page = current_page
      @total_pages = total_pages
      @prev_page = current_page > 1 ? current_page - 1 : nil
      @next_page = current_page < total_pages ? current_page + 1 : nil
    end
  end

  # Mock class that mimics will_paginate's collection API
  class MockWillPaginateCollection
    attr_reader :current_page, :total_pages, :previous_page, :next_page

    def initialize(current_page:, total_pages:)
      @current_page = current_page
      @total_pages = total_pages
      @previous_page = current_page > 1 ? current_page - 1 : nil
      @next_page = current_page < total_pages ? current_page + 1 : nil
    end
  end

  # Mock class that mimics Pagy's API
  class MockPagy
    attr_reader :page, :pages, :prev, :next

    def initialize(page:, pages:)
      @page = page
      @pages = pages
      @prev = page > 1 ? page - 1 : nil
      @next = page < pages ? page + 1 : nil
    end
  end

  def test_renders_with_kaminari_collection
    collection = MockKaminariCollection.new(current_page: 3, total_pages: 10)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    assert_selector "nav[role='navigation']"
    assert_selector "ul"
    # Should have Previous, page numbers, Next
    assert_selector "a", text: /Previous/
    assert_selector "a", text: /Next/
    # Current page should be marked active
    assert_selector "a[aria-current='page']", text: "3"
  end

  def test_renders_with_will_paginate_collection
    collection = MockWillPaginateCollection.new(current_page: 5, total_pages: 20)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    assert_selector "nav[role='navigation']"
    assert_selector "ul"
    assert_selector "a", text: /Previous/
    assert_selector "a", text: /Next/
    assert_selector "a[aria-current='page']", text: "5"
  end

  def test_renders_with_pagy_object
    pagy = MockPagy.new(page: 2, pages: 5)
    render_inline(Shadcn::PaginationComponent.new(pagy: pagy))

    assert_selector "nav[role='navigation']"
    assert_selector "ul"
    assert_selector "a", text: /Previous/
    assert_selector "a", text: /Next/
    assert_selector "a[aria-current='page']", text: "2"
  end

  def test_hides_pagination_with_single_page
    collection = MockKaminariCollection.new(current_page: 1, total_pages: 1)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    # Should render empty when only one page
    assert_no_selector "nav"
  end

  def test_disables_previous_on_first_page
    collection = MockKaminariCollection.new(current_page: 1, total_pages: 5)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    # Previous should be disabled on first page
    assert_selector "span[aria-disabled='true']", text: /Previous/
    # Next should be a link
    assert_selector "a", text: /Next/
  end

  def test_disables_next_on_last_page
    collection = MockKaminariCollection.new(current_page: 5, total_pages: 5)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    # Previous should be a link
    assert_selector "a", text: /Previous/
    # Next should be disabled on last page
    assert_selector "span[aria-disabled='true']", text: /Next/
  end

  def test_uses_custom_url_builder
    collection = MockKaminariCollection.new(current_page: 2, total_pages: 5)
    url_builder = ->(page) { "/posts?page=#{page}&sort=date" }
    render_inline(Shadcn::PaginationComponent.new(collection: collection, url_builder: url_builder))

    # Check that custom URL pattern is used
    assert_selector "a[href='/posts?page=1&sort=date']"
    assert_selector "a[href='/posts?page=3&sort=date']"
  end

  def test_renders_ellipsis_for_many_pages
    collection = MockKaminariCollection.new(current_page: 10, total_pages: 100)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    # Should have ellipsis for pages gap
    assert_selector ".sr-only", text: "More pages", visible: :all
    # Should always show first and last page
    assert_selector "a[href='?page=1']", text: "1"
    assert_selector "a[href='?page=100']", text: "100"
  end

  def test_page_series_with_window
    collection = MockKaminariCollection.new(current_page: 5, total_pages: 10)
    render_inline(Shadcn::PaginationComponent.new(collection: collection, window: 1))

    # With window: 1, should show pages around current page
    assert_selector "a[aria-current='page']", text: "5"
    # First and last should always show
    assert_selector "a[href='?page=1']", text: "1"
    assert_selector "a[href='?page=10']", text: "10"
  end
end
