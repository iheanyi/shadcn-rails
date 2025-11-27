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
    CONTENT_CLASSES = "z-50 overflow-hidden rounded-md bg-primary px-3 py-1.5 text-xs text-primary-foreground whitespace-nowrap animate-tooltip-in data-[state=closed]:animate-tooltip-out"

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
  end
end
