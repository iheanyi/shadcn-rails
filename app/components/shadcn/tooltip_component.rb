# frozen_string_literal: true

module Shadcn
  # Tooltip component for contextual information
  # Matches shadcn/ui Tooltip component
  # Uses Stimulus for interactivity
  #
  # @example Basic tooltip
  #   <%= render Shadcn::TooltipComponent.new(text: "Add to library") do %>
  #     <%= render Shadcn::ButtonComponent.new(variant: :outline, size: :icon) do %>
  #       +
  #     <% end %>
  #   <% end %>
  #
  # @example With custom positioning
  #   <%= render Shadcn::TooltipComponent.new(text: "Help", side: :right) do %>
  #     <span>Hover me</span>
  #   <% end %>
  #
  class TooltipComponent < BaseComponent
    CONTENT_CLASSES = "shadcn-tooltip z-50 w-fit origin-(--radix-tooltip-content-transform-origin) animate-in rounded-md bg-foreground px-3 py-1.5 text-xs text-balance text-background fade-in-0 zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95"
    ARROW_CLASSES = "z-50 size-2.5 translate-y-[calc(-50%_-_2px)] rotate-45 rounded-[2px] bg-foreground fill-foreground"

    # @param text [String] Tooltip text content
    # @param side [Symbol] Side to show tooltip (:top, :right, :bottom, :left)
    # @param align [Symbol] Alignment (:start, :center, :end)
    # @param delay_duration [Integer] Delay before showing (ms)
    # @param skip_delay_duration [Integer] Delay when moving between triggers (ms)
    def initialize(
      text: nil,
      side: :top,
      align: :center,
      delay_duration: 200,
      skip_delay_duration: 300,
      **options
    )
      @tooltip_content = text
      @side = side
      @align = align
      @delay_duration = delay_duration
      @skip_delay_duration = skip_delay_duration
      super(**options)
    end

    private

    def tooltip_classes
      cn("relative inline-block", class_name)
    end

    def tooltip_data_attrs
      {
        controller: "shadcn--tooltip",
        "shadcn--tooltip-side-value": @side.to_s,
        "shadcn--tooltip-align-value": @align.to_s,
        "shadcn--tooltip-delay-value": @delay_duration,
        "shadcn--tooltip-skip-delay-value": @skip_delay_duration
      }
    end

    def tooltip_content_classes
      CONTENT_CLASSES
    end

    def tooltip_arrow_classes
      ARROW_CLASSES
    end
  end
end
