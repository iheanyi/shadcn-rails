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
  #     <% popover.with_content do %>
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

    def call
      content_tag(:div, popover_structure, popover_attributes)
    end

    private

    def popover_structure
      safe_join([
        trigger_wrapper,
        body
      ].compact)
    end

    def trigger_wrapper
      return unless trigger

      content_tag(:div, trigger, {
        "data-shadcn--popover-target": "trigger",
        "data-action": "click->shadcn--popover#toggle"
      })
    end

    def popover_attributes
      attrs = {
        class: cn("relative inline-block", class_name),
        "data-controller": "shadcn--popover",
        "data-shadcn--popover-open-value": @open.to_s,
        "data-shadcn--popover-side-value": @side.to_s,
        "data-shadcn--popover-align-value": @align.to_s,
        "data-shadcn--popover-modal-value": @modal.to_s,
        "data-action": "keydown.escape->shadcn--popover#close"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Popover Content component
  class PopoverContentComponent < BaseComponent
    BASE_CLASSES = "z-50 w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2"

    def call
      content_tag(:div, content, content_attributes)
    end

    private

    def content_attributes
      {
        class: merge_classes(BASE_CLASSES),
        "data-shadcn--popover-target": "content",
        "data-state": "closed",
        "data-side": "bottom",
        tabindex: "-1",
        hidden: true
      }
    end
  end
end
