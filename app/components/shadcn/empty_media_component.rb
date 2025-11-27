# frozen_string_literal: true

module Shadcn
  # Empty Media component - displays icon, image, or avatar
  class EmptyMediaComponent < BaseComponent
    VARIANTS = {
      default: "",
      icon: "flex size-12 items-center justify-center rounded-full bg-muted [&>svg]:size-6 [&>svg]:text-muted-foreground"
    }.freeze

    # @param variant [Symbol] :default or :icon
    def initialize(variant: :default, **options)
      super(**options)
      @variant = variant.to_sym
    end

    def call
      content_tag(:div, content, class: merge_classes(VARIANTS[@variant]), **html_options.merge(build_data))
    end
  end
end
