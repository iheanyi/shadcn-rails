# frozen_string_literal: true

module Shadcn
  # Individual breadcrumb item
  class BreadcrumbItemComponent < BaseComponent
    LINK_CLASSES = "transition-colors hover:text-foreground"
    PAGE_CLASSES = "font-normal text-foreground"

    def initialize(href: nil, current: false, class_name: nil, **options)
      super(class_name: class_name, **options)
      @href = href
      @current = current
      @class_name = class_name
    end

    def call
      if @current
        content_tag(:span, item_attributes) do
          content
        end
      else
        content_tag(:a, link_attributes) do
          content
        end
      end
    end

    private

    def item_attributes
      attrs = {
        role: "link",
        class: cn(PAGE_CLASSES, @class_name),
        "aria-current": "page",
        "aria-disabled": "true"
      }
      attrs.merge!(html_options.except(:href))
      attrs.compact
    end

    def link_attributes
      attrs = {
        href: @href,
        class: cn(LINK_CLASSES, @class_name)
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end
end
