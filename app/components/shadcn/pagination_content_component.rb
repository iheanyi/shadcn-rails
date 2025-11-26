# frozen_string_literal: true

module Shadcn
  # Pagination Content component - container for items
  class PaginationContentComponent < BaseComponent
    BASE_CLASSES = "flex flex-row items-center gap-1"

    renders_many :items, ->(href: nil, active: false, disabled: false, **options, &block) do
      PaginationItemComponent.new(
        href: href,
        active: active,
        disabled: disabled,
        **options,
        &block
      )
    end

    renders_one :previous, lambda { |href: nil, disabled: false, **options|
      PaginationPreviousComponent.new(href: href, disabled: disabled, **options)
    }

    renders_one :next_page, lambda { |href: nil, disabled: false, **options|
      PaginationNextComponent.new(href: href, disabled: disabled, **options)
    }

    renders_many :ellipses, lambda { |**options|
      PaginationEllipsisComponent.new(**options)
    }

    def call
      content_tag(:ul, list_content, class: merge_classes(BASE_CLASSES))
    end

    private

    def list_content
      safe_join([
        previous,
        items.map(&:to_s),
        ellipses.map(&:to_s),
        next_page,
        content
      ].flatten.compact)
    end
  end
end
