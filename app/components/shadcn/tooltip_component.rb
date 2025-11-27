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

    def call
      content_tag(:span, tooltip_structure, tooltip_attributes)
    end

    private

    def tooltip_structure
      safe_join([
        trigger_wrapper,
        tooltip_content_element
      ])
    end

    def trigger_wrapper
      content_tag(:span, content, {
        "data-shadcn--tooltip-target": "trigger",
        "data-action": "mouseenter->shadcn--tooltip#show mouseleave->shadcn--tooltip#hide focus->shadcn--tooltip#show blur->shadcn--tooltip#hide"
      })
    end

    def tooltip_content_element
      content_tag(:div, @tooltip_content, {
        class: CONTENT_CLASSES,
        role: "tooltip",
        "data-shadcn--tooltip-target": "content",
        "data-side": @side.to_s,
        "data-state": "closed",
        hidden: true
      })
    end

    def tooltip_attributes
      attrs = {
        class: cn("relative inline-block", class_name),
        "data-controller": "shadcn--tooltip",
        "data-shadcn--tooltip-side-value": @side.to_s,
        "data-shadcn--tooltip-align-value": @align.to_s,
        "data-shadcn--tooltip-delay-value": @delay_duration,
        "data-shadcn--tooltip-skip-delay-value": @skip_delay_duration
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
