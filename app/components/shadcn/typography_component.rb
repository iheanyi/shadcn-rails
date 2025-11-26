# frozen_string_literal: true

module Shadcn
  # Typography component for consistent text styling
  # Matches shadcn/ui Typography component
  #
  # @example Heading 1
  #   <%= render Shadcn::TypographyComponent.new(variant: :h1) { "Heading 1" } %>
  #
  # @example Heading 2
  #   <%= render Shadcn::TypographyComponent.new(variant: :h2) { "Heading 2" } %>
  #
  # @example Paragraph
  #   <%= render Shadcn::TypographyComponent.new(variant: :p) { "This is a paragraph of text." } %>
  #
  # @example Lead text
  #   <%= render Shadcn::TypographyComponent.new(variant: :lead) { "A modal dialog that interrupts the user." } %>
  #
  # @example Muted text
  #   <%= render Shadcn::TypographyComponent.new(variant: :muted) { "Enter your email address." } %>
  #
  # @example Blockquote
  #   <%= render Shadcn::TypographyComponent.new(variant: :blockquote) { "After all, everyone enjoys a good quote." } %>
  #
  # @example Inline code
  #   <%= render Shadcn::TypographyComponent.new(variant: :code) { "@radix-ui/react-alert-dialog" } %>
  #
  class TypographyComponent < BaseComponent
    VARIANTS = {
      h1: {
        tag: :h1,
        classes: "scroll-m-20 text-4xl font-extrabold tracking-tight lg:text-5xl"
      },
      h2: {
        tag: :h2,
        classes: "scroll-m-20 border-b pb-2 text-3xl font-semibold tracking-tight first:mt-0"
      },
      h3: {
        tag: :h3,
        classes: "scroll-m-20 text-2xl font-semibold tracking-tight"
      },
      h4: {
        tag: :h4,
        classes: "scroll-m-20 text-xl font-semibold tracking-tight"
      },
      p: {
        tag: :p,
        classes: "leading-7 [&:not(:first-child)]:mt-6"
      },
      lead: {
        tag: :p,
        classes: "text-xl text-muted-foreground"
      },
      large: {
        tag: :div,
        classes: "text-lg font-semibold"
      },
      small: {
        tag: :small,
        classes: "text-sm font-medium leading-none"
      },
      muted: {
        tag: :p,
        classes: "text-sm text-muted-foreground"
      },
      blockquote: {
        tag: :blockquote,
        classes: "mt-6 border-l-2 pl-6 italic"
      },
      code: {
        tag: :code,
        classes: "relative rounded bg-muted px-[0.3rem] py-[0.2rem] font-mono text-sm font-semibold"
      },
      list: {
        tag: :ul,
        classes: "my-6 ml-6 list-disc [&>li]:mt-2"
      }
    }.freeze

    # @param variant [Symbol] Typography variant (:h1, :h2, :h3, :h4, :p, :lead, :large, :small, :muted, :blockquote, :code, :list)
    # @param tag [Symbol, nil] Override the default HTML tag
    def initialize(variant: :p, tag: nil, **options)
      super(**options)
      @variant = variant.to_sym
      @tag = tag
    end

    def call
      content_tag(element_tag, content, **typography_attributes)
    end

    private

    def typography_attributes
      {
        class: merge_classes(variant_classes)
      }.merge(html_options).merge(build_data).compact
    end

    def variant_config
      VARIANTS[@variant] || VARIANTS[:p]
    end

    def variant_classes
      variant_config[:classes]
    end

    def element_tag
      @tag || variant_config[:tag]
    end
  end
end
