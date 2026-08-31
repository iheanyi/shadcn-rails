# frozen_string_literal: true

module Shadcn
  # Menubar component
  # Matches shadcn/ui Menubar component
  # A visually persistent menu common in desktop applications
  #
  # @example Basic menubar
  #   <%= render Shadcn::MenubarComponent.new do |menubar| %>
  #     <% menubar.with_menu do |menu| %>
  #       <% menu.with_trigger { "File" } %>
  #       <% menu.with_menu do |content| %>
  #         <% content.with_item(href: "#") { "New Tab" } %>
  #         <% content.with_item(href: "#") { "New Window" } %>
  #         <% content.with_separator %>
  #         <% content.with_item(href: "#") { "Exit" } %>
  #       <% end %>
  #     <% end %>
  #     <% menubar.with_menu do |menu| %>
  #       <% menu.with_trigger { "Edit" } %>
  #       <% menu.with_menu do |content| %>
  #         <% content.with_item(href: "#") { "Undo" } %>
  #         <% content.with_item(href: "#") { "Redo" } %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class MenubarComponent < BaseComponent
    BASE_CLASSES = "flex h-9 items-center space-x-1 rounded-md border bg-background p-1 shadow-sm"

    renders_many :menus, lambda { |**options|
      MenubarMenuComponent.new(**options)
    }

    private

    def menubar_classes
      cn(BASE_CLASSES, class_name)
    end

    def menubar_content
      safe_join(menus)
    end
  end
end
