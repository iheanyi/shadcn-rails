# frozen_string_literal: true

module Shadcn
  # Select Group component
  class SelectGroupComponent < BaseComponent
    LABEL_CLASSES = "px-2 py-1.5 text-sm font-semibold"

    renders_many :items, lambda { |value:, **options, &block|
      SelectItemComponent.new(value: value, **options, &block)
    }

    # @param label [String, nil] Group label
    def initialize(label: nil, **options, &block)
      super(**options, &block)
      @label = label
    end

    def call
      content_tag(:div, group_content, role: "group")
    end

    private

    def group_content
      safe_join([
        (@label ? content_tag(:div, @label, class: LABEL_CLASSES) : nil),
        items,
        content
      ].compact.flatten)
    end
  end
end
