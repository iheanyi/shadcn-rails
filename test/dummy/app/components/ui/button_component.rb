# frozen_string_literal: true

module Ui
  class ButtonComponent < BaseComponent
    VARIANTS = {
      default: "bg-primary text-primary-foreground hover:bg-primary/90",
      destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
      outline: "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
      secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
      ghost: "hover:bg-accent hover:text-accent-foreground",
      link: "text-primary underline-offset-4 hover:underline"
    }.freeze

    SIZES = {
      default: "h-10 px-4 py-2",
      sm: "h-9 rounded-md px-3",
      lg: "h-11 rounded-md px-8",
      icon: "h-10 w-10"
    }.freeze

    def initialize(variant: :default, size: :default, type: "button", disabled: false, class_name: nil, **html_options)
      @variant = variant.to_sym
      @size = size.to_sym
      @type = type
      @disabled = disabled
      @class_name = class_name
      @html_options = html_options
    end

    def call
      tag.button(content, type: @type, disabled: @disabled, class: button_classes, **@html_options)
    end

    private

    def button_classes
      cn(
        "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
        VARIANTS[@variant],
        SIZES[@size],
        @class_name
      )
    end
  end
end
