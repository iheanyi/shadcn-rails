# frozen_string_literal: true

module Shadcn
  # Empty Header component - wraps media, title, and description
  class EmptyHeaderComponent < BaseComponent
    BASE_CLASSES = "flex flex-col items-center gap-2"

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
      content_tag(:div, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data)) do
        safe_join([media, title, description, content].compact)
      end
    end
  end
end
