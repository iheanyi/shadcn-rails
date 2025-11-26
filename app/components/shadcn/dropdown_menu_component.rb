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
  #     <% menu.with_content do |content| %>
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

    def call
      content_tag(:div, dropdown_content, dropdown_attributes)
    end

    private

    def dropdown_content
      safe_join([
        trigger_wrapper,
        menu
      ].compact)
    end

    def trigger_wrapper
      return unless trigger

      content_tag(:div, trigger, {
        "data-shadcn--dropdown-target": "trigger",
        "data-action": "click->shadcn--dropdown#toggle"
      })
    end

    def dropdown_attributes
      attrs = {
        class: cn("relative inline-block", class_name),
        "data-controller": "shadcn--dropdown",
        "data-shadcn--dropdown-open-value": @open.to_s,
        "data-shadcn--dropdown-align-value": @align.to_s,
        "data-shadcn--dropdown-side-value": @side.to_s,
        "data-action": "keydown.escape->shadcn--dropdown#close clickOutside->shadcn--dropdown#close"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
