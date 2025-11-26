# frozen_string_literal: true

module Shadcn
  # Dropdown Menu Shortcut component
  class DropdownMenuShortcutComponent < BaseComponent
    BASE_CLASSES = "ml-auto text-xs tracking-widest opacity-60"

    def call
      content_tag(:span, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
