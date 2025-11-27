# frozen_string_literal: true

module Shadcn
  # Content area that appears when a navigation trigger is activated
  class NavigationMenuContentComponent < BaseComponent
    CONTENT_CLASSES = [
      "left-0 top-0 w-full",
      "data-[motion^=from-]:animate-in data-[motion^=to-]:animate-out",
      "data-[motion^=from-]:fade-in data-[motion^=to-]:fade-out",
      "data-[motion=from-end]:slide-in-from-right-52 data-[motion=from-start]:slide-in-from-left-52",
      "data-[motion=to-end]:slide-out-to-right-52 data-[motion=to-start]:slide-out-to-left-52",
      "md:absolute md:w-auto"
    ].join(" ").freeze

    def call
      content_tag(:div, content, content_attributes)
    end

    private

    def content_attributes
      {
        class: cn(CONTENT_CLASSES, class_name),
        "data-shadcn--navigation-menu-target": "content",
        "data-state": "closed",
        hidden: true
      }.merge(html_options).compact
    end
  end
end
