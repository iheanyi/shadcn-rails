# frozen_string_literal: true

module Shadcn
  # Alert Dialog Footer component
  class AlertDialogFooterComponent < BaseComponent
    BASE_CLASSES = "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2"

    renders_one :cancel, lambda { |**options|
      AlertDialogCancelComponent.new(**options)
    }
    renders_one :action, lambda { |**options|
      AlertDialogActionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([cancel, action, content].compact), class: merge_classes(BASE_CLASSES))
    end
  end
end
