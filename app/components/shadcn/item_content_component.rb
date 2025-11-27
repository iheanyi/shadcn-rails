# frozen_string_literal: true

module Shadcn
  # Item Content component - wrapper for title and description
  class ItemContentComponent < BaseComponent
    BASE_CLASSES = "flex-1 min-w-0 space-y-1"

    # Title slot
    renders_one :title, lambda { |**options|
      ItemTitleComponent.new(**options)
    }

    # Description slot
    renders_one :description, lambda { |**options|
      ItemDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data)) do
        safe_join([title, description, content].compact)
      end
    end
  end
end
