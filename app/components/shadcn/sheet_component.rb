# frozen_string_literal: true

module Shadcn
  # Sheet component for slide-out panels
  # Matches shadcn/ui Sheet component
  # Uses Stimulus for interactivity
  #
  # @example Basic sheet
  #   <%= render Shadcn::SheetComponent.new(side: :right) do |sheet| %>
  #     <% sheet.with_trigger do %>
  #       <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Open Sheet" } %>
  #     <% end %>
  #     <% sheet.with_content do |content| %>
  #       <% content.with_header do %>
  #         <% content.with_title { "Edit Profile" } %>
  #         <% content.with_description { "Make changes to your profile." } %>
  #       <% end %>
  #       <div class="py-4">
  #         Sheet body content
  #       </div>
  #       <% content.with_footer do %>
  #         <%= render Shadcn::ButtonComponent.new { "Save changes" } %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class SheetComponent < BaseComponent
    SIDES = {
      top: "inset-x-0 top-0 border-b data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top",
      bottom: "inset-x-0 bottom-0 border-t data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom",
      left: "inset-y-0 left-0 h-full w-3/4 border-r data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left sm:max-w-sm",
      right: "inset-y-0 right-0 h-full w-3/4 border-l data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right sm:max-w-sm"
    }.freeze

    renders_one :trigger
    renders_one :body, lambda { |**options|
      SheetContentComponent.new(side: @side, **options)
    }

    # @param side [Symbol] Side to show sheet (:top, :right, :bottom, :left)
    # @param open [Boolean] Whether sheet starts open
    def initialize(side: :right, open: false, **options)
      super(**options)
      @side = side.to_sym
      @open = open
    end

    private

    def sheet_classes
      class_name
    end

    def sheet_data_attrs
      {
        controller: "shadcn--sheet",
        "shadcn--sheet-open-value": @open.to_s,
        "shadcn--sheet-side-value": @side.to_s
      }
    end
  end
end
