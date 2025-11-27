# frozen_string_literal: true

module Shadcn
  # SidebarMenuSubButton component - button within submenu item
  class SidebarMenuSubButtonComponent < BaseComponent
    SIZES = {
      sm: "text-xs",
      md: "text-sm"
    }.freeze

    BASE_CLASSES = "flex h-7 min-w-0 -translate-x-px items-center gap-2 overflow-hidden rounded-md px-2 text-sidebar-foreground outline-none ring-sidebar-ring hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 active:bg-sidebar-accent active:text-sidebar-accent-foreground disabled:pointer-events-none disabled:opacity-50 aria-disabled:pointer-events-none aria-disabled:opacity-50 [&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0 [&>svg]:text-sidebar-accent-foreground"
    ACTIVE_CLASSES = "data-[active=true]:bg-sidebar-accent data-[active=true]:text-sidebar-accent-foreground"

    def initialize(size: :md, is_active: false, href: nil, **options)
      super(**options)
      @size = size.to_sym
      @is_active = is_active
      @href = href
    end

    def call
      if @href
        content_tag(:a, content, button_attributes.merge(href: @href))
      else
        content_tag(:button, content, button_attributes.merge(type: "button"))
      end
    end

    private

    def button_attributes
      attrs = {
        class: cn(BASE_CLASSES, ACTIVE_CLASSES, SIZES[@size], class_name),
        "data-sidebar": "menu-sub-button",
        "data-size": @size,
        "data-active": @is_active
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
