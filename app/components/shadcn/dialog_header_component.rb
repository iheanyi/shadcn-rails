# frozen_string_literal: true

module Shadcn
  # Dialog Header component
  class DialogHeaderComponent < BaseComponent
    BASE_CLASSES = "flex flex-col gap-2 text-center sm:text-left"

    renders_one :title, lambda { |**options|
      DialogTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      DialogDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([title, description, content].compact), **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "dialog-header" }))
    end
  end
end
