# frozen_string_literal: true

module Shadcn
  # Command List component - container for command groups and items
  class CommandListComponent < BaseComponent
    BASE_CLASSES = "max-h-[300px] overflow-y-auto overflow-x-hidden"

    # Empty state slot
    renders_one :empty, lambda { |**options|
      CommandEmptyComponent.new(**options)
    }

    # Groups of items
    renders_many :groups, lambda { |heading: nil, **options|
      CommandGroupComponent.new(heading: heading, **options)
    }

    # Direct items (without group)
    renders_many :items, lambda { |value: nil, disabled: false, **options|
      CommandItemComponent.new(value: value, disabled: disabled, **options)
    }

    # Separators
    renders_many :separators, lambda { |**options|
      CommandSeparatorComponent.new(**options)
    }

    def call
      content_tag(:div, list_content, class: merge_classes(BASE_CLASSES), data: { "shadcn--command-target": "list" }, **html_options.merge(build_data))
    end

    private

    def list_content
      safe_join([empty, groups, items, separators, content].flatten.compact)
    end
  end
end
