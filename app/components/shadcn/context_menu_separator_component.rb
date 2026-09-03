# frozen_string_literal: true

module Shadcn
  # Context Menu Separator component
  class ContextMenuSeparatorComponent < BaseComponent
    BASE_CLASSES = "-mx-1 my-1 h-px bg-border"

    def call
      content_tag(:div, "", class: merge_classes(BASE_CLASSES), role: "separator")
    end
  end
end
