# frozen_string_literal: true

module Shadcn
  # Context Menu Separator component
  class ContextMenuSeparatorComponent < BaseComponent
    BASE_CLASSES = "-mx-1 my-1 h-px bg-border"

    def call
      content_tag(:div, "", **merge_html_attributes({ class: merge_classes(BASE_CLASSES), role: "separator", "data-slot": "context-menu-separator" }))
    end
  end
end
