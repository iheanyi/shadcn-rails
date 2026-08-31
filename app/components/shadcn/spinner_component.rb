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
      sm: "size-4",
      default: "size-4",
      lg: "size-8",
      xl: "size-12"
    }.freeze

    BASE_CLASSES = "size-4 animate-spin"

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
