# frozen_string_literal: true

module Shadcn
  # A link within the navigation menu (for items without dropdowns)
  class NavigationMenuLinkComponent < BaseComponent
    LINK_CLASSES = [
      "group inline-flex h-9 w-max items-center justify-center rounded-md bg-background px-4 py-2",
      "text-sm font-medium transition-colors",
      "hover:bg-accent hover:text-accent-foreground",
      "focus:bg-accent focus:text-accent-foreground focus:outline-none",
      "disabled:pointer-events-none disabled:opacity-50"
    ].join(" ").freeze

    ACTIVE_CLASSES = "bg-accent/50"

    # @param href [String] The link destination
    # @param active [Boolean] Whether this link is currently active
    def initialize(href:, active: false, **options)
      super(**options)
      @href = href
      @active = active
    end

    def call
      content_tag(:a, content, link_attributes)
    end

    private

    def link_attributes
      {
        class: cn(LINK_CLASSES, @active && ACTIVE_CLASSES, class_name),
        href: @href,
        "data-active": @active ? "true" : nil
      }.merge(html_options).compact
    end
  end
end
