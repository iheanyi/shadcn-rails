# frozen_string_literal: true

module Shadcn
  # Dropdown Menu Label component
  class DropdownMenuLabelComponent < BaseComponent
    BASE_CLASSES = "px-2 py-1.5 text-sm font-medium data-[inset]:pl-8"

    # @param inset [Boolean] Whether to add left padding
    def initialize(inset: false, **options, &block)
      super(**options, &block)
      @inset = inset
    end

    def call
      content_tag(:div, content, **merge_html_attributes({
        class: cn(BASE_CLASSES, class_name),
        "data-slot": "dropdown-menu-label",
        "data-inset": @inset ? "" : nil
      }))
    end
  end
end
