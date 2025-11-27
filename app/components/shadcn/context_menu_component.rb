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

    private

    def context_menu_classes
      cn("relative inline-block", class_name)
    end

    def context_menu_data_attrs
      {
        controller: "shadcn--context-menu",
        action: "keydown.escape->shadcn--context-menu#close"
      }
    end
  end
end
