# frozen_string_literal: true

module Shadcn
  # Command Group component - groups related command items
  class CommandGroupComponent < BaseComponent
    BASE_CLASSES = "overflow-hidden p-1 text-foreground [&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:py-1.5 [&_[cmdk-group-heading]]:text-xs [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group-heading]]:text-muted-foreground"
    HEADING_CLASSES = "px-2 py-1.5 text-xs font-medium text-muted-foreground"

    # Items in this group
    renders_many :items, lambda { |value: nil, disabled: false, **options|
      CommandItemComponent.new(value: value, disabled: disabled, **options)
    }

    # @param heading [String, nil] Optional heading for the group
    def initialize(heading: nil, **options)
      super(**options)
      @heading = heading
    end

    def call
      content_tag(:div, group_content, class: merge_classes(BASE_CLASSES), "data-slot": "command-group", role: "group", data: { "shadcn--command-target": "group" }, **html_options.merge(build_data))
    end

    private

    def group_content
      parts = []
      parts << content_tag(:div, @heading, class: HEADING_CLASSES, "aria-hidden": true) if @heading.present?
      parts << safe_join(items)
      parts << content
      safe_join(parts.compact)
    end
  end
end
