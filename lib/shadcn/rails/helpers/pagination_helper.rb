# frozen_string_literal: true

module Shadcn
  module Rails
    module Helpers
      # Helper methods for integrating with popular Rails pagination gems
      # Supports: will_paginate, Kaminari, and Pagy
      module PaginationHelper
        extend ActiveSupport::Concern

        # Render a shadcn pagination component from a paginated collection or Pagy object
        #
        # @param collection_or_pagy [Object] A paginated collection (Kaminari/will_paginate) or Pagy object
        # @param pagy [Pagy, nil] Optional Pagy object (for explicit pagy usage)
        # @param url_builder [Proc, nil] Lambda/Proc to generate page URLs, receives page number
        # @param window [Integer] Number of pages to show around current page (default: 2)
        # @param options [Hash] Additional options passed to PaginationComponent
        #
        # @example With Kaminari
        #   <%= shadcn_paginate @users %>
        #
        # @example With will_paginate
        #   <%= shadcn_paginate @posts %>
        #
        # @example With Pagy
        #   <%= shadcn_paginate @pagy %>
        #
        # @example With custom URL builder
        #   <%= shadcn_paginate @posts, url_builder: ->(page) { posts_path(page: page, sort: params[:sort]) } %>
        #
        def shadcn_paginate(collection_or_pagy, pagy: nil, url_builder: nil, window: 2, **options)
          pagination_data = extract_pagination_data(collection_or_pagy, pagy: pagy)
          return nil if pagination_data[:total_pages] <= 1

          url_builder ||= default_url_builder
          series = generate_page_series(
            pagination_data[:current_page],
            pagination_data[:total_pages],
            window: window
          )

          render Shadcn::PaginationComponent.new(**options) do |pagination|
            pagination.with_pagination_content do |content|
              # Previous button
              prev_href = pagination_data[:prev_page] ? url_builder.call(pagination_data[:prev_page]) : nil
              content.with_previous(href: prev_href, disabled: pagination_data[:prev_page].nil?)

              # Page items
              series.each do |item|
                case item
                when :gap
                  content.with_ellipse
                when Integer
                  content.with_item(href: url_builder.call(item)) { item.to_s }
                when String # Current page (string format)
                  page_num = item.to_i
                  content.with_item(href: url_builder.call(page_num), active: true) { item }
                end
              end

              # Next button
              next_href = pagination_data[:next_page] ? url_builder.call(pagination_data[:next_page]) : nil
              content.with_next_page(href: next_href, disabled: pagination_data[:next_page].nil?)
            end
          end
        end

        private

        # Extract pagination data from various sources
        # Returns a hash with :current_page, :total_pages, :prev_page, :next_page
        def extract_pagination_data(collection_or_pagy, pagy: nil)
          obj = pagy || collection_or_pagy

          # Pagy detection (has .page and .pages methods, or is a Pagy instance)
          if defined?(::Pagy) && obj.is_a?(::Pagy)
            {
              current_page: obj.page,
              total_pages: obj.pages,
              prev_page: obj.prev,
              next_page: obj.next
            }
          # Duck typing for Pagy-like objects (has .page and .pages)
          elsif obj.respond_to?(:page) && obj.respond_to?(:pages) && obj.respond_to?(:prev) && obj.respond_to?(:next)
            {
              current_page: obj.page,
              total_pages: obj.pages,
              prev_page: obj.prev,
              next_page: obj.next
            }
          # Kaminari detection (has current_page and total_pages, with prev_page)
          elsif obj.respond_to?(:current_page) && obj.respond_to?(:total_pages) && obj.respond_to?(:prev_page)
            {
              current_page: obj.current_page,
              total_pages: obj.total_pages,
              prev_page: obj.prev_page,
              next_page: obj.next_page
            }
          # will_paginate detection (has current_page and total_pages, with previous_page)
          elsif obj.respond_to?(:current_page) && obj.respond_to?(:total_pages) && obj.respond_to?(:previous_page)
            {
              current_page: obj.current_page,
              total_pages: obj.total_pages,
              prev_page: obj.previous_page,
              next_page: obj.next_page
            }
          # Generic fallback for collections with current_page and total_pages
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
            raise ArgumentError, "Expected a paginated collection (Kaminari/will_paginate) or Pagy object. " \
                                 "Object must respond to current_page/total_pages or page/pages."
          end
        end

        # Generate an array of page numbers with gaps
        # Current page is returned as a String, others as Integers, gaps as :gap
        #
        # @example generate_page_series(5, 10, window: 2)
        #   => [1, :gap, 3, 4, "5", 6, 7, :gap, 10]
        def generate_page_series(current_page, total_pages, window: 2)
          return [(current_page.to_s)] if total_pages <= 1

          series = []

          # Always include first page
          series << 1

          # Calculate range around current page
          range_start = [2, current_page - window].max
          range_end = [total_pages - 1, current_page + window].min

          # Add gap before range if needed
          if range_start > 2
            series << :gap
          elsif range_start == 2
            # No gap needed, just add page 2
          end

          # Add pages in range (including potential page 2 if range_start is 2)
          (range_start..range_end).each do |page|
            next if page == 1 || page == total_pages # Skip first and last (added separately)

            if page == current_page
              series << page.to_s
            else
              series << page
            end
          end

          # Add gap after range if needed
          if range_end < total_pages - 1
            series << :gap
          end

          # Always include last page if more than 1 page
          if total_pages > 1
            if current_page == total_pages
              series << total_pages.to_s
            else
              series << total_pages
            end
          end

          # Handle current page being 1 or total_pages
          if current_page == 1
            series[0] = "1"
          end

          series
        end

        # Default URL builder using query params
        def default_url_builder
          ->(page) { "?page=#{page}" }
        end
      end
    end
  end
end
