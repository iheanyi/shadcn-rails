# frozen_string_literal: true

module Shadcn
  # Pagination component for navigating paged content
  # Matches shadcn/ui Pagination component
  #
  # @example Basic pagination
  #   <%= render Shadcn::PaginationComponent.new do |pagination| %>
  #     <% pagination.with_pagination_content do |content| %>
  #       <% content.with_previous(href: "/page/1") %>
  #       <% content.with_item(href: "/page/1") { "1" } %>
  #       <% content.with_item(href: "/page/2", active: true) { "2" } %>
  #       <% content.with_item(href: "/page/3") { "3" } %>
  #       <% content.with_ellipsis %>
  #       <% content.with_next(href: "/page/3") %>
  #     <% end %>
  #   <% end %>
  #
  class PaginationComponent < BaseComponent
    BASE_CLASSES = "mx-auto flex w-full justify-center"

    renders_one :pagination_content, lambda { |**options|
      PaginationContentComponent.new(**options)
    }

    def call
      content_tag(:nav, build_pagination_content, pagination_attributes)
    end

    private

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
