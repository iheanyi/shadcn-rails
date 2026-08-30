# frozen_string_literal: true

module Shadcn
  # Popover component for rich content in an overlay
  # Matches shadcn/ui Popover component
  # Uses Stimulus for interactivity
  #
  # @example Basic popover
  #   <%= render Shadcn::PopoverComponent.new do |popover| %>
  #     <% popover.with_trigger do %>
  #       <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Open popover" } %>
  #     <% end %>
  #     <% popover.with_body do %>
  #       <div class="grid gap-4">
  #         <h4 class="font-medium leading-none">Dimensions</h4>
  #         <p class="text-sm text-muted-foreground">Set the dimensions for the layer.</p>
  #       </div>
  #     <% end %>
  #   <% end %>
  #
  class PopoverComponent < BaseComponent
    renders_one :trigger
    renders_one :body, lambda { |**options, &block|
      PopoverContentComponent.new(**options, &block)
    }

    # @param open [Boolean] Whether popover starts open
    # @param side [Symbol] Side to show content (:top, :right, :bottom, :left)
    # @param align [Symbol] Alignment (:start, :center, :end)
    # @param modal [Boolean] Whether to trap focus
    def initialize(open: false, side: :bottom, align: :center, modal: false, **options)
      super(**options)
      @open = open
      @side = side
      @align = align
      @modal = modal
    end

    private

    def popover_classes
      cn("relative inline-block", class_name)
    end

    def popover_data_attrs
      {
        controller: "shadcn--popover",
        "shadcn--popover-open-value": @open.to_s,
        "shadcn--popover-side-value": @side.to_s,
        "shadcn--popover-align-value": @align.to_s,
        "shadcn--popover-modal-value": @modal.to_s,
        action: "keydown.escape->shadcn--popover#close"
      }
    end
  end
end
