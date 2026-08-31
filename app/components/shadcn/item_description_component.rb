# frozen_string_literal: true

module Shadcn
  # Item Description component
  class ItemDescriptionComponent < BaseComponent
    BASE_CLASSES = "line-clamp-2 text-sm leading-normal font-normal text-balance text-muted-foreground [&>a]:underline [&>a]:underline-offset-4 [&>a:hover]:text-primary"

    def call
      content_tag(:p, content, class: description_classes, **merge_html_attributes({}, slot: "item-description"))
    end

    private

    def description_classes
      prefix_classes([BASE_CLASSES, class_name].compact.join(" "))
    end
  end
end
