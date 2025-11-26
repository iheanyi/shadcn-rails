# frozen_string_literal: true

module Shadcn
  # Menubar Label component
  # Label for grouping menu items
  class MenubarLabelComponent < BaseComponent
    BASE_CLASSES = "px-2 py-1.5 text-sm font-semibold"

    # @param inset [Boolean] Whether to add left padding
    def initialize(inset: false, **options, &block)
      super(**options, &block)
      @inset = inset
    end

    def call
      content_tag(:div, content, label_attributes)
    end

    private

    def label_attributes
      {
        class: cn(BASE_CLASSES, @inset ? "pl-8" : "", class_name)
      }
    end
  end
end
