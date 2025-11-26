# frozen_string_literal: true

module Shadcn
  # Dialog Header component
  class DialogHeaderComponent < BaseComponent
    BASE_CLASSES = "flex flex-col space-y-1.5 text-center sm:text-left"

    renders_one :title, lambda { |**options|
      DialogTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      DialogDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([title, description, content].compact), class: merge_classes(BASE_CLASSES))
    end
  end
end
