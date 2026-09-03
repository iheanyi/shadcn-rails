# frozen_string_literal: true

module Shadcn
  # A link within the navigation menu (for items without dropdowns)
  class NavigationMenuLinkComponent < BaseComponent
    LINK_CLASSES = [
      "flex flex-col gap-1 rounded-sm p-2",
      "text-sm transition-all outline-none",
      "hover:bg-accent hover:text-accent-foreground",
      "focus:bg-accent focus:text-accent-foreground focus-visible:ring-[3px] focus-visible:ring-ring/50 focus-visible:outline-1",
      "disabled:pointer-events-none disabled:opacity-50"
    ].join(" ").freeze

    ACTIVE_CLASSES = "bg-accent/50 text-accent-foreground hover:bg-accent focus:bg-accent"

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
        "data-slot": "navigation-menu-link",
        "data-active": @active ? "true" : nil
      }.merge(html_options).compact
    end
  end
end
