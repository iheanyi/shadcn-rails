# frozen_string_literal: true

module Shadcn
  # Pagination Item component - wrapper for links
  class PaginationItemComponent < BaseComponent
    def initialize(href: nil, active: false, disabled: false, **options)
      super(**options)
      @href = href
      @active = active
      @disabled = disabled
    end

    def call
      content_tag(:li, "data-slot": "pagination-item") do
        link_element
      end
    end

    private

    def link_element
      classes = link_classes

      if @href && !@disabled
        content_tag(:a, content, link_attributes(classes))
      else
        content_tag(:span, content, span_attributes(classes))
      end
    end

    def link_classes
      variant = @active ? :outline : :ghost

      merge_classes(cn(
        ButtonComponent::BASE_CLASSES,
        ButtonComponent::VARIANTS.fetch(variant),
        ButtonComponent::SIZES.fetch(:icon)
      ))
    end

    def link_attributes(classes)
      merge_html_attributes({
        href: @href,
        class: classes,
        "aria-current": @active ? "page" : nil
      }, link_data).compact
    end

    def span_attributes(classes)
      merge_html_attributes({
        class: classes,
        "aria-current": @active ? "page" : nil,
        "aria-disabled": @disabled ? "true" : nil
      }, link_data).compact
    end

    def link_data
      {
        slot: "pagination-link",
        active: @active ? true : nil
      }
    end
  end
end
