# frozen_string_literal: true

module Shadcn
  # Sonner toaster component.
  #
  # Render this once near the end of your layout, then call the JavaScript
  # toast() API or append toast markup into the viewport with Turbo Streams.
  class SonnerComponent < BaseComponent
    POSITIONS = {
      top_left: "top-0 left-0 sm:top-4 sm:left-4",
      top_center: "top-0 left-1/2 -translate-x-1/2 sm:top-4",
      top_right: "top-0 right-0 sm:top-4 sm:right-4",
      bottom_left: "bottom-0 left-0 sm:bottom-4 sm:left-4",
      bottom_center: "bottom-0 left-1/2 -translate-x-1/2 sm:bottom-4",
      bottom_right: "bottom-0 right-0 sm:bottom-4 sm:right-4"
    }.freeze

    POSITION_VALUES = POSITIONS.keys.map { |position| position.to_s.tr("_", "-") }.freeze

    ROOT_CLASSES = "shadcn-sonner"
    VIEWPORT_BASE_CLASSES = "pointer-events-none fixed z-[100] flex max-h-screen w-full gap-2 p-4 sm:max-w-[420px]"

    # @param position [Symbol, String] Viewport position.
    # @param limit [Integer] Maximum visible toasts.
    # @param duration [Integer] Default auto-dismiss duration in milliseconds.
    # @param id [String] Viewport id for Turbo Stream append targets.
    # @param root_id [String, nil] Controller root id used with data-turbo-permanent.
    # @param viewport_class_name [String, nil] Extra classes for the viewport.
    # @param persistent [Boolean] Adds data-turbo-permanent to the controller root.
    def initialize(
      position: :bottom_right,
      limit: 3,
      duration: 4000,
      id: "shadcn-sonner-viewport",
      root_id: nil,
      viewport_class_name: nil,
      persistent: true,
      **options
    )
      super(**options)
      @position = normalize_position(position)
      @limit = limit
      @duration = duration
      @id = id
      @root_id = root_id || "#{id}-root"
      @viewport_class_name = viewport_class_name
      @persistent = persistent
    end

    def call
      content_tag(:div, root_content, **root_attributes)
    end

    private

    def root_content
      safe_join([content, viewport].compact)
    end

    def root_attributes
      attrs = merge_html_attributes(
        { class: merge_classes(ROOT_CLASSES) },
        {
          controller: "shadcn--sonner",
          "shadcn--sonner-position-value": @position.to_s.tr("_", "-"),
          "shadcn--sonner-limit-value": @limit,
          "shadcn--sonner-duration-value": @duration
        }
      )

      attrs[:id] = @root_id unless attrs.key?(:id) || attrs.key?("id")
      attrs["data-turbo-permanent"] = "" if @persistent
      attrs
    end

    def viewport
      content_tag(:ol, "", **viewport_attributes)
    end

    def viewport_attributes
      attrs = {
        id: @id,
        class: viewport_classes,
        role: "region",
        "aria-label": "Notifications",
        tabindex: "-1",
        "data-shadcn--sonner-target": "viewport"
      }

      attrs
    end

    def viewport_classes
      cn(
        VIEWPORT_BASE_CLASSES,
        POSITIONS.fetch(@position),
        stack_direction_classes,
        @viewport_class_name
      )
    end

    def stack_direction_classes
      @position.to_s.start_with?("top") ? "flex-col" : "flex-col-reverse"
    end

    def normalize_position(position)
      normalized = position.to_s.tr("-", "_").to_sym
      return normalized if POSITIONS.key?(normalized)

      raise ArgumentError, "Unknown Sonner position: #{position}. Available positions: #{POSITION_VALUES.join(', ')}"
    end
  end
end
