# frozen_string_literal: true

module Shadcn
  # SidebarMenuSkeleton component - loading skeleton for menu item
  class SidebarMenuSkeletonComponent < BaseComponent
    BASE_CLASSES = "flex h-8 items-center gap-2 rounded-md px-2"

    def initialize(show_icon: false, **options)
      super(**options)
      @show_icon = show_icon
    end

    def call
      content_tag(:div, skeleton_content, skeleton_attributes)
    end

    private

    def skeleton_content
      safe_join([
        @show_icon ? icon_skeleton : nil,
        text_skeleton
      ].compact)
    end

    def icon_skeleton
      content_tag(:span, "", class: "size-4 rounded-md bg-sidebar-accent animate-pulse")
    end

    def text_skeleton
      # Random width between 60-80%
      width = rand(60..80)
      content_tag(:span, "", class: "h-4 flex-1 bg-sidebar-accent animate-pulse rounded-md", style: "max-width: #{width}%")
    end

    def skeleton_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        "data-sidebar": "menu-skeleton",
        "data-slot": "sidebar-menu-skeleton"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
