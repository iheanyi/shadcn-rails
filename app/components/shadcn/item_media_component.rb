# frozen_string_literal: true

module Shadcn
  # Item Media component - displays icons, images, or avatars
  class ItemMediaComponent < BaseComponent
    VARIANTS = {
      default: "bg-transparent",
      icon: "size-8 rounded-sm border bg-muted [&_svg:not([class*='size-'])]:size-4",
      image: "size-10 overflow-hidden rounded-sm [&_img]:size-full [&_img]:object-cover"
    }.freeze

    BASE_CLASSES = "flex shrink-0 items-center justify-center gap-2 group-has-[[data-slot=item-description]]/item:translate-y-0.5 group-has-[[data-slot=item-description]]/item:self-start [&_svg]:pointer-events-none"

    # @param variant [Symbol] :default, :icon, or :image
    def initialize(variant: :default, **options)
      super(**options)
      @variant = variant.to_sym
    end

    def call
      content_tag(:div, content, **media_attributes)
    end

    private

    def media_attributes
      merge_html_attributes(
        { class: merge_classes(cn(BASE_CLASSES, VARIANTS[@variant])) },
        slot: "item-media",
        variant: @variant
      )
    end
  end
end
