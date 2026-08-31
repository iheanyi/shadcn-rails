# frozen_string_literal: true

module Shadcn
  # Alert component for displaying important messages
  # Matches shadcn/ui Alert component
  #
  # @example Basic alert
  #   <%= render Shadcn::AlertComponent.new do |alert| %>
  #     <% alert.with_title { "Heads up!" } %>
  #     <% alert.with_description { "You can add components to your app using the cli." } %>
  #   <% end %>
  #
  # @example Destructive alert
  #   <%= render Shadcn::AlertComponent.new(variant: :destructive) do |alert| %>
  #     <% alert.with_title { "Error" } %>
  #     <% alert.with_description { "Something went wrong." } %>
  #   <% end %>
  #
  # @example With icon
  #   <%= render Shadcn::AlertComponent.new do |alert| %>
  #     <% alert.with_icon do %>
  #       <%= icon "info" %>
  #     <% end %>
  #     <% alert.with_title { "Note" } %>
  #     <% alert.with_description { "This is an informational message." } %>
  #   <% end %>
  #
  class AlertComponent < BaseComponent
    # Available alert variants
    VARIANTS = {
      default: "bg-card text-card-foreground",
      destructive: "bg-card text-destructive *:data-[slot=alert-description]:text-destructive/90 [&>svg]:text-current"
    }.freeze

    BASE_CLASSES = "relative grid w-full grid-cols-[0_1fr] items-start gap-y-0.5 rounded-lg border px-4 py-3 text-sm has-[>svg]:grid-cols-[calc(var(--spacing)*4)_1fr] has-[>svg]:gap-x-3 [&>svg]:size-4 [&>svg]:translate-y-0.5 [&>svg]:text-current"

    renders_one :icon
    renders_one :title, lambda { |**options|
      AlertTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      AlertDescriptionComponent.new(**options)
    }

    # @param variant [Symbol] Alert style variant (:default, :destructive)
    def initialize(variant: :default, **options)
      super(**options)
      @variant = variant.to_sym
    end

    private

    def alert_classes
      cn(BASE_CLASSES, VARIANTS[@variant], class_name)
    end
  end
end
