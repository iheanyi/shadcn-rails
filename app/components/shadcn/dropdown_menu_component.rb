# frozen_string_literal: true

module Shadcn
  # Dropdown Menu component
  # Matches shadcn/ui DropdownMenu component
  # Uses Stimulus for interactivity
  #
  # @example Basic dropdown
  #   <%= render Shadcn::DropdownMenuComponent.new do |menu| %>
  #     <% menu.with_trigger do %>
  #       <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Open Menu" } %>
  #     <% end %>
  #     <% menu.with_menu do |content| %>
  #       <% content.with_label { "My Account" } %>
  #       <% content.with_separator %>
  #       <% content.with_item(href: "/profile") { "Profile" } %>
  #       <% content.with_item(href: "/settings") { "Settings" } %>
  #       <% content.with_separator %>
  #       <% content.with_item(variant: :destructive) { "Log out" } %>
  #     <% end %>
  #   <% end %>
  #
  class DropdownMenuComponent < BaseComponent
    renders_one :trigger
    renders_one :menu, lambda { |**options|
      DropdownMenuContentComponent.new(**options)
    }

    # @param open [Boolean] Whether dropdown starts open
    # @param align [Symbol] Content alignment (:start, :center, :end)
    # @param side [Symbol] Side to show content (:top, :right, :bottom, :left)
    def initialize(open: false, align: :end, side: :bottom, **options)
      super(**options)
      @open = open
      @align = align
      @side = side
    end

    private

    def dropdown_classes
      cn("relative inline-block", class_name)
    end

    def dropdown_data_attrs
      {
        controller: "shadcn--dropdown",
        "shadcn--dropdown-open-value": @open.to_s,
        "shadcn--dropdown-align-value": @align.to_s,
        "shadcn--dropdown-side-value": @side.to_s,
        action: "keydown.escape->shadcn--dropdown#close clickOutside->shadcn--dropdown#close"
      }
    end

    def dropdown_attributes
      merge_html_attributes({ class: dropdown_classes }, dropdown_data_attrs)
    end
  end
end
