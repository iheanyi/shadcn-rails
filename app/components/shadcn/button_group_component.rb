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
    ORIENTATIONS = {
      horizontal: "flex-row",
      vertical: "flex-col"
    }.freeze

    BASE_CLASSES = "inline-flex"

    # Button slot - renders Button components with adjusted border radius
    renders_many :buttons, lambda { |**options, &block|
      # Buttons in a group need special border radius handling
      options[:class_name] = cn(
        "rounded-none first:rounded-l-md last:rounded-r-md",
        "-ml-px first:ml-0", # Collapse borders
        options[:class_name]
      )
      Shadcn::ButtonComponent.new(**options, &block)
    }

    # @param orientation [Symbol] Layout orientation (:horizontal, :vertical)
    def initialize(orientation: :horizontal, **options)
      super(**options)
      @orientation = orientation.to_sym
    end

    def call
      tag.div(class: group_classes, role: "group", **html_options.merge(build_data)) do
        safe_join(buttons)
      end
    end

    private

    def group_classes
      cn(
        BASE_CLASSES,
        ORIENTATIONS[@orientation],
        @orientation == :vertical ? "first:[&>*]:rounded-t-md last:[&>*]:rounded-b-md [&>*]:rounded-none [&>*]:-mt-px [&>*]:first:mt-0" : "",
        class_name
      )
    end
  end
end
