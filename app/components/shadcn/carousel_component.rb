# frozen_string_literal: true

module Shadcn
  # Carousel component for sliding content
  # Matches shadcn/ui Carousel component
  # Uses Stimulus for interactivity with swipe and keyboard navigation
  #
  # @example Basic carousel
  #   <%= render Shadcn::CarouselComponent.new do |carousel| %>
  #     <% carousel.with_content do |content| %>
  #       <% 5.times do |i| %>
  #         <% content.with_item do %>
  #           <div class="p-6 text-center">Slide <%= i + 1 %></div>
  #         <% end %>
  #       <% end %>
  #     <% end %>
  #     <% carousel.with_previous { "Previous" } %>
  #     <% carousel.with_next { "Next" } %>
  #   <% end %>
  #
  # @example Vertical carousel
  #   <%= render Shadcn::CarouselComponent.new(orientation: :vertical) do |carousel| %>
  #     <% carousel.with_content do |content| %>
  #       <% 5.times do |i| %>
  #         <% content.with_item do %>
  #           <div class="p-6 text-center">Slide <%= i + 1 %></div>
  #         <% end %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class CarouselComponent < BaseComponent
    renders_one :content, lambda { |**options|
      CarouselContentComponent.new(orientation: @orientation, **options)
    }
    renders_one :previous, lambda { |**options, &block|
      CarouselPreviousComponent.new(orientation: @orientation, **options, &block)
    }
    renders_one :next, lambda { |**options, &block|
      CarouselNextComponent.new(orientation: @orientation, **options, &block)
    }

    ORIENTATIONS = {
      horizontal: "horizontal",
      vertical: "vertical"
    }.freeze

    # @param orientation [Symbol] Direction of carousel (:horizontal, :vertical)
    # @param loop [Boolean] Whether to loop infinitely
    # @param autoplay [Boolean] Whether to auto-advance slides
    # @param autoplay_interval [Integer] Milliseconds between auto-advance (default: 4000)
    # @param align [Symbol] Item alignment (:start, :center, :end)
    def initialize(orientation: :horizontal, loop: false, autoplay: false, autoplay_interval: 4000, align: :start, **options)
      super(**options)
      @orientation = orientation.to_sym
      @loop = loop
      @autoplay = autoplay
      @autoplay_interval = autoplay_interval
      @align = align.to_sym
    end

    def call
      content_tag(:div, carousel_content, carousel_attributes)
    end

    private

    def carousel_content
      safe_join([content, previous, self.next].compact)
    end

    def carousel_attributes
      attrs = {
        class: cn(
          "relative",
          class_name
        ),
        role: "region",
        "aria-roledescription": "carousel",
        "data-controller": "shadcn--carousel",
        "data-shadcn--carousel-orientation-value": @orientation.to_s,
        "data-shadcn--carousel-loop-value": @loop.to_s,
        "data-shadcn--carousel-autoplay-value": @autoplay.to_s,
        "data-shadcn--carousel-autoplay-interval-value": @autoplay_interval.to_s,
        "data-shadcn--carousel-align-value": @align.to_s
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Container for carousel items
  class CarouselContentComponent < BaseComponent
    renders_many :items, lambda { |**options, &block|
      CarouselItemComponent.new(orientation: @orientation, **options, &block)
    }

    def initialize(orientation: :horizontal, **options)
      super(**options)
      @orientation = orientation.to_sym
    end

    def call
      content_tag(:div, wrapper_content, wrapper_attributes)
    end

    private

    def wrapper_content
      content_tag(:div, items_content, content_attributes)
    end

    def items_content
      safe_join([items, content].compact.flatten)
    end

    def wrapper_attributes
      {
        class: "overflow-hidden",
        "data-shadcn--carousel-target": "viewport"
      }
    end

    def content_attributes
      {
        class: cn(
          "flex",
          @orientation == :horizontal ? "-ml-4" : "-mt-4 flex-col",
          class_name
        ),
        "data-shadcn--carousel-target": "content"
      }
    end
  end

  # Individual carousel item
  class CarouselItemComponent < BaseComponent
    def initialize(orientation: :horizontal, basis: nil, **options)
      super(**options)
      @orientation = orientation.to_sym
      @basis = basis
    end

    def call
      content_tag(:div, content, item_attributes)
    end

    private

    def item_attributes
      {
        role: "group",
        "aria-roledescription": "slide",
        class: cn(
          "min-w-0 shrink-0 grow-0",
          @orientation == :horizontal ? "pl-4" : "pt-4",
          @basis || "basis-full",
          class_name
        ),
        "data-shadcn--carousel-target": "item"
      }
    end
  end

  # Previous button component
  class CarouselPreviousComponent < BaseComponent
    def initialize(orientation: :horizontal, **options)
      super(**options)
      @orientation = orientation.to_sym
    end

    def call
      content_tag(:button, button_content, button_attributes)
    end

    private

    def button_content
      if content.present?
        content
      else
        default_icon
      end
    end

    def default_icon
      # Left arrow for horizontal, up arrow for vertical
      if @orientation == :horizontal
        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><path d="m12 19-7-7 7-7"/><path d="M19 12H5"/></svg>'.html_safe
      else
        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><path d="m18 15-6-6-6 6"/></svg>'.html_safe
      end
    end

    def button_attributes
      position_classes = if @orientation == :horizontal
        "-left-12 top-1/2 -translate-y-1/2"
      else
        "-top-12 left-1/2 -translate-x-1/2 rotate-90"
      end

      {
        type: "button",
        class: cn(
          "absolute h-8 w-8 rounded-full",
          "inline-flex items-center justify-center whitespace-nowrap text-sm font-medium",
          "ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
          "disabled:pointer-events-none disabled:opacity-50",
          "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
          position_classes,
          class_name
        ),
        "data-shadcn--carousel-target": "prevButton",
        "data-action": "click->shadcn--carousel#previous",
        "aria-label": "Previous slide"
      }
    end
  end

  # Next button component
  class CarouselNextComponent < BaseComponent
    def initialize(orientation: :horizontal, **options)
      super(**options)
      @orientation = orientation.to_sym
    end

    def call
      content_tag(:button, button_content, button_attributes)
    end

    private

    def button_content
      if content.present?
        content
      else
        default_icon
      end
    end

    def default_icon
      # Right arrow for horizontal, down arrow for vertical
      if @orientation == :horizontal
        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>'.html_safe
      else
        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><path d="m6 9 6 6 6-6"/></svg>'.html_safe
      end
    end

    def button_attributes
      position_classes = if @orientation == :horizontal
        "-right-12 top-1/2 -translate-y-1/2"
      else
        "-bottom-12 left-1/2 -translate-x-1/2 rotate-90"
      end

      {
        type: "button",
        class: cn(
          "absolute h-8 w-8 rounded-full",
          "inline-flex items-center justify-center whitespace-nowrap text-sm font-medium",
          "ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
          "disabled:pointer-events-none disabled:opacity-50",
          "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
          position_classes,
          class_name
        ),
        "data-shadcn--carousel-target": "nextButton",
        "data-action": "click->shadcn--carousel#next",
        "aria-label": "Next slide"
      }
    end
  end
end
