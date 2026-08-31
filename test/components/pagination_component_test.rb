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
  # CRITICAL: Item Ordering Tests
  # These tests ensure items and ellipses render in the correct order
  # ============================================

  def test_items_and_ellipses_render_in_correct_order
    # This test verifies that items and ellipses appear in the exact order they are called
    # Regression test for: ellipses were being rendered AFTER all items instead of inline
    render_inline(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_previous(href: "#")
        content.with_item(href: "#") { "1" }
        content.with_item(href: "#") { "2" }
        content.with_item(href: "#") { "3" }
        content.with_ellipse
        content.with_item(href: "#") { "10" }
        content.with_next_page(href: "#")
      end
    end

    # Get all list items in order
    list_items = page.all("ul > li")

    # Verify the order: Previous, 1, 2, 3, ellipsis, 10, Next
    assert_equal 7, list_items.count, "Expected 7 list items (prev, 1, 2, 3, ellipsis, 10, next)"

    # Check that Previous is first
    assert list_items[0].has_text?("Previous"), "First item should be Previous"

    # Check page numbers are in correct positions
    assert list_items[1].has_text?("1"), "Second item should be page 1"
    assert list_items[2].has_text?("2"), "Third item should be page 2"
    assert list_items[3].has_text?("3"), "Fourth item should be page 3"

    # CRITICAL: Ellipsis should be BEFORE page 10, not after
    assert list_items[4].has_css?("span[aria-hidden='true']"), "Fifth item should be ellipsis"
    assert list_items[4].has_css?(".sr-only", text: "More pages"), "Fifth item should contain 'More pages' sr-only text"

    # Page 10 should come AFTER the ellipsis
    assert list_items[5].has_text?("10"), "Sixth item should be page 10"

    # Next should be last
    assert list_items[6].has_text?("Next"), "Seventh item should be Next"
  end

  def test_multiple_ellipses_render_in_correct_positions
    # Test with ellipses on both sides of the current page range
    render_inline(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_previous(href: "#")
        content.with_item(href: "#") { "1" }
        content.with_ellipse
        content.with_item(href: "#") { "5" }
        content.with_item(href: "#", active: true) { "6" }
        content.with_item(href: "#") { "7" }
        content.with_ellipse
        content.with_item(href: "#") { "20" }
        content.with_next_page(href: "#")
      end
    end

    list_items = page.all("ul > li")

    # Expected order: Previous, 1, ellipsis, 5, 6, 7, ellipsis, 20, Next
    assert_equal 9, list_items.count, "Expected 9 list items"

    assert list_items[0].has_text?("Previous"), "First should be Previous"
    assert list_items[1].has_text?("1"), "Second should be page 1"
    assert list_items[2].has_css?("span[aria-hidden='true']"), "Third should be first ellipsis"
    assert list_items[3].has_text?("5"), "Fourth should be page 5"
    assert list_items[4].has_text?("6"), "Fifth should be page 6 (active)"
    assert list_items[5].has_text?("7"), "Sixth should be page 7"
    assert list_items[6].has_css?("span[aria-hidden='true']"), "Seventh should be second ellipsis"
    assert list_items[7].has_text?("20"), "Eighth should be page 20"
    assert list_items[8].has_text?("Next"), "Ninth should be Next"
  end

  def test_ellipsis_between_consecutive_items
    # Edge case: ellipsis between two page items
    render_inline(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_item(href: "#") { "1" }
        content.with_ellipse
        content.with_item(href: "#") { "5" }
      end
    end

    list_items = page.all("ul > li")
    assert_equal 3, list_items.count

    assert list_items[0].has_text?("1"), "First should be page 1"
    assert list_items[1].has_css?("span[aria-hidden='true']"), "Second should be ellipsis"
    assert list_items[2].has_text?("5"), "Third should be page 5"
  end

  # ============================================
  # Tests for Pagination Gem Integration
  # ============================================

  def test_renders_with_kaminari_collection
    collection = kaminari_collection(page: 3)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    assert_respond_to collection, :prev_page
    refute_kind_of Struct, collection
    assert_selector "nav[role='navigation']"
    assert_selector "ul"
    # Should have Previous, page numbers, Next
    assert_selector "a", text: /Previous/
    assert_selector "a", text: /Next/
    # Current page should be marked active
    assert_selector "a[aria-current='page']", text: "3"
  end

  def test_renders_with_will_paginate_collection
    collection = will_paginate_collection(page: 5, total: 100)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    assert_respond_to collection, :previous_page
    refute_kind_of Struct, collection
    assert_selector "nav[role='navigation']"
    assert_selector "ul"
    assert_selector "a", text: /Previous/
    assert_selector "a", text: /Next/
    assert_selector "a[aria-current='page']", text: "5"
  end

  def test_renders_with_pagy_object
    pagy = pagy_object(page: 2, total: 25)
    render_inline(Shadcn::PaginationComponent.new(pagy: pagy))

    assert_instance_of Pagy, pagy
    assert_selector "nav[role='navigation']"
    assert_selector "ul"
    assert_selector "a", text: /Previous/
    assert_selector "a", text: /Next/
    assert_selector "a[aria-current='page']", text: "2"
  end

  def test_hides_pagination_with_single_page
    collection = kaminari_collection(page: 1, total: 5)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    # Should render empty when only one page
    assert_no_selector "nav"
  end

  def test_disables_previous_on_first_page
    collection = kaminari_collection(page: 1)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    assert_nil collection.prev_page
    # Previous should be disabled on first page
    assert_selector "span[aria-disabled='true']", text: /Previous/
    assert_no_selector "a", text: /Previous/
    # Next should be a link
    assert_selector "a", text: /Next/
  end

  def test_disables_previous_on_first_page_with_pagy
    pagy = pagy_object(page: 1)
    render_inline(Shadcn::PaginationComponent.new(pagy: pagy))

    assert_nil pagy.prev
    assert_selector "span[aria-disabled='true']", text: /Previous/
    assert_no_selector "a", text: /Previous/
    assert_selector "a", text: /Next/
  end

  def test_disables_previous_on_first_page_with_will_paginate
    collection = will_paginate_collection(page: 1)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    assert_nil collection.previous_page
    assert_selector "span[aria-disabled='true']", text: /Previous/
    assert_no_selector "a", text: /Previous/
    assert_selector "a", text: /Next/
  end

  def test_disables_next_on_last_page
    collection = kaminari_collection(page: 10)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    assert_nil collection.next_page
    # Previous should be a link
    assert_selector "a", text: /Previous/
    # Next should be disabled on last page
    assert_selector "span[aria-disabled='true']", text: /Next/
    assert_no_selector "a", text: /Next/
  end

  def test_disables_next_on_last_page_with_pagy
    pagy = pagy_object(page: 10)
    render_inline(Shadcn::PaginationComponent.new(pagy: pagy))

    assert_nil pagy.next
    assert_selector "a", text: /Previous/
    assert_selector "span[aria-disabled='true']", text: /Next/
    assert_no_selector "a", text: /Next/
  end

  def test_disables_next_on_last_page_with_will_paginate
    collection = will_paginate_collection(page: 10)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    assert_nil collection.next_page
    assert_selector "a", text: /Previous/
    assert_selector "span[aria-disabled='true']", text: /Next/
    assert_no_selector "a", text: /Next/
  end

  def test_uses_custom_url_builder
    collection = kaminari_collection(page: 2, total: 25)
    url_builder = ->(page) { "/posts?page=#{page}&sort=date" }
    render_inline(Shadcn::PaginationComponent.new(collection: collection, url_builder: url_builder))

    # Check that custom URL pattern is used
    assert_selector "a[href='/posts?page=1&sort=date']"
    assert_selector "a[href='/posts?page=3&sort=date']"
  end

  def test_renders_ellipsis_for_many_pages
    collection = kaminari_collection(page: 10, total: 500)
    render_inline(Shadcn::PaginationComponent.new(collection: collection))

    # Should have ellipsis for pages gap
    assert_selector ".sr-only", text: "More pages", visible: :all
    # Should always show first and last page
    assert_selector "a[href='?page=1']", text: "1"
    assert_selector "a[href='?page=100']", text: "100"
  end

  def test_page_series_with_window
    collection = kaminari_collection(page: 5)
    render_inline(Shadcn::PaginationComponent.new(collection: collection, window: 1))

    # With window: 1, should show pages around current page
    assert_selector "a[aria-current='page']", text: "5"
    # First and last should always show
    assert_selector "a[href='?page=1']", text: "1"
    assert_selector "a[href='?page=10']", text: "10"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::PaginationComponent.new(class_name: "my-pagination"))

    assert_selector "nav.my-pagination"
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::PaginationComponent.new(class: "alias-class"))

    assert_selector "nav.alias-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::PaginationComponent.new(data: { testid: "pagination" }))

    assert_selector "[data-testid='pagination']"
  end

  private

  def pagination_records(total = 50)
    Array.new(total) { |index| "Post #{index + 1}" }
  end

  def kaminari_collection(page:, total: 50, per_page: 5)
    Kaminari.paginate_array(pagination_records(total)).page(page).per(per_page)
  end

  def pagy_object(page:, total: 50, per_page: 5)
    Pagy.new(count: total, page: page, limit: per_page)
  end

  def will_paginate_collection(page:, total: 50, per_page: 5)
    records = pagination_records(total)

    WillPaginate::Collection.create(page, per_page, records.size) do |pager|
      pager.replace(records[pager.offset, pager.per_page] || [])
    end
  end
end
