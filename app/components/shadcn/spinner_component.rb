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

    private

    def spinner_classes
      cn(BASE_CLASSES, SIZES[@size], class_name)
    end
  end
end
