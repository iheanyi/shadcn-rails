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
  # Pagy-style pagination object using the pagy: API.
  def with_pagy
    pagy = PreviewPagy.new(page: 3, pages: 10)

    render(Shadcn::PaginationComponent.new(
      pagy: pagy,
      url_builder: ->(page) { "/docs/components/pagination?page=#{page}" }
    ))
  end

  # @label With Kaminari Collection
  # Kaminari/will_paginate-style collection using the collection: API.
  def with_kaminari_collection
    collection = PreviewCollection.new(current_page: 4, total_pages: 10)

    render(Shadcn::PaginationComponent.new(
      collection: collection,
      url_builder: ->(page) { "/docs/components/pagination?page=#{page}" }
    ))
  end

  private

  PreviewPagy = Struct.new(:page, :pages, keyword_init: true) do
    def prev
      page > 1 ? page - 1 : nil
    end

    def next
      page < pages ? page + 1 : nil
    end
  end

  PreviewCollection = Struct.new(:current_page, :total_pages, keyword_init: true) do
    def prev_page
      current_page > 1 ? current_page - 1 : nil
    end

    def next_page
      current_page < total_pages ? current_page + 1 : nil
    end
  end
end
