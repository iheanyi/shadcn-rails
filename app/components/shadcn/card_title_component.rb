# frozen_string_literal: true

module Shadcn
  # Card Title component
  class CardTitleComponent < BaseComponent
    BASE_CLASSES = "font-semibold leading-none tracking-tight"

    # @param tag [Symbol] HTML tag to use (default: :h3)
    def initialize(tag: :h3, **options, &block)
      super(**options, &block)
      @tag = tag
    end

    def call
      content_tag(@tag, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end
end
