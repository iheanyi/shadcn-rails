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

    def call
      content_tag(:nav, breadcrumb_attributes) do
        content_tag(:ol, class: "flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground sm:gap-2.5") do
          safe_join(items_with_separators)
        end
      end
    end

    private

    def breadcrumb_attributes
      attrs = {
        "aria-label": "Breadcrumb",
        class: merge_classes("")
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end

    def items_with_separators
      items.each_with_index.flat_map do |item, index|
        result = [content_tag(:li, class: "inline-flex items-center gap-1.5") { item.to_s }]
        result << separator unless index == items.length - 1
        result
      end
    end

    def separator
      content_tag(:li, role: "presentation", "aria-hidden": "true", class: "text-muted-foreground") do
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
          "stroke-linejoin": "round",
          class: "h-3.5 w-3.5"
        )
      end
    end
  end

  # Individual breadcrumb item
  class BreadcrumbItemComponent < BaseComponent
    LINK_CLASSES = "transition-colors hover:text-foreground"
    PAGE_CLASSES = "font-normal text-foreground"

    def initialize(href: nil, current: false, class_name: nil, **options)
      super(class_name: class_name, **options)
      @href = href
      @current = current
      @class_name = class_name
    end

    def call
      if @current
        content_tag(:span, item_attributes) do
          content
        end
      else
        content_tag(:a, link_attributes) do
          content
        end
      end
    end

    private

    def item_attributes
      attrs = {
        role: "link",
        class: cn(PAGE_CLASSES, @class_name),
        "aria-current": "page",
        "aria-disabled": "true"
      }
      attrs.merge!(html_options.except(:href))
      attrs.compact
    end

    def link_attributes
      attrs = {
        href: @href,
        class: cn(LINK_CLASSES, @class_name)
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end
end
