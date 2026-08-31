# frozen_string_literal: true

module Shadcn
  # Alert Dialog Header component
  class AlertDialogHeaderComponent < BaseComponent
    BASE_CLASSES = "grid grid-rows-[auto_1fr] place-items-center gap-1.5 text-center has-data-[slot=alert-dialog-media]:grid-rows-[auto_auto_1fr] has-data-[slot=alert-dialog-media]:gap-x-6 sm:place-items-start sm:text-left sm:has-data-[slot=alert-dialog-media]:grid-rows-[auto_1fr]"

    renders_one :title, lambda { |**options|
      AlertDialogTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      AlertDialogDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([title, description, content].compact), **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "alert-dialog-header" }))
    end
  end
end
