# frozen_string_literal: true

module Shadcn
  # Menubar Radio Group component
  # Group of mutually exclusive radio items
  class MenubarRadioGroupComponent < BaseComponent
    renders_many :items, lambda { |**options, &block|
      MenubarRadioItemComponent.new(**options, &block)
    }

    # @param value [String] Currently selected value
    def initialize(value: nil, **options, &block)
      super(**options, &block)
      @value = value
    end

    def call
      content_tag(:div, group_content, group_attributes)
    end

    private

    def group_content
      if items.any?
        safe_join(items)
      else
        content
      end
    end

    def group_attributes
      attrs = {
        class: class_name,
        role: "group",
        "data-value": @value
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
