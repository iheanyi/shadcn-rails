# frozen_string_literal: true

module Shadcn
  # Collapsible component for expandable content
  # Matches shadcn/ui Collapsible component
  # Uses Stimulus for interactivity
  #
  # @example Basic collapsible
  #   <%= render Shadcn::CollapsibleComponent.new do |collapsible| %>
  #     <% collapsible.with_trigger(variant: :ghost, size: :sm) do %>
  #       Toggle
  #     <% end %>
  #     <% collapsible.with_body do %>
  #       Hidden content here
  #     <% end %>
  #   <% end %>
  #
  class CollapsibleComponent < BaseComponent
    renders_one :trigger, lambda { |**options, &block|
      CollapsibleTriggerComponent.new(open: @open, disabled: @disabled, **options, &block)
    }
    renders_one :body, lambda { |**options, &block|
      options[:open] = @open unless options.key?(:open)
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
      safe_join([trigger, body].compact)
    end

    def state
      @open ? "open" : "closed"
    end
  end
end
