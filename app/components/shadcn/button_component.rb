# frozen_string_literal: true

module Shadcn
  # Button component with multiple variants and sizes
  # Matches shadcn/ui Button component
  #
  # @example Basic button
  #   <%= render Shadcn::ButtonComponent.new do %>
  #     Click me
  #   <% end %>
  #
  # @example Variant and size
  #   <%= render Shadcn::ButtonComponent.new(variant: :destructive, size: :lg) do %>
  #     Delete
  #   <% end %>
  #
  # @example As link
  #   <%= render Shadcn::ButtonComponent.new(href: "/path", variant: :link) do %>
  #     Go somewhere
  #   <% end %>
  #
  # @example Icon button
  #   <%= render Shadcn::ButtonComponent.new(size: :icon, aria: { label: "Settings" }) do %>
  #     <%= icon "settings" %>
  #   <% end %>
  #
  class ButtonComponent < BaseComponent
    # Available button variants
    VARIANTS = {
      default: "bg-primary text-primary-foreground hover:bg-primary/90",
      destructive: "bg-destructive text-white hover:bg-destructive/90 focus-visible:ring-destructive/20 dark:bg-destructive/60 dark:focus-visible:ring-destructive/40",
      outline: "border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground dark:border-input dark:bg-input/30 dark:hover:bg-input/50",
      secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
      ghost: "hover:bg-accent hover:text-accent-foreground dark:hover:bg-accent/50",
      link: "text-primary underline-offset-4 hover:underline"
    }.freeze

    # Available button sizes
    SIZES = {
      default: "h-9 px-4 py-2 has-[>svg]:px-3",
      sm: "h-8 gap-1.5 rounded-md px-3 has-[>svg]:px-2.5",
      lg: "h-10 rounded-md px-6 has-[>svg]:px-4",
      icon: "size-9",
      icon_sm: "size-8",
      icon_lg: "size-10"
    }.freeze

    # Base classes applied to all buttons
    BASE_CLASSES = "inline-flex shrink-0 items-center justify-center gap-2 rounded-md text-sm font-medium whitespace-nowrap transition-all outline-none focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"

    # @param variant [Symbol] Button style variant (:default, :destructive, :outline, :secondary, :ghost, :link)
    # @param size [Symbol] Button size (:default, :sm, :lg, :icon, :icon_sm, :icon_lg)
    # @param href [String, nil] If provided, renders as an anchor tag
    # @param type [String] Button type attribute (button, submit, reset)
    # @param disabled [Boolean] Whether button is disabled
    # @param loading [Boolean] Whether button shows loading state
    # @param class_name [String, nil] Additional CSS classes
    # @param data [Hash] Data attributes
    # @param html_options [Hash] Additional HTML attributes
    def initialize(
      variant: :default,
      size: :default,
      href: nil,
      type: "button",
      disabled: false,
      loading: false,
      **options
    )
      super(**options)
      @variant = variant.to_sym
      @size = size.to_sym
      @href = href
      @type = type
      @disabled = disabled
      @loading = loading
    end

    private

    def button_content
      if @loading
        safe_join([loading_spinner, content])
      else
        content
      end
    end

    def loading_spinner
      tag.span("", class: "animate-spin h-4 w-4 border-2 border-current border-t-transparent rounded-full", "aria-hidden": true)
    end

    def button_classes
      merge_classes(cn(
        BASE_CLASSES,
        VARIANTS[@variant],
        SIZES[@size]
      ))
    end

    def tag_attributes
      attrs = html_options.merge(build_data(slot: "button", variant: @variant, size: @size))
      attrs.map { |key, value| "#{key}=\"#{ERB::Util.html_escape_once(value)}\"" if value }.compact.join(" ").html_safe
    end
  end
end
