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
  #     <% collapsible.with_content do %>
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

    def call
      content_tag(:div, collapsible_content, collapsible_attributes)
    end

    private

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

    def collapsible_attributes
      attrs = {
        class: class_name,
        "data-controller": "shadcn--collapsible",
        "data-shadcn--collapsible-open-value": @open.to_s,
        "data-shadcn--collapsible-disabled-value": @disabled.to_s,
        "data-state": @open ? "open" : "closed"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
