# frozen_string_literal: true

module Shadcn
  # Item Separator component - visual divider between items
  class ItemSeparatorComponent < BaseComponent
    # ItemSeparator shares Separator's orientation-aware v4 classes.
    BASE_CLASSES = "my-0"

    def initialize(decorative: false, **options)
      super(**options)
      @decorative = decorative
    end

    def call
      SeparatorComponent.new(
        orientation: :horizontal,
        decorative: @decorative,
        class_name: cn(BASE_CLASSES, class_name),
        data: data,
        **html_options
      ).render_in(view_context)
    end
  end
end
