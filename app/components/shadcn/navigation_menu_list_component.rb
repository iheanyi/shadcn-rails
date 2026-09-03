# frozen_string_literal: true

module Shadcn
  # Container for navigation menu items
  class NavigationMenuListComponent < BaseComponent
    BASE_CLASSES = "group flex flex-1 list-none items-center justify-center gap-1"

    renders_many :items, lambda { |**options|
      NavigationMenuItemComponent.new(**options)
    }

    def call
      content_tag(:ul, list_content, list_attributes)
    end

    private

    def list_content
      safe_join(items)
    end

    def list_attributes
      {
        class: cn(BASE_CLASSES, class_name),
        "data-shadcn--navigation-menu-target": "list"
      }.merge(html_options).compact
    end
  end
end
