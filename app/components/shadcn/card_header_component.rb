# frozen_string_literal: true

module Shadcn
  # Card Header component
  class CardHeaderComponent < BaseComponent
    BASE_CLASSES = "flex flex-col space-y-1.5 p-6"

    renders_one :title, lambda { |**options|
      CardTitleComponent.new(**options)
    }

    renders_one :description, lambda { |**options|
      CardDescriptionComponent.new(**options)
    }

    renders_one :action, "CardActionComponent"

    def call
      content_tag(:div, class: merge_classes(BASE_CLASSES), **html_options) do
        safe_join([title, description, action, content].compact)
      end
    end
  end
end
