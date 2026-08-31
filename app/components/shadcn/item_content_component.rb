# frozen_string_literal: true

module Shadcn
  # Item Content component - wrapper for title and description
  class ItemContentComponent < BaseComponent
    BASE_CLASSES = "flex flex-1 flex-col gap-1 [&+[data-slot=item-content]]:flex-none"

    # Title slot
    renders_one :title, lambda { |**options|
      ItemTitleComponent.new(**options)
    }

    # Description slot
    renders_one :description, lambda { |**options|
      ItemDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, class: merge_classes(BASE_CLASSES), **merge_html_attributes({}, slot: "item-content")) do
        safe_join([title, description, content].compact)
      end
    end
  end
end
