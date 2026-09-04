# frozen_string_literal: true

module Shadcn
  # SidebarMenuButton component - button/link within menu item
  class SidebarMenuButtonComponent < BaseComponent
    VARIANTS = {
      default: "hover:bg-sidebar-accent hover:text-sidebar-accent-foreground",
      outline: "bg-background shadow-[0_0_0_1px_hsl(var(--sidebar-border))] hover:bg-sidebar-accent hover:text-sidebar-accent-foreground hover:shadow-[0_0_0_1px_hsl(var(--sidebar-accent))]"
    }.freeze

    SIZES = {
      default: "h-8 text-sm",
      sm: "h-7 text-xs",
      lg: "h-12 text-sm group-data-[collapsible=icon]:p-0!"
    }.freeze

    BASE_CLASSES = "peer/menu-button flex w-full items-center gap-2 overflow-hidden rounded-md p-2 text-left text-sm ring-sidebar-ring outline-hidden transition-[width,height,padding] group-has-data-[sidebar=menu-action]/menu-item:pr-8 group-data-[collapsible=icon]:size-8! group-data-[collapsible=icon]:p-2! hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 active:bg-sidebar-accent active:text-sidebar-accent-foreground disabled:pointer-events-none disabled:opacity-50 aria-disabled:pointer-events-none aria-disabled:opacity-50 data-[active=true]:bg-sidebar-accent data-[active=true]:font-medium data-[active=true]:text-sidebar-accent-foreground data-[state=open]:hover:bg-sidebar-accent data-[state=open]:hover:text-sidebar-accent-foreground [&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0"

    def initialize(variant: :default, size: :default, is_active: false, as_child: false, tooltip: nil, href: nil, **options)
      super(**options)
      @variant = variant.to_sym
      @size = size.to_sym
      @is_active = is_active
      @as_child = as_child
      @tooltip = tooltip
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
        class: cn(BASE_CLASSES, VARIANTS[@variant], SIZES[@size], class_name),
        "data-sidebar": "menu-button",
        "data-slot": "sidebar-menu-button",
        "data-size": @size,
        "data-active": @is_active
      }
      attrs[:"data-tooltip"] = @tooltip if @tooltip
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
