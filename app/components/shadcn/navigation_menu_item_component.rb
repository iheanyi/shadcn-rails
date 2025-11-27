# frozen_string_literal: true

module Shadcn
  # Individual item in the navigation menu
  class NavigationMenuItemComponent < BaseComponent
    renders_one :trigger, lambda { |**options, &block|
      NavigationMenuTriggerComponent.new(**options, &block)
    }

    renders_one :dropdown, lambda { |**options, &block|
      NavigationMenuContentComponent.new(**options, &block)
    }

    renders_one :link, lambda { |href:, active: false, **options, &block|
      NavigationMenuLinkComponent.new(href: href, active: active, **options, &block)
    }

    def call
      content_tag(:li, item_content, item_attributes)
    end

    private

    def item_content
      if link
        link
      else
        safe_join([trigger, dropdown].compact)
      end
    end

    def item_attributes
      {
        class: cn("relative", class_name),
        "data-shadcn--navigation-menu-target": "item"
      }.merge(html_options).compact
    end
  end
end
