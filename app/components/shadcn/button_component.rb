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
      default: "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90",
      destructive: "bg-destructive text-destructive-foreground shadow-xs hover:bg-destructive/90",
      outline: "border border-input bg-background shadow-xs hover:bg-accent hover:text-accent-foreground",
      secondary: "bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80",
      ghost: "hover:bg-accent hover:text-accent-foreground",
      link: "text-primary underline-offset-4 hover:underline"
    }.freeze

    # Available button sizes
    SIZES = {
      default: "h-9 px-4 py-2",
      sm: "h-8 rounded-md px-3 text-xs",
      lg: "h-10 rounded-md px-8",
      icon: "h-9 w-9",
      icon_sm: "h-8 w-8",
      icon_lg: "h-10 w-10"
    }.freeze

    # Base classes applied to all buttons
    BASE_CLASSES = "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0"

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
      cn(
        BASE_CLASSES,
        VARIANTS[@variant],
        SIZES[@size],
        class_name
      )
    end

    def tag_attributes
      attrs = html_options.merge(build_data)
      attrs.map { |k, v| "#{k}=\"#{ERB::Util.html_escape(v)}\"" if v }.compact.join(" ").html_safe
    end
  end
end
