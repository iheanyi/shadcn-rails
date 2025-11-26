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
      sm: "h-8 w-8 text-xs",
      default: "h-10 w-10 text-sm",
      lg: "h-12 w-12 text-base",
      xl: "h-16 w-16 text-lg"
    }.freeze

    BASE_CLASSES = "relative flex shrink-0 overflow-hidden rounded-full"
    IMAGE_CLASSES = "aspect-square h-full w-full"
    FALLBACK_CLASSES = "flex h-full w-full items-center justify-center rounded-full bg-muted"

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

    def call
      content_tag(:span, avatar_content, avatar_attributes)
    end

    private

    def avatar_content
      if @src.present?
        image_with_fallback
      elsif fallback?
        fallback
      else
        fallback_element
      end
    end

    def image_with_fallback
      # Use Stimulus controller to handle image loading errors
      content_tag(:span, class: "contents", data: stimulus_data(controller: "shadcn--avatar")) do
        safe_join([
          tag(:img,
            src: @src,
            alt: @alt,
            class: IMAGE_CLASSES,
            data: { "shadcn--avatar-target": "image", action: "error->shadcn--avatar#handleError" }
          ),
          content_tag(:span, @fallback, class: "#{FALLBACK_CLASSES} hidden", data: { "shadcn--avatar-target": "fallback" })
        ])
      end
    end

    def fallback_element
      content_tag(:span, @fallback, class: FALLBACK_CLASSES)
    end

    def avatar_classes
      cn(BASE_CLASSES, SIZES[@size], class_name)
    end

    def avatar_attributes
      attrs = { class: avatar_classes }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
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
