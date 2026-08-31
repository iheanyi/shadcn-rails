# frozen_string_literal: true

module Shadcn
  # Menubar Sub component
  # Creates nested/submenu functionality
  class MenubarSubComponent < BaseComponent
    renders_one :trigger, lambda { |**options, &block|
      MenubarSubTriggerComponent.new(**options, &block)
    }
    # Note: Named content_slot because 'content' is a reserved ViewComponent method
    renders_one :content_slot, lambda { |**options|
      MenubarSubContentComponent.new(**options)
    }

    # Alias for more intuitive API
    alias_method :with_content, :with_content_slot

    def call
      content_tag(:div, sub_content, sub_attributes)
    end

    private

    def sub_content
      safe_join([trigger, content_slot, content].compact)
    end

    def sub_attributes
      attrs = {
        class: cn("relative", class_name),
        "data-slot": "menubar-sub",
        "data-shadcn--menubar-target": "sub"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
