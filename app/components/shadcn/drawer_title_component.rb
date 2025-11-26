# frozen_string_literal: true

module Shadcn
  # Drawer Title component
  class DrawerTitleComponent < BaseComponent
    BASE_CLASSES = "text-lg font-semibold leading-none tracking-tight"

    def call
      content_tag(:h2, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
