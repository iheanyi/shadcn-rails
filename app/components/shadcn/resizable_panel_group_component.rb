# frozen_string_literal: true

module Shadcn
  # ResizablePanelGroup component for creating resizable panel layouts
  # Matches shadcn/ui Resizable component
  # Uses Stimulus for interactivity
  #
  # @example Horizontal layout
  #   <%= render Shadcn::ResizablePanelGroupComponent.new(direction: :horizontal) do |group| %>
  #     <% group.with_panel(default_size: 50) do %>
  #       <div class="flex h-full items-center justify-center p-6">
  #         <span class="font-semibold">One</span>
  #       </div>
  #     <% end %>
  #     <% group.with_handle %>
  #     <% group.with_panel(default_size: 50) do %>
  #       <div class="flex h-full items-center justify-center p-6">
  #         <span class="font-semibold">Two</span>
  #       </div>
  #     <% end %>
  #   <% end %>
  #
  # @example Vertical layout
  #   <%= render Shadcn::ResizablePanelGroupComponent.new(direction: :vertical) do |group| %>
  #     <% group.with_panel(default_size: 25) do %>
  #       Header
  #     <% end %>
  #     <% group.with_handle %>
  #     <% group.with_panel(default_size: 75) do %>
  #       Content
  #     <% end %>
  #   <% end %>
  #
  class ResizablePanelGroupComponent < BaseComponent
    renders_many :panels, lambda { |default_size: nil, min_size: nil, max_size: nil, **options|
      ResizablePanelComponent.new(
        default_size: default_size,
        min_size: min_size,
        max_size: max_size,
        direction: @direction,
        **options
      )
    }

    renders_many :handles, lambda { |with_handle: false, **options|
      ResizableHandleComponent.new(
        with_handle: with_handle,
        direction: @direction,
        **options
      )
    }

    DIRECTIONS = {
      horizontal: "flex h-full",
      vertical: "flex flex-col"
    }.freeze

    # @param direction [Symbol] Direction of the panels (:horizontal, :vertical)
    # @param auto_save_id [String] ID for persisting panel sizes to localStorage
    def initialize(direction: :horizontal, auto_save_id: nil, **options)
      super(**options)
      @direction = direction.to_sym
      @auto_save_id = auto_save_id
    end

    def call
      content_tag(:div, group_content, group_attributes)
    end

    private

    def group_content
      content
    end

    def group_attributes
      {
        class: class_names,
        "data-controller": "shadcn--resizable",
        "data-shadcn--resizable-direction-value": @direction.to_s,
        "data-shadcn--resizable-auto-save-id-value": @auto_save_id,
        "data-panel-group": "",
        "data-panel-group-direction": @direction.to_s
      }.merge(html_options).compact
    end

    def class_names
      cn(
        DIRECTIONS[@direction],
        @class_name
      )
    end
  end
end
