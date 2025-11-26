# frozen_string_literal: true

module Shadcn
  # Alert Dialog Title component
  class AlertDialogTitleComponent < BaseComponent
    BASE_CLASSES = "text-lg font-semibold"

    def call
      content_tag(:h2, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
