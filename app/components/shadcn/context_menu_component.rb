# frozen_string_literal: true

module Shadcn
  # Context Menu component
  # Matches shadcn/ui ContextMenu component
  # Displays a menu when the user right-clicks on an element
  #
  # @example Basic context menu
  #   <%= render Shadcn::ContextMenuComponent.new do |menu| %>
  #     <% menu.with_trigger do %>
  #       <div class="border border-dashed p-8 text-center">
  #         Right click here
  #       </div>
  #     <% end %>
  #     <% menu.with_menu do |content| %>
  #       <% content.with_item(href: "#") { "Back" } %>
  #       <% content.with_item(href: "#", disabled: true) { "Forward" } %>
  #       <% content.with_item(href: "#") { "Reload" } %>
  #       <% content.with_separator %>
  #       <% content.with_item(href: "#") { "Save As..." } %>
  #       <% content.with_item(href: "#") { "Print" } %>
  #     <% end %>
  #   <% end %>
  #
  class ContextMenuComponent < BaseComponent
    renders_one :trigger
    renders_one :menu, lambda { |**options|
      ContextMenuContentComponent.new(**options)
    }

    def call
      content_tag(:div, context_menu_content, context_menu_attributes)
    end

    private

    def context_menu_content
      safe_join([
        trigger_wrapper,
        menu
      ].compact)
    end

    def trigger_wrapper
      return unless trigger

      content_tag(:div, trigger, {
        "data-shadcn--context-menu-target": "trigger",
        "data-action": "contextmenu->shadcn--context-menu#show:prevent"
      })
    end

    def context_menu_attributes
      attrs = {
        class: cn("relative inline-block", class_name),
        "data-controller": "shadcn--context-menu",
        "data-action": "keydown.escape->shadcn--context-menu#close"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
