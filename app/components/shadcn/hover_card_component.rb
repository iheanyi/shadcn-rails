# frozen_string_literal: true

module Shadcn
  # Hover Card component for displaying rich content on hover
  # Matches shadcn/ui HoverCard component
  #
  # @example Basic usage
  #   <%= render Shadcn::HoverCardComponent.new do |card| %>
  #     <% card.with_trigger do %>
  #       <a href="#">@username</a>
  #     <% end %>
  #     <% card.with_card_content do %>
  #       <div>User profile preview</div>
  #     <% end %>
  #   <% end %>
  #
  class HoverCardComponent < BaseComponent
    renders_one :trigger
    renders_one :card_content, lambda { |**options|
      HoverCardContentComponent.new(**options)
    }

    # @param open_delay [Integer] Delay in ms before opening
    # @param close_delay [Integer] Delay in ms before closing
    def initialize(open_delay: 700, close_delay: 300, **options)
      super(**options)
      @open_delay = open_delay
      @close_delay = close_delay
    end

    private

    def hover_card_classes
      cn("relative inline-block", class_name)
    end

    def hover_card_data_attrs
      {
        controller: "shadcn--hover-card",
        "shadcn--hover-card-open-delay-value": @open_delay,
        "shadcn--hover-card-close-delay-value": @close_delay
      }
    end
  end
end
