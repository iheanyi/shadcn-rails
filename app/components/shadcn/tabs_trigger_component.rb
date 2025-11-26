# frozen_string_literal: true

module Shadcn
  # Tabs Trigger component
  class TabsTriggerComponent < BaseComponent
    BASE_CLASSES = "inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow"

    # @param value [String] The value that identifies this tab
    # @param disabled [Boolean] Whether the tab is disabled
    def initialize(value:, disabled: false, **options)
      super(**options)
      @value = value
      @disabled = disabled
    end

    def call
      content_tag(:button, content, trigger_attributes)
    end

    private

    def trigger_attributes
      {
        type: "button",
        role: "tab",
        class: merge_classes(BASE_CLASSES),
        disabled: @disabled || nil,
        "data-shadcn--tabs-target": "trigger",
        "data-value": @value,
        "data-state": "inactive",
        "data-action": "click->shadcn--tabs#selectTab",
        "aria-selected": "false",
        tabindex: "-1"
      }
    end
  end
end
