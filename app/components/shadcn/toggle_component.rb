# frozen_string_literal: true

module Shadcn
  # Toggle component for a two-state button
  # Matches shadcn/ui Toggle component
  #
  # @example Basic usage
  #   <%= render Shadcn::ToggleComponent.new(aria_label: "Toggle bold") do %>
  #     <svg>...</svg>
  #   <% end %>
  #
  # @example Outline variant
  #   <%= render Shadcn::ToggleComponent.new(variant: :outline, pressed: true) do %>
  #     Italic
  #   <% end %>
  #
  class ToggleComponent < BaseComponent
    VARIANTS = {
      default: "bg-transparent",
      outline: "border border-input bg-transparent shadow-xs hover:bg-accent hover:text-accent-foreground"
    }.freeze

    SIZES = {
      sm: "h-8 min-w-8 px-1.5",
      default: "h-9 min-w-9 px-2",
      lg: "h-10 min-w-10 px-2.5"
    }.freeze

    BASE_CLASSES = "inline-flex items-center justify-center gap-2 rounded-md text-sm font-medium whitespace-nowrap transition-[color,box-shadow] outline-none hover:bg-muted hover:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground dark:aria-invalid:ring-destructive/40 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"

    # @param variant [Symbol] :default or :outline
    # @param size [Symbol] :sm, :default, or :lg
    # @param pressed [Boolean] Initial pressed state
    # @param disabled [Boolean] Whether toggle is disabled
    # @param aria_label [String] Accessibility label
    def initialize(
      variant: :default,
      size: :default,
      pressed: false,
      disabled: false,
      aria_label: nil,
      **options
    )
      super(**options)
      @variant = variant
      @size = size
      @pressed = pressed
      @disabled = disabled
      @aria_label = aria_label
    end

    private

    def toggle_classes
      cn(BASE_CLASSES, VARIANTS[@variant], SIZES[@size], class_name)
    end

    def data_state
      @pressed ? "on" : "off"
    end
  end
end
