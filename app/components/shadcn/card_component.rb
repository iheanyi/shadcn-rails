# frozen_string_literal: true

module Shadcn
  # Card component with header, content, and footer slots
  # Matches shadcn/ui Card component
  #
  # @example Basic card
  #   <%= render Shadcn::CardComponent.new do |card| %>
  #     <% card.with_header do %>
  #       <% card.with_title { "Card Title" } %>
  #       <% card.with_description { "Card description" } %>
  #     <% end %>
  #     <% card.with_content do %>
  #       Card content goes here
  #     <% end %>
  #     <% card.with_footer do %>
  #       <button>Action</button>
  #     <% end %>
  #   <% end %>
  #
  class CardComponent < BaseComponent
    # Card header slot
    renders_one :header, lambda { |**options, &block|
      CardHeaderComponent.new(**options, &block)
    }

    # Card title slot (can be used inside or outside header)
    renders_one :title, lambda { |**options, &block|
      CardTitleComponent.new(**options, &block)
    }

    # Card description slot
    renders_one :description, lambda { |**options, &block|
      CardDescriptionComponent.new(**options, &block)
    }

    # Card content slot
    renders_one :content_slot, lambda { |**options, &block|
      CardContentComponent.new(**options, &block)
    }

    # Card footer slot
    renders_one :footer, lambda { |**options, &block|
      CardFooterComponent.new(**options, &block)
    }

    BASE_CLASSES = "rounded-xl border bg-card text-card-foreground shadow"

    def call
      content_tag(:div, card_content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
    end

    private

    def card_content
      safe_join([header, title, description, content_slot, content, footer].compact)
    end
  end
end
