# frozen_string_literal: true

module Shadcn
  # Alert Dialog Header component
  class AlertDialogHeaderComponent < BaseComponent
    BASE_CLASSES = "flex flex-col space-y-2 text-center sm:text-left"

    renders_one :title, lambda { |**options|
      AlertDialogTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      AlertDialogDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([title, description, content].compact), class: merge_classes(BASE_CLASSES))
    end
  end
end
