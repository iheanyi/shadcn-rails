# frozen_string_literal: true

module Shadcn
  # Pagination Ellipsis component
  class PaginationEllipsisComponent < BaseComponent
    BASE_CLASSES = "flex size-9 items-center justify-center"

    def call
      content_tag(:li) do
        content_tag(:span, ellipsis_content, class: merge_classes(BASE_CLASSES), "aria-hidden": "true", "data-slot": "pagination-ellipsis")
      end
    end

    private

    def ellipsis_content
      content_tag(:svg,
        content_tag(:circle, nil, cx: "12", cy: "12", r: "1") +
        content_tag(:circle, nil, cx: "19", cy: "12", r: "1") +
        content_tag(:circle, nil, cx: "5", cy: "12", r: "1"),
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "currentColor",
        class: "size-4"
      ) + content_tag(:span, "More pages", class: "sr-only")
    end
  end
end
