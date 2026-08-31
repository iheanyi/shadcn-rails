# frozen_string_literal: true

module Shadcn
  # Avatar Fallback component for initials or placeholder
  class AvatarFallbackComponent < BaseComponent
    FALLBACK_CLASSES = "flex size-full items-center justify-center rounded-full bg-muted text-sm text-muted-foreground group-data-[size=sm]/avatar:text-xs"

    def initialize(class: nil, **options, &block)
      super(**options, &block)
      @custom_class = binding.local_variable_get(:class)
    end

    def call
      content_tag(
        :span,
        content,
        **merge_html_attributes({
          class: cn(FALLBACK_CLASSES, @custom_class, class_name),
          "data-slot": "avatar-fallback"
        })
      )
    end
  end
end
