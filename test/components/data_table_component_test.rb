# frozen_string_literal: true

require "test_helper"

class DataTableComponentTest < ViewComponent::TestCase
  include Shadcn::Rails::Helpers::DataTableHelper

  Invoice = Struct.new(:name, :email, :status, :amount, keyword_init: true)

  def test_renders_columns_and_rows_with_default_and_block_cells
    render_inline(Shadcn::DataTableComponent.new(rows: invoices, path: "/invoices")) do |table|
      table.with_column(:name, label: "Customer", sortable: true)
      table.with_column(:email)
      table.with_column(:amount, align: :end) { |invoice| "$#{invoice[:amount]}" }
    end

    assert_selector "table"
    assert_selector "th", text: "Customer"
    assert_selector "th", text: "Email"
    assert_selector "td", text: "Olivia Martin"
    assert_selector "td.text-right", text: "$1999"
  end

  def test_renders_object_rows_with_public_methods
    rows = [
      Invoice.new(name: "Olivia Martin", email: "olivia@example.com", status: "Paid", amount: 1999)
    ]

    render_inline(Shadcn::DataTableComponent.new(rows: rows, path: "/invoices")) do |table|
      table.with_column(:name)
      table.with_column(:email)
    end

    assert_selector "td", text: "Olivia Martin"
    assert_selector "td", text: "olivia@example.com"
  end

  def test_sortable_headers_render_aria_sort_and_cycle_urls
    render_inline(
      Shadcn::DataTableComponent.new(
        rows: invoices,
        sort: "name",
        dir: "asc",
        params: { "q" => "paid", "page" => "2", "sort" => "name", "dir" => "asc" },
        path: "/invoices"
      )
    ) do |table|
      table.with_column(:name, label: "Customer", sortable: true)
      table.with_column(:email, sortable: true)
      table.with_column(:status)
    end

    customer_header = page.find("th", text: "Customer")
    email_header = page.find("th", text: "Email")

    assert_equal "ascending", customer_header["aria-sort"]
    assert_equal "none", email_header["aria-sort"]

    customer_href = customer_header.find("a")["href"]
    email_href = email_header.find("a")["href"]

    assert_includes customer_href, "q=paid"
    assert_includes customer_href, "sort=name"
    assert_includes customer_href, "dir=desc"
    refute_includes customer_href, "page=2"

    assert_includes email_href, "q=paid"
    assert_includes email_href, "sort=email"
    assert_includes email_href, "dir=asc"
  end

  def test_descending_sort_link_cycles_to_unsorted_url
    render_inline(
      Shadcn::DataTableComponent.new(
        rows: invoices,
        sort: "name",
        dir: "desc",
        params: { "q" => "paid", "sort" => "name", "dir" => "desc" },
        path: "/invoices"
      )
    ) do |table|
      table.with_column(:name, label: "Customer", sortable: true)
    end

    customer_header = page.find("th", text: "Customer")
    assert_equal "descending", customer_header["aria-sort"]

    href = customer_header.find("a")["href"]
    assert_equal "/invoices?q=paid", href
  end

  def test_empty_state_slot_renders_with_column_colspan
    render_inline(Shadcn::DataTableComponent.new(rows: [], path: "/invoices")) do |table|
      table.with_column(:name)
      table.with_column(:email)
      table.with_empty_state { "No invoices match your filters." }
    end

    assert_selector "td[colspan='2']", text: "No invoices match your filters."
  end

  def test_default_empty_state_uses_empty_component
    render_inline(Shadcn::DataTableComponent.new(rows: [], path: "/invoices")) do |table|
      table.with_column(:name)
    end

    assert_selector "h3", text: "No results"
    assert_selector "p", text: "Try adjusting your filters or search terms."
  end

  def test_footer_slot_renders_below_table
    render_inline(Shadcn::DataTableComponent.new(rows: invoices, path: "/invoices")) do |table|
      table.with_column(:name)
      table.with_footer do
        render Shadcn::PaginationComponent.new do |pagination|
          pagination.with_pagination_content do |content|
            content.with_item(href: "/invoices?page=1", active: true) { "1" }
          end
        end
      end
    end

    assert_selector "nav[aria-label='pagination']"
    assert_selector "a[aria-current='page']", text: "1"
  end

  def test_helper_cycles_and_preserves_params
    asc_url = shadcn_data_table_sort_url(
      :name,
      params: { q: "olivia", page: "3" },
      path: "/contacts"
    )
    desc_url = shadcn_data_table_sort_url(
      :name,
      params: { q: "olivia", sort: "name", dir: "asc", page: "3" },
      path: "/contacts"
    )
    unsorted_url = shadcn_data_table_sort_url(
      :name,
      params: { q: "olivia", sort: "name", dir: "desc" },
      path: "/contacts"
    )

    assert_includes asc_url, "q=olivia"
    assert_includes asc_url, "sort=name"
    assert_includes asc_url, "dir=asc"
    refute_includes asc_url, "page=3"

    assert_includes desc_url, "dir=desc"
    assert_equal "/contacts?q=olivia", unsorted_url
  end

  private

  def invoices
    [
      { name: "Olivia Martin", email: "olivia@example.com", status: "Paid", amount: 1999 },
      { name: "Jackson Lee", email: "jackson@example.com", status: "Paid", amount: 3900 }
    ]
  end
end
