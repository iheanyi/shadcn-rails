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
    # Note: Named content_slot because 'content' is a reserved ViewComponent method
    renders_one :content_slot, lambda { |**options, &block|
      CardContentComponent.new(**options, &block)
    }

    # Alias for more intuitive API: card.with_content instead of card.with_content_slot
    alias_method :with_content, :with_content_slot

    # Card footer slot
    renders_one :footer, lambda { |**options, &block|
      CardFooterComponent.new(**options, &block)
    }

    BASE_CLASSES = "flex flex-col gap-6 rounded-xl border bg-card py-6 text-card-foreground shadow-sm"

    private

    def card_attributes
      merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "card" })
    end
  end
end
