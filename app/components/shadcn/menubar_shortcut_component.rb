# frozen_string_literal: true

module Shadcn
  # Menubar Shortcut component
  # Displays keyboard shortcuts next to menu items
  class MenubarShortcutComponent < BaseComponent
    BASE_CLASSES = "ml-auto text-xs tracking-widest text-muted-foreground"

    def call
      content_tag(:span, content, shortcut_attributes)
    end

    private

    def shortcut_attributes
      {
        class: cn(BASE_CLASSES, class_name)
      }
    end
  end
end
