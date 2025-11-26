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

  # Tabs List component
  class TabsListComponent < BaseComponent
    BASE_CLASSES = "inline-flex h-9 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground"

    renders_many :triggers, lambda { |value:, **options, &block|
      TabsTriggerComponent.new(value: value, **options, &block)
    }

    def call
      content_tag(:div, list_content, list_attributes)
    end

    private

    def list_content
      safe_join([triggers, content].compact.flatten)
    end

    def list_attributes
      {
        class: merge_classes(BASE_CLASSES),
        role: "tablist",
        "data-shadcn--tabs-target": "list"
      }
    end
  end

  # Tabs Trigger component
  class TabsTriggerComponent < BaseComponent
    BASE_CLASSES = "inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow"

    # @param value [String] The value that identifies this tab
    # @param disabled [Boolean] Whether the tab is disabled
    def initialize(value:, disabled: false, **options)
      super(**options)
      @value = value
      @disabled = disabled
    end

    def call
      content_tag(:button, content, trigger_attributes)
    end

    private

    def trigger_attributes
      {
        type: "button",
        role: "tab",
        class: merge_classes(BASE_CLASSES),
        disabled: @disabled || nil,
        "data-shadcn--tabs-target": "trigger",
        "data-value": @value,
        "data-state": "inactive",
        "data-action": "click->shadcn--tabs#selectTab",
        "aria-selected": "false",
        tabindex: "-1"
      }
    end
  end

  # Tabs Content component
  class TabsContentComponent < BaseComponent
    BASE_CLASSES = "mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"

    # @param value [String] The value that identifies this tab panel
    def initialize(value:, **options)
      super(**options)
      @value = value
    end

    def call
      content_tag(:div, content, content_attributes)
    end

    private

    def content_attributes
      {
        class: merge_classes(BASE_CLASSES),
        role: "tabpanel",
        "data-shadcn--tabs-target": "content",
        "data-value": @value,
        "data-state": "inactive",
        hidden: true,
        tabindex: "0"
      }
    end
  end
end
