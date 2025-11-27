# frozen_string_literal: true

module Shadcn
  # Item Media component - displays icons, images, or avatars
  class ItemMediaComponent < BaseComponent
    VARIANTS = {
      default: "shrink-0",
      icon: "flex size-10 shrink-0 items-center justify-center rounded-lg bg-muted [&>svg]:size-5 [&>svg]:text-muted-foreground",
      image: "shrink-0 overflow-hidden rounded-lg"
    }.freeze

    # @param variant [Symbol] :default, :icon, or :image
    def initialize(variant: :default, **options)
      super(**options)
      @variant = variant.to_sym
    end

    def call
      content_tag(:div, content, class: merge_classes(VARIANTS[@variant]), **html_options.merge(build_data))
    end
  end
end
