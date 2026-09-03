# frozen_string_literal: true

module Shadcn
  # Context Menu Item component
  class ContextMenuItemComponent < BaseComponent
    BASE_CLASSES = "relative flex cursor-default items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-hidden select-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 data-[inset]:pl-8 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4 [&_svg:not([class*='text-'])]:text-muted-foreground"

    VARIANTS = {
      default: "",
      destructive: "text-destructive focus:bg-destructive/10 focus:text-destructive dark:focus:bg-destructive/20 data-[variant=destructive]:*:[svg]:text-destructive!"
    }.freeze

    renders_one :shortcut, lambda { |**options|
      ContextMenuShortcutComponent.new(**options)
    }

    # @param href [String, nil] Link URL
    # @param variant [Symbol] Item variant (:default, :destructive)
    # @param disabled [Boolean] Whether item is disabled
    # @param inset [Boolean] Whether to add left padding for icons
    def initialize(href: nil, variant: :default, disabled: false, inset: false, **options, &block)
      super(**options, &block)
      @href = href
      @variant = variant.to_sym
      @disabled = disabled
      @inset = inset
    end

    def call
      tag_name = @href ? :a : :div
      content_tag(tag_name, item_content, item_attributes)
    end

    private

    def item_content
      safe_join([content, shortcut].compact)
    end

    def item_classes
      cn(
        BASE_CLASSES,
        VARIANTS[@variant],
        @inset ? "data-[inset]:pl-8" : "",
        class_name
      )
    end

    def item_attributes
      attrs = {
        class: item_classes,
        role: "menuitem",
        tabindex: @disabled ? nil : "-1",
        href: @href,
        "data-disabled": @disabled ? "" : nil,
        "data-inset": @inset ? "" : nil,
        "data-variant": @variant.to_s,
        "data-shadcn--context-menu-target": "item",
        "data-action": "click->shadcn--context-menu#selectItem"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
