# frozen_string_literal: true

module Shadcn
  # Collapsible component for expandable content
  # Matches shadcn/ui Collapsible component
  # Uses Stimulus for interactivity
  #
  # @example Basic collapsible
  #   <%= render Shadcn::CollapsibleComponent.new do |collapsible| %>
  #     <% collapsible.with_trigger do %>
  #       <%= render Shadcn::ButtonComponent.new(variant: :ghost, size: :sm) do %>
  #         Toggle
  #       <% end %>
  #     <% end %>
  #     <% collapsible.with_body do %>
  #       Hidden content here
  #     <% end %>
  #   <% end %>
  #
  class CollapsibleComponent < BaseComponent
    renders_one :trigger
    renders_one :body, lambda { |**options, &block|
      CollapsibleContentComponent.new(**options, &block)
    }

    # @param open [Boolean] Whether collapsible starts open
    # @param disabled [Boolean] Whether collapsible is disabled
    def initialize(open: false, disabled: false, **options)
      super(**options)
      @open = open
      @disabled = disabled
    end

    private

    def collapsible_classes
      class_name
    end

    def collapsible_content
      safe_join([trigger_wrapper, body].compact)
    end

    def trigger_wrapper
      return unless trigger

      content_tag(:div, trigger, {
        "data-shadcn--collapsible-target": "trigger",
        "data-action": "click->shadcn--collapsible#toggle"
      })
    end

    def state
      @open ? "open" : "closed"
    end
  end
end
