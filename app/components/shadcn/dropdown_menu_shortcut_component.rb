# frozen_string_literal: true

module Shadcn
  # Dropdown Menu Shortcut component
  class DropdownMenuShortcutComponent < BaseComponent
    BASE_CLASSES = "ml-auto text-xs tracking-widest text-muted-foreground"

    def call
      content_tag(:span, content, **merge_html_attributes({
        class: merge_classes(BASE_CLASSES),
        "data-slot": "dropdown-menu-shortcut"
      }))
    end
  end
end
