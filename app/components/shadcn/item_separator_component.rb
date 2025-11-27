# frozen_string_literal: true

module Shadcn
  # Item Separator component - visual divider between items
  class ItemSeparatorComponent < BaseComponent
    BASE_CLASSES = "shrink-0 bg-border h-[1px] w-full"

    def call
      content_tag(:div, "", class: merge_classes(BASE_CLASSES), role: "separator", **html_options.merge(build_data))
    end
  end
end
