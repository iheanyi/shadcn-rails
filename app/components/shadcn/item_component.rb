# frozen_string_literal: true

module Shadcn
  # Item component - a flexible flex container for titles, descriptions, and actions
  # Matches shadcn/ui Item component
  #
  # @example Basic item
  #   <%= render Shadcn::ItemComponent.new do |item| %>
  #     <% item.with_media(variant: :icon) do %>
  #       <svg>...</svg>
  #     <% end %>
  #     <% item.with_content do |content| %>
  #       <% content.with_title { "Item Title" } %>
  #       <% content.with_description { "Item description" } %>
  #     <% end %>
  #     <% item.with_actions do %>
  #       <%= render Shadcn::ButtonComponent.new(size: :sm) { "Action" } %>
  #     <% end %>
  #   <% end %>
  #
  # @example With variants
  #   <%= render Shadcn::ItemComponent.new(variant: :outline) do |item| %>
  #     ...
  #   <% end %>
  #
  class ItemComponent < BaseComponent
    VARIANTS = {
      default: "bg-transparent",
      outline: "border-border",
      muted: "bg-muted/50"
    }.freeze

    SIZES = {
      default: "p-4 gap-4",
      sm: "gap-2.5 px-4 py-3"
    }.freeze

    BASE_CLASSES = "group/item flex flex-wrap items-center rounded-md border border-transparent text-sm transition-colors duration-100 outline-none focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 [a]:transition-colors [a]:hover:bg-accent/50"

    # Media slot for icons, images, or avatars
    renders_one :media, lambda { |variant: :default, **options|
      ItemMediaComponent.new(variant: variant, **options)
    }

    # Content slot for title and description
    renders_one :content_slot, lambda { |**options|
      ItemContentComponent.new(**options)
    }

    # Alias for more intuitive API
    alias_method :with_content, :with_content_slot

    # Actions slot for buttons
    renders_one :actions, lambda { |**options|
      ItemActionsComponent.new(**options)
    }

    # Header slot
    renders_one :header, lambda { |**options|
      ItemHeaderComponent.new(**options)
    }

    # Footer slot
    renders_one :footer, lambda { |**options|
      ItemFooterComponent.new(**options)
    }

    # @param variant [Symbol] :default, :outline, or :muted
    # @param size [Symbol] :default or :sm
    # @param tag [Symbol] HTML tag to use (:div, :li, :a, etc.)
    # @param href [String] URL for link items (uses :a tag automatically)
    def initialize(variant: :default, size: :default, tag: :div, href: nil, **options)
      super(**options)
      @variant = variant.to_sym
      @size = size.to_sym
      @tag = href ? :a : tag
      @href = href
    end

    def call
      content_tag(@tag, item_content, **item_attributes)
    end

    private

    def item_content
      safe_join([header, media, content_slot, content, actions, footer].compact)
    end

    def item_attributes
      attrs = {
        class: merge_classes(cn(BASE_CLASSES, VARIANTS[@variant], SIZES[@size])),
        href: @href
      }.compact
      merge_html_attributes(attrs, slot: "item", variant: @variant, size: @size)
    end
  end
end
