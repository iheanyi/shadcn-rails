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
  #       <% menu.with_content do |content| %>
  #         <% content.with_item(href: "#") { "New Tab" } %>
  #         <% content.with_item(href: "#") { "New Window" } %>
  #         <% content.with_separator %>
  #         <% content.with_item(href: "#") { "Exit" } %>
  #       <% end %>
  #     <% end %>
  #     <% menubar.with_menu do |menu| %>
  #       <% menu.with_trigger { "Edit" } %>
  #       <% menu.with_content do |content| %>
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

    def call
      content_tag(:div, menubar_content, menubar_attributes)
    end

    private

    def menubar_content
      safe_join(menus)
    end

    def menubar_attributes
      attrs = {
        class: cn(BASE_CLASSES, class_name),
        role: "menubar",
        "data-controller": "shadcn--menubar"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
