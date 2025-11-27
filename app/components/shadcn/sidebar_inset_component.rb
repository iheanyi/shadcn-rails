# frozen_string_literal: true

module Shadcn
  # SidebarInset component - main content area next to sidebar
  class SidebarInsetComponent < BaseComponent
    BASE_CLASSES = "relative flex min-h-svh flex-1 flex-col bg-background"
    PEER_CLASSES = "peer-data-[variant=inset]:min-h-[calc(100svh-theme(spacing.4))] md:peer-data-[variant=inset]:m-2 md:peer-data-[state=collapsed]:peer-data-[variant=inset]:ml-2 md:peer-data-[variant=inset]:ml-0 md:peer-data-[variant=inset]:rounded-xl md:peer-data-[variant=inset]:shadow"

    def call
      content_tag(:main, content, inset_attributes)
    end

    private

    def inset_attributes
      attrs = {
        class: cn(BASE_CLASSES, PEER_CLASSES, class_name),
        "data-sidebar": "inset"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
