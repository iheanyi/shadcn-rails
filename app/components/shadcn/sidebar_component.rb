# frozen_string_literal: true

module Shadcn
  # Sidebar component for application layouts
  # Matches shadcn/ui Sidebar component
  # A composable, themeable sidebar with collapsible state
  #
  # @example Basic sidebar
  #   <%= render Shadcn::SidebarComponent.new do |sidebar| %>
  #     <% sidebar.with_header do %>
  #       <div class="flex items-center gap-2 px-4">
  #         <span class="font-semibold">App Name</span>
  #       </div>
  #     <% end %>
  #     <% sidebar.with_sidebar_content do |sc| %>
  #       <% sc.with_group do |group| %>
  #         <% group.with_label { "Platform" } %>
  #         <% group.with_group_content do |gc| %>
  #           <% gc.with_menu do |menu| %>
  #             <% menu.with_item do |item| %>
  #               <% item.with_button(href: "/dashboard") do %>
  #                 Dashboard
  #               <% end %>
  #             <% end %>
  #           <% end %>
  #         <% end %>
  #       <% end %>
  #     <% end %>
  #     <% sidebar.with_footer do %>
  #       User info here
  #     <% end %>
  #   <% end %>
  #
  class SidebarComponent < BaseComponent
    SIDEBAR_WIDTH = "16rem"
    SIDEBAR_WIDTH_MOBILE = "18rem"
    SIDEBAR_WIDTH_ICON = "3rem"

    SIDES = {
      left: "left",
      right: "right"
    }.freeze

    VARIANTS = {
      sidebar: "sidebar",
      floating: "floating",
      inset: "inset"
    }.freeze

    COLLAPSIBLE_MODES = {
      offcanvas: "offcanvas",
      icon: "icon",
      none: "none"
    }.freeze

    # Slots
    renders_one :header, lambda { |**options|
      SidebarHeaderComponent.new(**options)
    }
    renders_one :sidebar_content, lambda { |**options|
      SidebarContentComponent.new(**options)
    }
    renders_one :footer, lambda { |**options|
      SidebarFooterComponent.new(**options)
    }
    renders_one :rail, lambda { |**options|
      SidebarRailComponent.new(**options)
    }

    # @param side [Symbol] Side to show sidebar (:left, :right)
    # @param variant [Symbol] Visual style (:sidebar, :floating, :inset)
    # @param collapsible [Symbol] Collapse mode (:offcanvas, :icon, :none)
    # @param default_open [Boolean] Whether sidebar starts open
    def initialize(
      side: :left,
      variant: :sidebar,
      collapsible: :offcanvas,
      default_open: true,
      **options
    )
      super(**options)
      @side = side.to_sym
      @variant = variant.to_sym
      @collapsible = collapsible.to_sym
      @default_open = default_open
    end

    def call
      content_tag(:aside, sidebar_wrapper, sidebar_attributes)
    end

    private

    def sidebar_wrapper
      safe_join([
        sidebar_inner
      ].compact)
    end

    def sidebar_inner
      content_tag(:div, inner_content, inner_attributes)
    end

    def inner_content
      safe_join([header, sidebar_content, footer, rail].compact)
    end

    def inner_attributes
      {
        class: cn(
          "flex h-full w-full flex-col bg-sidebar",
          "group-data-[variant=floating]:rounded-lg group-data-[variant=floating]:border group-data-[variant=floating]:border-sidebar-border group-data-[variant=floating]:shadow-sm",
          "group-data-[collapsible=icon]:overflow-hidden"
        ),
        "data-sidebar": "sidebar",
        "data-slot": "sidebar-inner",
        "data-shadcn--sidebar-target": "inner"
      }
    end

    def sidebar_attributes
      attrs = {
        class: cn(sidebar_classes, class_name),
        "data-controller": "shadcn--sidebar",
        "data-side": @side.to_s,
        "data-variant": @variant.to_s,
        "data-collapsible": @collapsible.to_s,
        "data-state": @default_open ? "expanded" : "collapsed",
        "data-slot": "sidebar",
        "data-shadcn--sidebar-open-value": @default_open.to_s,
        "data-shadcn--sidebar-side-value": @side.to_s,
        "data-shadcn--sidebar-variant-value": @variant.to_s,
        "data-shadcn--sidebar-collapsible-value": @collapsible.to_s,
        "data-action": "keydown.ctrl+b@window->shadcn--sidebar#toggle keydown.meta+b@window->shadcn--sidebar#toggle"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end

    def sidebar_classes
      cn(
        # Base styles
        "group peer hidden md:block text-sidebar-foreground",
        # Fixed positioning for sidebar variant
        @variant == :sidebar && "fixed inset-y-0 z-10 h-svh",
        # Side-specific positioning
        @side == :left && "left-0",
        @side == :right && "right-0",
        # Width handling
        "w-(--sidebar-width)",
        # Transition
        "transition-[left,right,width] duration-200 ease-linear",
        # Collapsed state styles
        "group-data-[collapsible=offcanvas]:w-0",
        "group-data-[collapsible=icon]:w-(--sidebar-width-icon)",
        # Variant-specific styles
        variant_classes,
        # Side-specific collapsed offset
        collapsed_offset_classes
      )
    end

    def variant_classes
      case @variant
      when :floating
        "p-2"
      when :inset
        "border-r bg-transparent"
      else
        "border-r"
      end
    end

    def collapsed_offset_classes
      case @side
      when :left
        "group-data-[collapsible=offcanvas]:left-[calc(var(--sidebar-width)*-1)]"
      when :right
        "group-data-[collapsible=offcanvas]:right-[calc(var(--sidebar-width)*-1)]"
      end
    end
  end
end
