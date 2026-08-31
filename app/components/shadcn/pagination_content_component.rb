# frozen_string_literal: true

module Shadcn
  # Pagination Content component - container for items
  # Uses a single polymorphic slot to maintain ordering between items and ellipses
  class PaginationContentComponent < BaseComponent
    BASE_CLASSES = "flex flex-row items-center gap-1"

    renders_one :previous, lambda { |href: nil, disabled: false, **options|
      PaginationPreviousComponent.new(href: href, disabled: disabled, **options)
    }

    renders_one :next_page, lambda { |href: nil, disabled: false, **options|
      PaginationNextComponent.new(href: href, disabled: disabled, **options)
    }

    # Single slot for all page elements (items and ellipses) to maintain order
    renders_many :elements, types: {
      item: {
        renders: lambda { |href: nil, active: false, disabled: false, **options|
          PaginationItemComponent.new(href: href, active: active, disabled: disabled, **options)
        },
        as: :item
      },
      ellipse: {
        renders: lambda { |**options|
          PaginationEllipsisComponent.new(**options)
        },
        as: :ellipse
      }
    }

    def call
      content_tag(:ul, list_content, class: merge_classes(BASE_CLASSES), "data-slot": "pagination-content")
    end

    private

    def list_content
      safe_join([
        previous,
        elements,
        next_page
      ].flatten.compact)
    end
  end
end
