# frozen_string_literal: true

module Shadcn
  # Item Group component - container for grouping related items
  class ItemGroupComponent < BaseComponent
    BASE_CLASSES = "flex flex-col"

    # Items in the group
    renders_many :items, lambda { |variant: :default, size: :default, **options|
      ItemComponent.new(variant: variant, size: size, **options)
    }

    # Separators between items
    renders_many :separators, lambda { |**options|
      ItemSeparatorComponent.new(**options)
    }

    def call
      content_tag(:div, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data)) do
        safe_join([items, separators, content].flatten.compact)
      end
    end
  end
end
