# frozen_string_literal: true

module Shadcn
  # Tabs component for tabbed interfaces
  # Matches shadcn/ui Tabs component
  # Uses Stimulus for interactivity
  #
  # @example Basic tabs
  #   <%= render Shadcn::TabsComponent.new(default_value: "account") do |tabs| %>
  #     <% tabs.with_list do |list| %>
  #       <% list.with_trigger(value: "account") { "Account" } %>
  #       <% list.with_trigger(value: "password") { "Password" } %>
  #     <% end %>
  #     <% tabs.with_panel(value: "account") do %>
  #       Account settings content
  #     <% end %>
  #     <% tabs.with_panel(value: "password") do %>
  #       Password settings content
  #     <% end %>
  #   <% end %>
  #
  class TabsComponent < BaseComponent
    renders_one :list, lambda { |**options|
      TabsListComponent.new(**options)
    }
    renders_many :panels, lambda { |value:, **options, &block|
      TabsContentComponent.new(value: value, **options, &block)
    }

    # @param default_value [String] The value of the initially active tab
    # @param orientation [Symbol] Orientation (:horizontal, :vertical)
    def initialize(default_value: nil, orientation: :horizontal, **options)
      super(**options)
      @default_value = default_value
      @orientation = orientation
    end

    def call
      content_tag(:div, tabs_content, tabs_attributes)
    end

    private

    def tabs_content
      safe_join([list, panels, content].compact.flatten)
    end

    def tabs_attributes
      attrs = {
        class: class_name,
        "data-controller": "shadcn--tabs",
        "data-shadcn--tabs-default-value": @default_value,
        "data-orientation": @orientation.to_s
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
