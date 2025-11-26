# frozen_string_literal: true

module Shadcn
  # Tabs List component
  class TabsListComponent < BaseComponent
    BASE_CLASSES = "inline-flex h-9 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground"

    renders_many :triggers, lambda { |value:, **options, &block|
      TabsTriggerComponent.new(value: value, **options, &block)
    }

    def call
      content_tag(:div, list_content, list_attributes)
    end

    private

    def list_content
      safe_join([triggers, content].compact.flatten)
    end

    def list_attributes
      {
        class: merge_classes(BASE_CLASSES),
        role: "tablist",
        "data-shadcn--tabs-target": "list"
      }
    end
  end
end
