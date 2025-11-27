# frozen_string_literal: true

module Shadcn
  # Badge component for labels and status indicators
  # Matches shadcn/ui Badge component
  #
  # @example Basic badge
  #   <%= render Shadcn::BadgeComponent.new { "New" } %>
  #
  # @example Variant badges
  #   <%= render Shadcn::BadgeComponent.new(variant: :secondary) { "Draft" } %>
  #   <%= render Shadcn::BadgeComponent.new(variant: :destructive) { "Error" } %>
  #   <%= render Shadcn::BadgeComponent.new(variant: :outline) { "v1.0.0" } %>
  #
  class BadgeComponent < BaseComponent
    # Available badge variants
    VARIANTS = {
      default: "border-transparent bg-primary text-primary-foreground shadow hover:bg-primary/80",
      secondary: "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
      destructive: "border-transparent bg-destructive text-destructive-foreground shadow hover:bg-destructive/80",
      outline: "text-foreground"
    }.freeze

    BASE_CLASSES = "inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2"

    # @param variant [Symbol] Badge style variant (:default, :secondary, :destructive, :outline)
    def initialize(variant: :default, **options)
      super(**options)
      @variant = variant.to_sym
    end

    private

    def badge_classes
      cn(BASE_CLASSES, VARIANTS[@variant], class_name)
    end
  end
end
