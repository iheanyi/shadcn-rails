# frozen_string_literal: true

module Shadcn
  # Item Description component
  class ItemDescriptionComponent < BaseComponent
    BASE_CLASSES = "line-clamp-2 text-sm leading-normal font-normal text-balance text-muted-foreground [&>a]:underline [&>a]:underline-offset-4 [&>a:hover]:text-primary"

    def call
      content_tag(:p, content, class: merge_classes(BASE_CLASSES), **merge_html_attributes({}, slot: "item-description"))
    end
  end
end
