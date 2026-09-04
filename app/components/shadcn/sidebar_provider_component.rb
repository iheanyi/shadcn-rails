# frozen_string_literal: true

module Shadcn
  # SidebarProvider component - wrapper that provides sidebar context and state
  class SidebarProviderComponent < BaseComponent
    BASE_CLASSES = "group/sidebar-wrapper flex min-h-svh w-full has-data-[variant=inset]:bg-sidebar"

    renders_one :sidebar, lambda { |**options|
      SidebarComponent.new(**options)
    }
    renders_one :inset, lambda { |**options|
      SidebarInsetComponent.new(**options)
    }

    def initialize(default_open: true, open: nil, keyboard_shortcut: "b", **options)
      super(**options)
      @default_open = default_open
      @open = open
      @keyboard_shortcut = keyboard_shortcut
    end

    def call
      content_tag(:div, provider_content, provider_attributes)
    end

    private

    def provider_content
      safe_join([sidebar, inset, content].compact)
    end

    def provider_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        style: sidebar_style,
        "data-slot": "sidebar-wrapper",
        "data-controller": "shadcn--sidebar",
        "data-shadcn--sidebar-open-value": initial_open_state,
        "data-shadcn--sidebar-keyboard-shortcut-value": @keyboard_shortcut
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end

    def sidebar_style
      [
        "--sidebar-width: 16rem",
        "--sidebar-width-icon: 3rem"
      ].join("; ")
    end

    def initial_open_state
      # Use explicit open prop if provided, otherwise use default_open
      @open.nil? ? @default_open : @open
    end
  end
end
