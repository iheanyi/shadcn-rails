# frozen_string_literal: true

module Shadcn
  # Dropdown Menu Group component
  class DropdownMenuGroupComponent < BaseComponent
    def call
      content_tag(:div, content, role: "group", **html_options)
    end
  end
end
