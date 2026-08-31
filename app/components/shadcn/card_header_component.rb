# frozen_string_literal: true

module Shadcn
  # Card Header component
  class CardHeaderComponent < BaseComponent
    BASE_CLASSES = "@container/card-header grid auto-rows-min grid-rows-[auto_auto] items-start gap-2 px-6 has-data-[slot=card-action]:grid-cols-[1fr_auto] [.border-b]:pb-6"

    renders_one :title, lambda { |**options|
      CardTitleComponent.new(**options)
    }

    renders_one :description, lambda { |**options|
      CardDescriptionComponent.new(**options)
    }

    renders_one :action, "CardActionComponent"

    def call
      content_tag(:div, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "card-header" })) do
        safe_join([title, description, action, content].compact)
      end
    end
  end
end
