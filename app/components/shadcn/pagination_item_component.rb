# frozen_string_literal: true

module Shadcn
  # Pagination Item component - wrapper for links
  class PaginationItemComponent < BaseComponent
    LINK_CLASSES = "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 hover:bg-accent hover:text-accent-foreground h-9 w-9"
    ACTIVE_CLASSES = "border border-input bg-background shadow-sm"

    def initialize(href: nil, active: false, disabled: false, **options)
      super(**options)
      @href = href
      @active = active
      @disabled = disabled
    end

    def call
      content_tag(:li) do
        link_element
      end
    end

    private

    def link_element
      classes = cn(LINK_CLASSES, @active ? ACTIVE_CLASSES : "", class_name)

      if @href
        content_tag(:a, content, link_attributes(classes))
      else
        content_tag(:span, content, span_attributes(classes))
      end
    end

    def link_attributes(classes)
      attrs = {
        href: @href,
        class: classes,
        "aria-current": @active ? "page" : nil
      }
      attrs.merge!(html_options)
      attrs.compact
    end

    def span_attributes(classes)
      attrs = {
        class: classes,
        "aria-current": @active ? "page" : nil
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end
end
