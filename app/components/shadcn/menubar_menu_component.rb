# frozen_string_literal: true

module Shadcn
  # Menubar Menu component
  # Individual menu section within a menubar
  class MenubarMenuComponent < BaseComponent
    renders_one :trigger, lambda { |**options|
      MenubarTriggerComponent.new(**options)
    }
    renders_one :content, lambda { |**options|
      MenubarContentComponent.new(**options)
    }

    def call
      content_tag(:div, menu_content, menu_attributes)
    end

    private

    def menu_content
      safe_join([trigger, content].compact)
    end

    def menu_attributes
      attrs = {
        class: cn("relative", class_name),
        "data-shadcn--menubar-target": "menu"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
