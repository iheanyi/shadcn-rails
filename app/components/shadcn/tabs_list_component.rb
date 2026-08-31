# frozen_string_literal: true

module Shadcn
  # Tabs List component
  class TabsListComponent < BaseComponent
    BASE_CLASSES = "group/tabs-list inline-flex w-fit items-center justify-center rounded-lg p-[3px] text-muted-foreground group-data-[orientation=horizontal]/tabs:h-9 group-data-[orientation=vertical]/tabs:h-fit group-data-[orientation=vertical]/tabs:flex-col data-[variant=line]:rounded-none"
    VARIANTS = {
      default: "bg-muted",
      line: "gap-1 bg-transparent"
    }.freeze

    renders_many :triggers, lambda { |value:, **options, &block|
      TabsTriggerComponent.new(value: value, **options, &block)
    }

    # @param variant [Symbol] Visual style (:default, :line)
    def initialize(variant: :default, **options)
      super(**options)
      @variant = variant.to_sym
    end

    def call
      content_tag(:div, list_content, list_attributes)
    end

    private

    def list_content
      safe_join([triggers, content].compact.flatten)
    end

    def list_attributes
      {
        class: merge_classes(cn(BASE_CLASSES, VARIANTS.fetch(@variant, VARIANTS[:default]))),
        role: "tablist",
        "data-slot": "tabs-list",
        "data-variant": @variant,
        "data-shadcn--tabs-target": "list"
      }
    end
  end
end
