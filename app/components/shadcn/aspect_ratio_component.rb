# frozen_string_literal: true

module Shadcn
  # Aspect Ratio component for maintaining content proportions
  # Matches shadcn/ui AspectRatio component
  #
  # @example 16:9 video ratio
  #   <%= render Shadcn::AspectRatioComponent.new(ratio: 16.0/9.0) do %>
  #     <img src="image.jpg" class="h-full w-full object-cover" />
  #   <% end %>
  #
  # @example Square ratio
  #   <%= render Shadcn::AspectRatioComponent.new(ratio: 1) do %>
  #     <img src="square.jpg" />
  #   <% end %>
  #
  class AspectRatioComponent < BaseComponent
    # @param ratio [Float] Aspect ratio (width/height, e.g. 16.0/9.0 for widescreen)
    def initialize(ratio: 1, **options)
      super(**options)
      @ratio = ratio.to_f
    end

    private

    def wrapper_classes
      cn("relative w-full", class_name)
    end

    def wrapper_style
      "padding-bottom: #{(1.0 / @ratio) * 100}%;"
    end
  end
end
