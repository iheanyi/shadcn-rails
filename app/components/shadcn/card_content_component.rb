# frozen_string_literal: true

module Shadcn
  # Card Content component
  class CardContentComponent < BaseComponent
    BASE_CLASSES = "p-6"

    # @param standalone [Boolean] Whether the content is standalone (no header above)
    def initialize(standalone: false, **options, &block)
      super(**options, &block)
      @standalone = standalone
    end

    def call
      classes = @standalone ? BASE_CLASSES : "#{BASE_CLASSES} pt-0"
      content_tag(:div, content, class: merge_classes(classes), **html_options)
    end
  end
end
