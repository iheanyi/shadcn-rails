# frozen_string_literal: true

module Shadcn
  # Menubar Separator component
  # Visual separator between menu items
  class MenubarSeparatorComponent < BaseComponent
    BASE_CLASSES = "-mx-1 my-1 h-px bg-border"

    def call
      content_tag(:div, "", separator_attributes)
    end

    private

    def separator_attributes
      {
        class: cn(BASE_CLASSES, class_name),
        role: "separator",
        "data-slot": "menubar-separator"
      }
    end
  end
end
