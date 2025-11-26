# frozen_string_literal: true

module Shadcn
  # Tabs Content component
  class TabsContentComponent < BaseComponent
    BASE_CLASSES = "mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"

    # @param value [String] The value that identifies this tab panel
    def initialize(value:, **options)
      super(**options)
      @value = value
    end

    def call
      content_tag(:div, content, content_attributes)
    end

    private

    def content_attributes
      {
        class: merge_classes(BASE_CLASSES),
        role: "tabpanel",
        "data-shadcn--tabs-target": "content",
        "data-value": @value,
        "data-state": "inactive",
        hidden: true,
        tabindex: "0"
      }
    end
  end
end
