# frozen_string_literal: true

module Shadcn
  # SidebarGroup component - groups related sidebar items
  class SidebarGroupComponent < BaseComponent
    BASE_CLASSES = "relative flex w-full min-w-0 flex-col p-2"

    renders_one :label, lambda { |**options|
      SidebarGroupLabelComponent.new(**options)
    }
    renders_one :action, lambda { |**options|
      SidebarGroupActionComponent.new(**options)
    }
    renders_one :group_content, lambda { |**options|
      SidebarGroupContentComponent.new(**options)
    }

    def call
      content_tag(:div, group_content_structure, group_attributes)
    end

    private

    def group_content_structure
      safe_join([label, action, group_content, content].compact)
    end

    def group_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        "data-sidebar": "group"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
