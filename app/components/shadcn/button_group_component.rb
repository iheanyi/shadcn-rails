# frozen_string_literal: true

module Shadcn
  # Button Group component for grouping related buttons
  # Matches shadcn/ui Button Group pattern
  #
  # @example Basic button group
  #   <%= render Shadcn::ButtonGroupComponent.new do |group| %>
  #     <% group.with_button(variant: :outline) { "Left" } %>
  #     <% group.with_button(variant: :outline) { "Center" } %>
  #     <% group.with_button(variant: :outline) { "Right" } %>
  #   <% end %>
  #
  # @example With different variants
  #   <%= render Shadcn::ButtonGroupComponent.new do |group| %>
  #     <% group.with_button { "Save" } %>
  #     <% group.with_button(variant: :outline) { "Cancel" } %>
  #   <% end %>
  #
  # @example Vertical orientation
  #   <%= render Shadcn::ButtonGroupComponent.new(orientation: :vertical) do |group| %>
  #     <% group.with_button(variant: :outline) { "Top" } %>
  #     <% group.with_button(variant: :outline) { "Middle" } %>
  #     <% group.with_button(variant: :outline) { "Bottom" } %>
  #   <% end %>
  #
  class ButtonGroupComponent < BaseComponent
    BASE_CLASSES = "flex w-fit items-stretch has-[>[data-slot=button-group]]:gap-2 [&>*]:focus-visible:relative [&>*]:focus-visible:z-10 has-[select[aria-hidden=true]:last-child]:[&>[data-slot=select-trigger]:last-of-type]:rounded-r-md [&>[data-slot=select-trigger]:not([class*='w-'])]:w-fit [&>input]:flex-1"

    ORIENTATIONS = {
      horizontal: "[&>*:not(:first-child)]:rounded-l-none [&>*:not(:first-child)]:border-l-0 [&>*:not(:last-child)]:rounded-r-none",
      vertical: "flex-col [&>*:not(:first-child)]:rounded-t-none [&>*:not(:first-child)]:border-t-0 [&>*:not(:last-child)]:rounded-b-none"
    }.freeze

    # Use polymorphic slots to preserve the order of buttons, text, and separators.
    renders_many :items, types: {
      button: {
        renders: lambda { |**options, &block|
          Shadcn::ButtonComponent.new(**options, &block)
        },
        as: :button
      },
      text: {
        renders: lambda { |**options, &block|
          ButtonGroupTextComponent.new(**options, &block)
        },
        as: :text
      },
      separator: {
        renders: lambda { |**options|
          ButtonGroupSeparatorComponent.new(**options)
        },
        as: :separator
      }
    }

    class ButtonGroupTextComponent < BaseComponent
      BASE_CLASSES = "flex items-center gap-2 rounded-md border bg-muted px-4 text-sm font-medium shadow-xs [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4"

      def call
        tag.div(content, **merge_html_attributes({ class: text_classes }))
      end

      private

      def text_classes
        cn(BASE_CLASSES, class_name)
      end
    end

    class ButtonGroupSeparatorComponent < BaseComponent
      BASE_CLASSES = "relative m-0! self-stretch bg-input data-[orientation=vertical]:h-auto"

      # @param orientation [Symbol] Separator orientation (:horizontal, :vertical)
      # @param decorative [Boolean] Whether the separator is purely decorative
      def initialize(orientation: :vertical, decorative: true, **options)
        super(**options)
        @orientation = orientation.to_sym
        @decorative = decorative
      end

      def call
        tag.div(**merge_html_attributes(separator_attributes, slot: "button-group-separator", orientation: @orientation))
      end

      private

      def separator_attributes
        {
          class: separator_classes,
          role: separator_role,
          "aria-orientation": aria_orientation
        }.compact
      end

      def separator_classes
        cn(Shadcn::SeparatorComponent::BASE_CLASSES, BASE_CLASSES, class_name)
      end

      def separator_role
        @decorative ? "none" : "separator"
      end

      def aria_orientation
        @decorative ? nil : @orientation.to_s
      end
    end

    # @param orientation [Symbol] Layout orientation (:horizontal, :vertical)
    def initialize(orientation: :horizontal, **options)
      super(**options)
      @orientation = orientation.to_sym
    end

    def call
      tag.div(group_content, **merge_html_attributes({ class: group_classes, role: "group" }, slot: "button-group", orientation: @orientation))
    end

    private

    def group_content
      raw_content = content
      return safe_join(items) if items.any?

      raw_content
    end

    def group_classes
      cn(
        BASE_CLASSES,
        ORIENTATIONS[@orientation],
        class_name
      )
    end
  end
end
