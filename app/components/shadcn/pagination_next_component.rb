# frozen_string_literal: true

module Shadcn
  # Pagination Next button
  class PaginationNextComponent < BaseComponent
    BASE_CLASSES = "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 hover:bg-accent hover:text-accent-foreground h-9 px-4 py-2 gap-1 pr-2.5"

    def initialize(href: nil, disabled: false, **options)
      super(**options)
      @href = href
      @disabled = disabled
    end

    def call
      content_tag(:li) do
        link_content
      end
    end

    private

    def link_content
      inner = safe_join(["Next", chevron_right])

      if @href && !@disabled
        content_tag(:a, inner, href: @href, class: merge_classes(BASE_CLASSES), "aria-label": "Go to next page")
      else
        content_tag(:span, inner, class: cn(merge_classes(BASE_CLASSES), "pointer-events-none opacity-50"), "aria-disabled": "true")
      end
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
        class: "h-4 w-4"
      )
    end
  end
end
