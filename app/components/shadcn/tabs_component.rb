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
  # @example Tabs with URL sync
  #   <%= render Shadcn::TabsComponent.new(default_value: "account", url_param: "tab") do |tabs| %>
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
  #   # URL will update to ?tab=account or ?tab=password when tabs are clicked
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
    # @param url_param [String, nil] Query parameter name to sync active tab with URL (e.g., "tab")
    def initialize(default_value: nil, orientation: :horizontal, url_param: nil, **options)
      super(**options)
      @default_value = default_value
      @orientation = orientation
      @url_param = url_param
    end

    private

    def tabs_attributes
      merge_html_attributes(
        {
          class: tabs_classes,
          "data-orientation": @orientation
        },
        {
          controller: "shadcn--tabs",
          "shadcn--tabs-default-value-value": @default_value,
          "shadcn--tabs-url-param-value": @url_param
        }
      )
    end

    def tabs_classes
      class_name
    end

    def tabs_content
      safe_join([list, panels, content].compact.flatten)
    end
  end
end
