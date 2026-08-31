# frozen_string_literal: true

module Shadcn
  # Scroll Area component for custom scrollbars
  # Matches shadcn/ui ScrollArea component
  # Uses Stimulus for interactivity
  #
  # @example Basic scroll area
  #   <%= render Shadcn::ScrollAreaComponent.new(class_name: "h-72 w-48") do %>
  #     <div class="p-4">
  #       Long content here...
  #     </div>
  #   <% end %>
  #
  # @example Horizontal scroll
  #   <%= render Shadcn::ScrollAreaComponent.new(orientation: :horizontal, class_name: "w-96 whitespace-nowrap") do %>
  #     <div class="flex space-x-4 p-4">
  #       <!-- items -->
  #     </div>
  #   <% end %>
  #
  class ScrollAreaComponent < BaseComponent
    BASE_CLASSES = "relative"
    VIEWPORT_CLASSES = "size-full rounded-[inherit] transition-[color,box-shadow] outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50 focus-visible:outline-1"
    SCROLLBAR_CLASSES = "flex touch-none p-px transition-colors select-none"
    THUMB_CLASSES = "relative flex-1 rounded-full bg-border"

    # @param orientation [Symbol] Scroll orientation (:vertical, :horizontal, :both)
    # @param type [Symbol] Scrollbar type (:auto, :always, :scroll, :hover)
    def initialize(orientation: :vertical, type: :hover, **options)
      super(**options)
      @orientation = orientation.to_sym
      @type = type.to_sym
    end

    private

    def scroll_classes
      merge_classes(BASE_CLASSES)
    end

    def scroll_structure
      safe_join([
        viewport,
        scrollbars,
        corner
      ])
    end

    def viewport
      content_tag(:div, content, {
        class: VIEWPORT_CLASSES,
        style: "overflow: hidden scroll;",
        "data-slot": "scroll-area-viewport",
        "data-shadcn--scroll-area-target": "viewport"
      })
    end

    def scrollbars
      case @orientation
      when :both
        safe_join([vertical_scrollbar, horizontal_scrollbar])
      when :horizontal
        horizontal_scrollbar
      else
        vertical_scrollbar
      end
    end

    def vertical_scrollbar
      content_tag(:div, scrollbar_thumb, {
        class: "#{SCROLLBAR_CLASSES} h-full w-2.5 border-l border-l-transparent",
        "data-slot": "scroll-area-scrollbar",
        "data-orientation": "vertical",
        "data-shadcn--scroll-area-target": "scrollbar"
      })
    end

    def horizontal_scrollbar
      content_tag(:div, scrollbar_thumb, {
        class: "#{SCROLLBAR_CLASSES} h-2.5 flex-col border-t border-t-transparent",
        "data-slot": "scroll-area-scrollbar",
        "data-orientation": "horizontal",
        "data-shadcn--scroll-area-target": "scrollbar"
      })
    end

    def scrollbar_thumb
      content_tag(:div, "", {
        class: THUMB_CLASSES,
        "data-slot": "scroll-area-thumb",
        "data-shadcn--scroll-area-target": "thumb"
      })
    end

    def corner
      return unless @orientation == :both

      content_tag(:div, "", class: "absolute right-0 bottom-0 h-2.5 w-2.5 bg-transparent")
    end
  end
end
