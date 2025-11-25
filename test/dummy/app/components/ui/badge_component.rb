# frozen_string_literal: true

module Ui
  class BadgeComponent < BaseComponent
    VARIANTS = {
      default: "border-transparent bg-primary text-primary-foreground hover:bg-primary/80",
      secondary: "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
      destructive: "border-transparent bg-destructive text-destructive-foreground hover:bg-destructive/80",
      outline: "text-foreground"
    }.freeze

    def initialize(variant: :default, class_name: nil, **html_options)
      @variant = variant.to_sym
      @class_name = class_name
      @html_options = html_options
    end

    def call
      tag.div(content, class: badge_classes, **@html_options)
    end

    private

    def badge_classes
      cn(
        "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors",
        VARIANTS[@variant],
        @class_name
      )
    end
  end
end
