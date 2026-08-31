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
      default: "bg-primary text-primary-foreground [a&]:hover:bg-primary/90",
      secondary: "bg-secondary text-secondary-foreground [a&]:hover:bg-secondary/90",
      destructive: "bg-destructive text-white focus-visible:ring-destructive/20 dark:bg-destructive/60 dark:focus-visible:ring-destructive/40 [a&]:hover:bg-destructive/90",
      outline: "border-border text-foreground [a&]:hover:bg-accent [a&]:hover:text-accent-foreground"
    }.freeze

    BASE_CLASSES = "inline-flex w-fit shrink-0 items-center justify-center gap-1 overflow-hidden rounded-full border border-transparent px-2 py-0.5 text-xs font-medium whitespace-nowrap transition-[color,box-shadow] focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 [&>svg]:pointer-events-none [&>svg]:size-3"

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
