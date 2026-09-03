# frozen_string_literal: true

module Shadcn
  # Command List component - container for command groups and items
  class CommandListComponent < BaseComponent
    BASE_CLASSES = "max-h-[300px] scroll-py-1 overflow-x-hidden overflow-y-auto"

    # Empty state slot
    renders_one :empty, lambda { |**options|
      CommandEmptyComponent.new(**options)
    }

    # Use polymorphic slots to preserve the order of groups, items, and separators
    renders_many :list_items, types: {
      group: {
        renders: lambda { |heading: nil, **options, &block|
          CommandGroupComponent.new(heading: heading, **options, &block)
        },
        as: :group
      },
      item: {
        renders: lambda { |value: nil, disabled: false, **options, &block|
          CommandItemComponent.new(value: value, disabled: disabled, **options, &block)
        },
        as: :item
      },
      separator: {
        renders: lambda { |**options|
          CommandSeparatorComponent.new(**options)
        },
        as: :separator
      }
    }

    def call
      content_tag(:div, list_content, class: merge_classes(BASE_CLASSES), data: { "shadcn--command-target": "list" }, **html_options.merge(build_data))
    end

    private

    def list_content
      # Trigger slot evaluation first by accessing content
      raw_content = content
      # If polymorphic slots were used, render them in order with empty at the start
      if list_items.any?
        safe_join([empty, list_items].flatten.compact)
      else
        # Otherwise render the raw block content (for backwards compatibility)
        safe_join([empty, raw_content].flatten.compact)
      end
    end
  end
end
