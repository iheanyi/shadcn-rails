# frozen_string_literal: true

module Shadcn
  # Pagination Next button
  class PaginationNextComponent < BaseComponent
    EXTRA_CLASSES = "gap-1 px-2.5 sm:pr-2.5"

    def initialize(href: nil, disabled: false, **options)
      super(**options)
      @href = href
      @disabled = disabled
    end

    def call
      content_tag(:li, "data-slot": "pagination-item") do
        link_content
      end
    end

    private

    def link_content
      inner = safe_join([content_tag(:span, "Next", class: "hidden sm:block"), chevron_right])

      if @href && !@disabled
        content_tag(:a, inner, link_attributes)
      else
        content_tag(:span, inner, disabled_attributes)
      end
    end

    def link_attributes
      merge_html_attributes({
        href: @href,
        class: link_classes,
        "aria-label": "Go to next page"
      }, slot: "pagination-link").compact
    end

    def disabled_attributes
      merge_html_attributes({
        class: cn(link_classes, "pointer-events-none opacity-50"),
        "aria-label": "Go to next page",
        "aria-disabled": "true"
      }, slot: "pagination-link").compact
    end

    def link_classes
      merge_classes(cn(
        ButtonComponent::BASE_CLASSES,
        ButtonComponent::VARIANTS.fetch(:ghost),
        ButtonComponent::SIZES.fetch(:default),
        EXTRA_CLASSES
      ))
    end

    def chevron_right
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
        class: "size-4"
      )
    end
  end
end
