# frozen_string_literal: true

module Shadcn
  # Breadcrumb component for navigation hierarchy
  # Matches shadcn/ui Breadcrumb component
  #
  # @example Basic usage
  #   <%= render Shadcn::BreadcrumbComponent.new do |breadcrumb| %>
  #     <% breadcrumb.with_item(href: "/") { "Home" } %>
  #     <% breadcrumb.with_item(href: "/products") { "Products" } %>
  #     <% breadcrumb.with_item(current: true) { "Widget" } %>
  #   <% end %>
  #
  class BreadcrumbComponent < BaseComponent
    renders_many :items, ->(href: nil, current: false, **options, &block) do
      BreadcrumbItemComponent.new(
        href: href,
        current: current,
        **options,
        &block
      )
    end

    private

    def breadcrumb_attributes
      merge_html_attributes({
        "aria-label": "breadcrumb",
        class: breadcrumb_classes,
        "data-slot": "breadcrumb"
      })
    end

    def breadcrumb_classes
      merge_classes("")
    end

    def breadcrumb_list_attributes
      {
        class: "flex flex-wrap items-center gap-1.5 text-sm break-words text-muted-foreground sm:gap-2.5",
        "data-slot": "breadcrumb-list"
      }
    end

    def breadcrumb_list_content
      safe_join(items_with_separators)
    end

    def items_with_separators
      items.each_with_index.flat_map do |item, index|
        result = [content_tag(:li, class: "inline-flex items-center gap-1.5", data: { slot: "breadcrumb-item" }) { item.to_s }]
        result << separator unless index == items.length - 1
        result
      end
    end

    def separator
      content_tag(:li, role: "presentation", "aria-hidden": "true", class: "[&>svg]:size-3.5", data: { slot: "breadcrumb-separator" }) do
        content_tag(:svg,
          content_tag(:path, nil, d: "m9 18 6-6-6-6"),
          xmlns: "http://www.w3.org/2000/svg",
          width: "16",
          height: "16",
          viewBox: "0 0 24 24",
          fill: "none",
          stroke: "currentColor",
          "stroke-width": "2",
          "stroke-linecap": "round",
          "stroke-linejoin": "round"
        )
      end
    end
  end
end
