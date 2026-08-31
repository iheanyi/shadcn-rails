# frozen_string_literal: true

module Shadcn
  # Avatar component for user profile images
  # Matches shadcn/ui Avatar component
  #
  # @example Basic avatar with image
  #   <%= render Shadcn::AvatarComponent.new(src: user.avatar_url, alt: user.name) %>
  #
  # @example With fallback
  #   <%= render Shadcn::AvatarComponent.new(src: user.avatar_url, alt: user.name, fallback: user.initials) %>
  #
  # @example Different sizes
  #   <%= render Shadcn::AvatarComponent.new(src: url, alt: name, size: :sm) %>
  #   <%= render Shadcn::AvatarComponent.new(src: url, alt: name, size: :lg) %>
  #
  # @example With slot-based fallback
  #   <%= render Shadcn::AvatarComponent.new(size: :sm) do |avatar| %>
  #     <% avatar.with_fallback { "JD" } %>
  #   <% end %>
  #
  class AvatarComponent < BaseComponent
    renders_one :fallback, ->(class: nil, **options, &block) {
      AvatarFallbackComponent.new(class: binding.local_variable_get(:class), **options, &block)
    }
    SIZES = {
      sm: nil,
      default: nil,
      lg: nil,
      xl: "size-16"
    }.freeze

    BASE_CLASSES = "group/avatar relative flex size-8 shrink-0 overflow-hidden rounded-full select-none data-[size=lg]:size-10 data-[size=sm]:size-6"
    IMAGE_CLASSES = "aspect-square size-full"
    FALLBACK_CLASSES = "flex size-full items-center justify-center rounded-full bg-muted text-sm text-muted-foreground group-data-[size=sm]/avatar:text-xs"

    # @param src [String, nil] Image URL
    # @param alt [String] Alt text for the image
    # @param fallback [String, nil] Fallback text when image fails to load
    # @param size [Symbol] Avatar size (:sm, :default, :lg, :xl)
    def initialize(src: nil, alt: "", fallback: nil, size: :default, **options)
      super(**options)
      @src = src
      @alt = alt
      @fallback = fallback || generate_fallback(alt)
      @size = size.to_sym
    end

    private

    def avatar_classes
      cn(BASE_CLASSES, SIZES[@size], class_name)
    end

    def fallback_text
      @fallback
    end

    def has_image?
      @src.present?
    end

    def has_fallback_slot?
      fallback?
    end

    def generate_fallback(alt)
      return "" if alt.blank?

      # Generate initials from name
      words = alt.split
      if words.length >= 2
        "#{words.first[0]}#{words.last[0]}".upcase
      else
        alt[0..1].upcase
      end
    end
  end
end
