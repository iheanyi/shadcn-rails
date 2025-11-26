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

  # Card Header component
  class CardHeaderComponent < BaseComponent
    BASE_CLASSES = "flex flex-col space-y-1.5 p-6"

    renders_one :title, lambda { |**options|
      CardTitleComponent.new(**options)
    }

    renders_one :description, lambda { |**options|
      CardDescriptionComponent.new(**options)
    }

    renders_one :action, "CardActionComponent"

    def call
      content_tag(:div, class: merge_classes(BASE_CLASSES), **html_options) do
        safe_join([title, description, action, content].compact)
      end
    end
  end

  # Card Title component
  class CardTitleComponent < BaseComponent
    BASE_CLASSES = "font-semibold leading-none tracking-tight"

    # @param tag [Symbol] HTML tag to use (default: :h3)
    def initialize(tag: :h3, **options)
      super(**options)
      @tag = tag
    end

    def call
      content_tag(@tag, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end

  # Card Description component
  class CardDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm text-muted-foreground"

    def call
      content_tag(:p, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end

  # Card Action component
  class CardActionComponent < BaseComponent
    def call
      content_tag(:div, content, **html_options)
    end
  end

  # Card Content component
  class CardContentComponent < BaseComponent
    BASE_CLASSES = "p-6"

    # @param standalone [Boolean] Whether the content is standalone (no header above)
    def initialize(standalone: false, **options)
      super(**options)
      @standalone = standalone
    end

    def call
      classes = @standalone ? BASE_CLASSES : "#{BASE_CLASSES} pt-0"
      content_tag(:div, content, class: merge_classes(classes), **html_options)
    end
  end

  # Card Footer component
  class CardFooterComponent < BaseComponent
    BASE_CLASSES = "flex items-center p-6 pt-0"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end
end
