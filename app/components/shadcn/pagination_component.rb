# frozen_string_literal: true

module Shadcn
  # Pagination component for navigating paged content
  # Matches shadcn/ui Pagination component
  #
  # Supports three usage patterns:
  #
  # 1. Slot-based API (full control):
  #   <%= render Shadcn::PaginationComponent.new do |pagination| %>
  #     <% pagination.with_pagination_content do |content| %>
  #       <% content.with_previous(href: "/page/1") %>
  #       <% content.with_item(href: "/page/1") { "1" } %>
  #       <% content.with_item(href: "/page/2", active: true) { "2" } %>
  #       <% content.with_item(href: "/page/3") { "3" } %>
  #       <% content.with_ellipse %>
  #       <% content.with_next_page(href: "/page/3") %>
  #     <% end %>
  #   <% end %>
  #
  # 2. Collection-based API (Kaminari/will_paginate):
  #   <%= render Shadcn::PaginationComponent.new(collection: @posts) %>
  #
  # 3. Pagy-based API:
  #   <%= render Shadcn::PaginationComponent.new(pagy: @pagy) %>
  #
  class PaginationComponent < BaseComponent
    BASE_CLASSES = "mx-auto flex w-full justify-center"

    renders_one :pagination_content, lambda { |**options|
      PaginationContentComponent.new(**options)
    }

    # @param collection [Object, nil] Kaminari or will_paginate collection
    # @param pagy [Object, nil] Pagy object
    # @param url_builder [Proc, nil] Lambda to generate page URLs, receives page number
    # @param window [Integer] Number of pages to show around current page
    def initialize(collection: nil, pagy: nil, url_builder: nil, window: 2, **options)
      super(**options)
      @collection = collection
      @pagy = pagy
      @url_builder = url_builder || ->(page) { "?page=#{page}" }
      @window = window
    end

    def call
      if auto_generate?
        return "" if total_pages <= 1

        content_tag(:nav, auto_generated_content, pagination_attributes)
      else
        content_tag(:nav, build_pagination_content, pagination_attributes)
      end
    end

    private

    def auto_generate?
      @collection.present? || @pagy.present?
    end

    def auto_generated_content
      pagination_data = extract_pagination_data
      series = generate_page_series(pagination_data[:current_page], pagination_data[:total_pages])

      # Build the items for the content component
      items_html = []

      # Previous button
      prev_href = pagination_data[:prev_page] ? @url_builder.call(pagination_data[:prev_page]) : nil
      items_html << PaginationPreviousComponent.new(href: prev_href, disabled: pagination_data[:prev_page].nil?).render_in(view_context)

      # Page items
      series.each do |item|
        case item
        when :gap
          items_html << PaginationEllipsisComponent.new.render_in(view_context)
        when Integer
          items_html << PaginationItemComponent.new(href: @url_builder.call(item)).render_in(view_context) { item.to_s }
        when String # Current page (string format)
          page_num = item.to_i
          items_html << PaginationItemComponent.new(href: @url_builder.call(page_num), active: true).render_in(view_context) { item }
        end
      end

      # Next button
      next_href = pagination_data[:next_page] ? @url_builder.call(pagination_data[:next_page]) : nil
      items_html << PaginationNextComponent.new(href: next_href, disabled: pagination_data[:next_page].nil?).render_in(view_context)

      content_tag(:ul, safe_join(items_html), class: "flex flex-row items-center gap-1")
    end

    def extract_pagination_data
      obj = @pagy || @collection

      # Pagy detection
      if defined?(::Pagy) && obj.is_a?(::Pagy)
        {
          current_page: obj.page,
          total_pages: obj.pages,
          prev_page: obj.prev,
          next_page: obj.next
        }
      # Duck typing for Pagy-like objects
      elsif obj.respond_to?(:page) && obj.respond_to?(:pages) && obj.respond_to?(:prev) && obj.respond_to?(:next)
        {
          current_page: obj.page,
          total_pages: obj.pages,
          prev_page: obj.prev,
          next_page: obj.next
        }
      # Kaminari detection
      elsif obj.respond_to?(:current_page) && obj.respond_to?(:total_pages) && obj.respond_to?(:prev_page)
        {
          current_page: obj.current_page,
          total_pages: obj.total_pages,
          prev_page: obj.prev_page,
          next_page: obj.next_page
        }
      # will_paginate detection
      elsif obj.respond_to?(:current_page) && obj.respond_to?(:total_pages) && obj.respond_to?(:previous_page)
        {
          current_page: obj.current_page,
          total_pages: obj.total_pages,
          prev_page: obj.previous_page,
          next_page: obj.next_page
        }
      # Generic fallback
      elsif obj.respond_to?(:current_page) && obj.respond_to?(:total_pages)
        current = obj.current_page
        total = obj.total_pages
        {
          current_page: current,
          total_pages: total,
          prev_page: current > 1 ? current - 1 : nil,
          next_page: current < total ? current + 1 : nil
        }
      else
        raise ArgumentError, "Expected a paginated collection (Kaminari/will_paginate) or Pagy object"
      end
    end

    def total_pages
      extract_pagination_data[:total_pages]
    end

    def generate_page_series(current_page, total_pages)
      return [current_page.to_s] if total_pages <= 1

      series = []

      # Always include first page
      series << (current_page == 1 ? "1" : 1)

      # Calculate range around current page
      range_start = [2, current_page - @window].max
      range_end = [total_pages - 1, current_page + @window].min

      # Add gap before range if needed
      series << :gap if range_start > 2

      # Add pages in range
      (range_start..range_end).each do |page|
        next if page == 1 || page == total_pages

        series << (page == current_page ? page.to_s : page)
      end

      # Add gap after range if needed
      series << :gap if range_end < total_pages - 1

      # Always include last page if more than 1 page
      if total_pages > 1
        series << (current_page == total_pages ? total_pages.to_s : total_pages)
      end

      series
    end

    def build_pagination_content
      pagination_content || ""
    end

    def pagination_attributes
      attrs = {
        role: "navigation",
        "aria-label": "pagination",
        class: merge_classes(BASE_CLASSES)
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
