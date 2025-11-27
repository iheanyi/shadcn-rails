# frozen_string_literal: true

module Shadcn
  # Command Separator component - visual divider between groups
  class CommandSeparatorComponent < BaseComponent
    BASE_CLASSES = "-mx-1 h-px bg-border"

    def call
      content_tag(:div, "", class: merge_classes(BASE_CLASSES), role: "separator", **html_options.merge(build_data))
    end
  end
end
