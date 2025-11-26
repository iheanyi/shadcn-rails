# frozen_string_literal: true

module Shadcn
  # Hover Card component for displaying rich content on hover
  # Matches shadcn/ui HoverCard component
  #
  # @example Basic usage
  #   <%= render Shadcn::HoverCardComponent.new do |card| %>
  #     <% card.with_trigger do %>
  #       <a href="#">@username</a>
  #     <% end %>
  #     <% card.with_card_content do %>
  #       <div>User profile preview</div>
  #     <% end %>
  #   <% end %>
  #
  class HoverCardComponent < BaseComponent
    renders_one :trigger
    renders_one :card_content, lambda { |**options|
      HoverCardContentComponent.new(**options)
    }

    # @param open_delay [Integer] Delay in ms before opening
    # @param close_delay [Integer] Delay in ms before closing
    def initialize(open_delay: 700, close_delay: 300, **options)
      super(**options)
      @open_delay = open_delay
      @close_delay = close_delay
    end

    def call
      content_tag(:div, build_card_content, card_attributes)
    end

    private

    def build_card_content
      safe_join([
        trigger_wrapper,
        card_content
      ].compact)
    end

    def trigger_wrapper
      return unless trigger

      content_tag(:div, trigger, {
        "data-shadcn--hover-card-target": "trigger"
      })
    end

    def card_attributes
      attrs = {
        class: cn("relative inline-block", class_name),
        "data-controller": "shadcn--hover-card",
        "data-shadcn--hover-card-open-delay-value": @open_delay,
        "data-shadcn--hover-card-close-delay-value": @close_delay
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Hover Card Content component
  class HoverCardContentComponent < BaseComponent
    BASE_CLASSES = "z-50 w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2"

    # @param side [Symbol] :top, :right, :bottom, or :left
    # @param align [Symbol] :start, :center, or :end
    def initialize(side: :bottom, align: :center, **options)
      super(**options)
      @side = side
      @align = align
    end

    def call
      content_tag(:div, content, content_attributes)
    end

    private

    def content_attributes
      attrs = {
        class: merge_classes(BASE_CLASSES),
        role: "tooltip",
        "data-state": "closed",
        "data-side": @side.to_s,
        "data-align": @align.to_s,
        "data-shadcn--hover-card-target": "content",
        style: "display: none; position: absolute;"
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end
end
