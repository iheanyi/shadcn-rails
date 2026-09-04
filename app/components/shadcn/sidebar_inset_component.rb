# frozen_string_literal: true

module Shadcn
  # SidebarInset component - main content area next to sidebar
  class SidebarInsetComponent < BaseComponent
    BASE_CLASSES = "relative flex w-full flex-1 flex-col bg-background"
    PEER_CLASSES = "md:peer-data-[variant=inset]:m-2 md:peer-data-[variant=inset]:ml-0 md:peer-data-[variant=inset]:rounded-xl md:peer-data-[variant=inset]:shadow-sm md:peer-data-[variant=inset]:peer-data-[state=collapsed]:ml-2"

    def call
      content_tag(:main, content, inset_attributes)
    end

    private

    def inset_attributes
      attrs = {
        class: cn(BASE_CLASSES, PEER_CLASSES, class_name),
        "data-sidebar": "inset",
        "data-slot": "sidebar-inset"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
