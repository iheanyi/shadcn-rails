# frozen_string_literal: true

module Shadcn
  # Spinner component for loading states
  # Matches shadcn/ui Spinner component
  #
  # @example Basic spinner
  #   <%= render Shadcn::SpinnerComponent.new %>
  #
  # @example With size
  #   <%= render Shadcn::SpinnerComponent.new(size: :sm) %>
  #   <%= render Shadcn::SpinnerComponent.new(size: :lg) %>
  #
  # @example Custom color
  #   <%= render Shadcn::SpinnerComponent.new(class_name: "text-primary") %>
  #
  class SpinnerComponent < BaseComponent
    SIZES = {
      sm: "h-4 w-4",
      default: "h-6 w-6",
      lg: "h-8 w-8",
      xl: "h-12 w-12"
    }.freeze

    BASE_CLASSES = "animate-spin text-muted-foreground"

    # @param size [Symbol] Spinner size (:sm, :default, :lg, :xl)
    def initialize(size: :default, **options)
      super(**options)
      @size = size.to_sym
    end

    def call
      tag.svg(**spinner_attributes) do
        safe_join([
          tag.circle(
            class: "opacity-25",
            cx: "12",
            cy: "12",
            r: "10",
            stroke: "currentColor",
            "stroke-width": "4",
            fill: "none"
          ),
          tag.path(
            class: "opacity-75",
            fill: "currentColor",
            d: "M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
          )
        ])
      end
    end

    private

    def spinner_attributes
      {
        class: cn(BASE_CLASSES, SIZES[@size], class_name),
        xmlns: "http://www.w3.org/2000/svg",
        fill: "none",
        viewBox: "0 0 24 24",
        role: "status",
        "aria-label": "Loading"
      }.merge(html_options).merge(build_data).compact
    end
  end
end
