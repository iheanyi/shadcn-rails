# frozen_string_literal: true

# @label Pagination
# @display bg_color "#ffffff"
class PaginationComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic pagination with page numbers
  def default
    render(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_previous(href: "#")
        content.with_item(href: "#") { "1" }
        content.with_item(href: "#", active: true) { "2" }
        content.with_item(href: "#") { "3" }
        content.with_next_page(href: "#")
      end
    end
  end

  # @label With Ellipsis
  # Pagination with ellipsis for many pages
  def with_ellipsis
    render(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_previous(href: "#")
        content.with_item(href: "#") { "1" }
        content.with_item(href: "#") { "2" }
        content.with_ellipse
        content.with_item(href: "#", active: true) { "5" }
        content.with_ellipse
        content.with_item(href: "#") { "9" }
        content.with_item(href: "#") { "10" }
        content.with_next_page(href: "#")
      end
    end
  end

  # @label Disabled Previous
  # First page with disabled previous button
  def disabled_previous
    render(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_previous(disabled: true)
        content.with_item(href: "#", active: true) { "1" }
        content.with_item(href: "#") { "2" }
        content.with_item(href: "#") { "3" }
        content.with_next_page(href: "#")
      end
    end
  end

  # @label Disabled Next
  # Last page with disabled next button
  def disabled_next
    render(Shadcn::PaginationComponent.new) do |pagination|
      pagination.with_pagination_content do |content|
        content.with_previous(href: "#")
        content.with_item(href: "#") { "1" }
        content.with_item(href: "#") { "2" }
        content.with_item(href: "#", active: true) { "3" }
        content.with_next_page(disabled: true)
      end
    end
  end

  # @label With Pagy
  # Real Pagy object using the pagy: API.
  def with_pagy
    pagy = Pagy.new(count: 50, page: 3, limit: 5)

    render(Shadcn::PaginationComponent.new(
      pagy: pagy,
      url_builder: ->(page) { "/docs/components/pagination?page=#{page}" }
    ))
  end

  # @label With Kaminari Collection
  # Real Kaminari collection using the collection: API.
  def with_kaminari_collection
    collection = Kaminari.paginate_array(preview_records).page(4).per(5)

    render(Shadcn::PaginationComponent.new(
      collection: collection,
      url_builder: ->(page) { "/docs/components/pagination?page=#{page}" }
    ))
  end

  # @label With will_paginate Collection
  # Real will_paginate collection using the collection: API.
  def with_will_paginate_collection
    collection = WillPaginate::Collection.create(4, 5, preview_records.size) do |pager|
      pager.replace(preview_records[pager.offset, pager.per_page] || [])
    end

    render(Shadcn::PaginationComponent.new(
      collection: collection,
      url_builder: ->(page) { "/docs/components/pagination?page=#{page}" }
    ))
  end

  private

  def preview_records
    @preview_records ||= Array.new(50) { |index| "Preview post #{index + 1}" }
  end
end
