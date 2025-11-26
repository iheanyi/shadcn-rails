# frozen_string_literal: true

module Shadcn
  # Avatar Fallback component for initials or placeholder
  class AvatarFallbackComponent < BaseComponent
    FALLBACK_CLASSES = "flex h-full w-full items-center justify-center rounded-full bg-muted"

    def initialize(class: nil, **options, &block)
      super(**options, &block)
      @custom_class = binding.local_variable_get(:class)
    end

    def call
      content_tag(:span, content, class: cn(FALLBACK_CLASSES, @custom_class))
    end
  end
end
