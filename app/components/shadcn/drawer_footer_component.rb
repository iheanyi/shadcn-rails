# frozen_string_literal: true

module Shadcn
  # Drawer Footer component
  class DrawerFooterComponent < BaseComponent
    BASE_CLASSES = "mt-auto flex flex-col gap-2 p-4"

    def call
      content_tag(:div, content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "drawer-footer" }))
    end
  end
end
