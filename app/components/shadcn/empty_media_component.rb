# frozen_string_literal: true

module Shadcn
  # Empty Media component - displays icon, image, or avatar
  class EmptyMediaComponent < BaseComponent
    BASE_CLASSES = "mb-2 flex shrink-0 items-center justify-center [&_svg]:pointer-events-none [&_svg]:shrink-0"

    VARIANTS = {
      default: "bg-transparent",
      icon: "flex size-10 shrink-0 items-center justify-center rounded-lg bg-muted text-foreground [&_svg:not([class*='size-'])]:size-6"
    }.freeze

    # @param variant [Symbol] :default or :icon
    def initialize(variant: :default, **options)
      super(**options)
      @variant = variant.to_sym
    end

    def call
      content_tag(
        :div,
        content,
        **merge_html_attributes(
          {
            class: merge_classes(cn(BASE_CLASSES, VARIANTS[@variant])),
            "data-slot": "empty-icon",
            "data-variant": @variant
          }
        )
      )
    end
  end
end
