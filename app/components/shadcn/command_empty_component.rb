# frozen_string_literal: true

module Shadcn
  # Command Empty component - shown when no results match
  class CommandEmptyComponent < BaseComponent
    BASE_CLASSES = "py-6 text-center text-sm"

    def call
      content_tag(:div, content.presence || "No results found.", class: merge_classes(BASE_CLASSES), data: { "shadcn--command-target": "empty" }, **html_options.merge(build_data))
    end
  end
end
