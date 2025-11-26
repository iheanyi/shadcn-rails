# frozen_string_literal: true

module Shadcn
  # Toast Action component
  class ToastActionComponent < BaseComponent
    BASE_CLASSES = "inline-flex h-8 shrink-0 items-center justify-center rounded-md border bg-transparent px-3 text-sm font-medium transition-colors hover:bg-secondary focus:outline-none focus:ring-1 focus:ring-ring disabled:pointer-events-none disabled:opacity-50 group-[.destructive]:border-muted/40 group-[.destructive]:hover:border-destructive/30 group-[.destructive]:hover:bg-destructive group-[.destructive]:hover:text-destructive-foreground group-[.destructive]:focus:ring-destructive"

    # @param alt_text [String] Alternative text for accessibility
    def initialize(alt_text:, **options, &block)
      super(**options, &block)
      @alt_text = alt_text
    end

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), "aria-label": @alt_text)
    end
  end
end
