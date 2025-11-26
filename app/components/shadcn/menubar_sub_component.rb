# frozen_string_literal: true

module Shadcn
  # Menubar Sub component
  # Creates nested/submenu functionality
  class MenubarSubComponent < BaseComponent
    renders_one :trigger, lambda { |**options, &block|
      MenubarSubTriggerComponent.new(**options, &block)
    }
    renders_one :content, lambda { |**options|
      MenubarSubContentComponent.new(**options)
    }

    def call
      content_tag(:div, sub_content, sub_attributes)
    end

    private

    def sub_content
      safe_join([trigger, content].compact)
    end

    def sub_attributes
      attrs = {
        class: cn("relative", class_name),
        "data-shadcn--menubar-target": "sub"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
