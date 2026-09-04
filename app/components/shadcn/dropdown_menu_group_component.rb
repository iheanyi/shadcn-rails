# frozen_string_literal: true

module Shadcn
  # Dropdown Menu Group component
  class DropdownMenuGroupComponent < BaseComponent
    def call
      content_tag(:div, content, **merge_html_attributes({
        role: "group",
        "data-slot": "dropdown-menu-group"
      }))
    end
  end
end
