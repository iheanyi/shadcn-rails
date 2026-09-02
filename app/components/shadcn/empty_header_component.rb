# frozen_string_literal: true

module Shadcn
  # Empty Header component - wraps media, title, and description
  class EmptyHeaderComponent < BaseComponent
    BASE_CLASSES = "flex max-w-sm flex-col items-center gap-2 text-center"

    # Media slot for icon, image, or avatar
    renders_one :media, lambda { |variant: :default, **options|
      EmptyMediaComponent.new(variant: variant, **options)
    }

    # Title slot
    renders_one :title, lambda { |**options|
      EmptyTitleComponent.new(**options)
    }

    # Description slot
    renders_one :description, lambda { |**options|
      EmptyDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "empty-header" })) do
        safe_join([media, title, description, content].compact)
      end
    end
  end
end
