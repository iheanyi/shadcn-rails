# frozen_string_literal: true

module Shadcn
  # Drawer component for mobile-optimized modal panels
  # Matches shadcn/ui Drawer component (built on Vaul)
  #
  # @example Basic drawer
  #   <%= render Shadcn::DrawerComponent.new do |drawer| %>
  #     <% drawer.with_trigger do %>
  #       <%= render Shadcn::ButtonComponent.new { "Open Drawer" } %>
  #     <% end %>
  #     <% drawer.with_body do |body| %>
  #       <% body.with_header do |header| %>
  #         <% header.with_title { "Edit Profile" } %>
  #         <% header.with_description { "Make changes to your profile." } %>
  #       <% end %>
  #       <div class="p-4">Content here</div>
  #       <% body.with_footer do %>
  #         <%= render Shadcn::ButtonComponent.new { "Save" } %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class DrawerComponent < BaseComponent
    renders_one :trigger
    renders_one :body, lambda { |**options|
      DrawerContentComponent.new(**options)
    }

    # @param open [Boolean] Whether drawer starts open
    # @param direction [Symbol] :bottom, :top, :left, or :right
    def initialize(open: false, direction: :bottom, **options)
      super(**options)
      @open = open
      @direction = direction
    end

    def call
      content_tag(:div, drawer_content, drawer_attributes)
    end

    private

    def drawer_content
      safe_join([
        trigger_wrapper,
        body
      ].compact)
    end

    def trigger_wrapper
      return unless trigger

      content_tag(:div, trigger, {
        "data-shadcn--drawer-target": "trigger",
        "data-action": "click->shadcn--drawer#open"
      })
    end

    def drawer_attributes
      attrs = {
        class: class_name,
        "data-controller": "shadcn--drawer",
        "data-shadcn--drawer-open-value": @open.to_s,
        "data-shadcn--drawer-direction-value": @direction.to_s
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Drawer Content component
  class DrawerContentComponent < BaseComponent
    OVERLAY_CLASSES = "fixed inset-0 z-50 bg-black/80"
    CONTENT_CLASSES = {
      bottom: "fixed inset-x-0 bottom-0 z-50 mt-24 flex h-auto flex-col rounded-t-[10px] border bg-background",
      top: "fixed inset-x-0 top-0 z-50 mb-24 flex h-auto flex-col rounded-b-[10px] border bg-background",
      left: "fixed inset-y-0 left-0 z-50 h-full w-3/4 max-w-sm flex flex-col border-r bg-background",
      right: "fixed inset-y-0 right-0 z-50 h-full w-3/4 max-w-sm flex flex-col border-l bg-background"
    }.freeze

    renders_one :header, lambda { |**options|
      DrawerHeaderComponent.new(**options)
    }
    renders_one :footer, lambda { |**options|
      DrawerFooterComponent.new(**options)
    }

    # @param direction [Symbol] :bottom, :top, :left, or :right
    def initialize(direction: :bottom, **options)
      super(**options)
      @direction = direction
    end

    def call
      content_tag(:template, content_wrapper, { "data-shadcn--drawer-target": "template" })
    end

    private

    def content_wrapper
      safe_join([
        overlay,
        drawer_panel
      ])
    end

    def overlay
      content_tag(:div, "", {
        class: OVERLAY_CLASSES,
        "data-shadcn--drawer-target": "overlay",
        "data-action": "click->shadcn--drawer#close",
        "data-state": "closed"
      })
    end

    def drawer_panel
      content_tag(:div, panel_content, {
        class: cn(CONTENT_CLASSES[@direction] || CONTENT_CLASSES[:bottom], class_name),
        role: "dialog",
        "aria-modal": "true",
        "data-shadcn--drawer-target": "content",
        "data-state": "closed",
        tabindex: "-1"
      })
    end

    def panel_content
      safe_join([
        handle_bar,
        header,
        content,
        footer
      ].compact)
    end

    def handle_bar
      return unless [:bottom, :top].include?(@direction)

      content_tag(:div, class: "mx-auto mt-4 h-2 w-[100px] rounded-full bg-muted") { "" }
    end
  end

  # Drawer Header component
  class DrawerHeaderComponent < BaseComponent
    BASE_CLASSES = "grid gap-1.5 p-4 text-center sm:text-left"

    renders_one :title, lambda { |**options|
      DrawerTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      DrawerDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([title, description, content].compact), class: merge_classes(BASE_CLASSES))
    end
  end

  # Drawer Title component
  class DrawerTitleComponent < BaseComponent
    BASE_CLASSES = "text-lg font-semibold leading-none tracking-tight"

    def call
      content_tag(:h2, content, class: merge_classes(BASE_CLASSES))
    end
  end

  # Drawer Description component
  class DrawerDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm text-muted-foreground"

    def call
      content_tag(:p, content, class: merge_classes(BASE_CLASSES))
    end
  end

  # Drawer Footer component
  class DrawerFooterComponent < BaseComponent
    BASE_CLASSES = "mt-auto flex flex-col gap-2 p-4"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
