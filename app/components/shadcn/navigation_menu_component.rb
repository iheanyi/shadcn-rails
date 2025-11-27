# frozen_string_literal: true

module Shadcn
  # NavigationMenu component
  # Matches shadcn/ui NavigationMenu component
  # A collection of links for navigating websites
  #
  # @example Basic navigation menu
  #   <%= render Shadcn::NavigationMenuComponent.new do |nav| %>
  #     <% nav.with_list do |list| %>
  #       <% list.with_item do |item| %>
  #         <% item.with_trigger { "Getting Started" } %>
  #         <% item.with_content do %>
  #           <ul class="grid gap-3 p-4 md:w-[400px] lg:w-[500px] lg:grid-cols-[.75fr_1fr]">
  #             <li class="row-span-3">Featured content</li>
  #             <li><a href="#">Introduction</a></li>
  #             <li><a href="#">Installation</a></li>
  #           </ul>
  #         <% end %>
  #       <% end %>
  #       <% list.with_item do |item| %>
  #         <% item.with_link(href: "/docs") { "Documentation" } %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class NavigationMenuComponent < BaseComponent
    BASE_CLASSES = "relative z-10 flex max-w-max flex-1 items-center justify-center"

    renders_one :list, lambda { |**options|
      NavigationMenuListComponent.new(**options)
    }

    private

    def navigation_classes
      cn(BASE_CLASSES, class_name)
    end

    def navigation_content
      safe_join([list, viewport].compact)
    end

    def viewport
      content_tag(:div, viewport_inner, class: "absolute left-0 top-full flex justify-center")
    end

    def viewport_inner
      content_tag(:div, "", viewport_attributes)
    end

    def viewport_attributes
      {
        class: cn(
          "origin-top-center relative mt-1.5 h-[var(--radix-navigation-menu-viewport-height)] w-full overflow-hidden rounded-md border bg-popover text-popover-foreground shadow",
          "data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-90",
          "md:w-[var(--radix-navigation-menu-viewport-width)]"
        ),
        "data-shadcn--navigation-menu-target": "viewport",
        "data-state": "closed",
        hidden: true
      }
    end
  end
end
