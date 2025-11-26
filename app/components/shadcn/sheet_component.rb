# frozen_string_literal: true

module Shadcn
  # Sheet component for slide-out panels
  # Matches shadcn/ui Sheet component
  # Uses Stimulus for interactivity
  #
  # @example Basic sheet
  #   <%= render Shadcn::SheetComponent.new(side: :right) do |sheet| %>
  #     <% sheet.with_trigger do %>
  #       <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Open Sheet" } %>
  #     <% end %>
  #     <% sheet.with_content do |content| %>
  #       <% content.with_header do %>
  #         <% content.with_title { "Edit Profile" } %>
  #         <% content.with_description { "Make changes to your profile." } %>
  #       <% end %>
  #       <div class="py-4">
  #         Sheet body content
  #       </div>
  #       <% content.with_footer do %>
  #         <%= render Shadcn::ButtonComponent.new { "Save changes" } %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class SheetComponent < BaseComponent
    SIDES = {
      top: "inset-x-0 top-0 border-b data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top",
      bottom: "inset-x-0 bottom-0 border-t data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom",
      left: "inset-y-0 left-0 h-full w-3/4 border-r data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left sm:max-w-sm",
      right: "inset-y-0 right-0 h-full w-3/4 border-l data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right sm:max-w-sm"
    }.freeze

    renders_one :trigger
    renders_one :body, lambda { |**options|
      SheetContentComponent.new(side: @side, **options)
    }

    # @param side [Symbol] Side to show sheet (:top, :right, :bottom, :left)
    # @param open [Boolean] Whether sheet starts open
    def initialize(side: :right, open: false, **options)
      super(**options)
      @side = side.to_sym
      @open = open
    end

    def call
      content_tag(:div, sheet_structure, sheet_attributes)
    end

    private

    def sheet_structure
      safe_join([
        trigger_wrapper,
        body
      ].compact)
    end

    def trigger_wrapper
      return unless trigger

      content_tag(:div, trigger, {
        "data-shadcn--sheet-target": "trigger",
        "data-action": "click->shadcn--sheet#open"
      })
    end

    def sheet_attributes
      attrs = {
        class: class_name,
        "data-controller": "shadcn--sheet",
        "data-shadcn--sheet-open-value": @open.to_s,
        "data-shadcn--sheet-side-value": @side.to_s
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Sheet Content component
  class SheetContentComponent < BaseComponent
    OVERLAY_CLASSES = "fixed inset-0 z-50 bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
    BASE_CONTENT_CLASSES = "fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out data-[state=closed]:duration-300 data-[state=open]:duration-500 data-[state=open]:animate-in data-[state=closed]:animate-out"
    CLOSE_CLASSES = "absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-secondary"

    renders_one :header, lambda { |**options|
      SheetHeaderComponent.new(**options)
    }
    renders_one :title, lambda { |**options|
      SheetTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      SheetDescriptionComponent.new(**options)
    }
    renders_one :footer, lambda { |**options|
      SheetFooterComponent.new(**options)
    }

    # @param side [Symbol] Side the sheet appears from
    def initialize(side: :right, **options)
      super(**options)
      @side = side.to_sym
    end

    def call
      content_tag(:template, content_wrapper, { "data-shadcn--sheet-target": "template" })
    end

    private

    def content_wrapper
      safe_join([overlay, sheet_panel])
    end

    def overlay
      content_tag(:div, "", {
        class: OVERLAY_CLASSES,
        "data-shadcn--sheet-target": "overlay",
        "data-action": "click->shadcn--sheet#close",
        "data-state": "closed"
      })
    end

    def sheet_panel
      content_tag(:div, panel_content, panel_attributes)
    end

    def panel_content
      safe_join([
        header,
        title,
        description,
        content,
        footer,
        close_button
      ].compact)
    end

    def panel_attributes
      {
        class: cn(BASE_CONTENT_CLASSES, SheetComponent::SIDES[@side], class_name),
        role: "dialog",
        "aria-modal": "true",
        "data-shadcn--sheet-target": "content",
        "data-state": "closed",
        tabindex: "-1"
      }
    end

    def close_button
      content_tag(:button, close_icon, {
        type: "button",
        class: CLOSE_CLASSES,
        "data-action": "click->shadcn--sheet#close",
        "aria-label": "Close"
      })
    end

    def close_icon
      content_tag(:svg,
        content_tag(:path, nil, d: "M18 6 6 18M6 6l12 12", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round", "stroke-linejoin": "round"),
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "none",
        class: "h-4 w-4"
      )
    end
  end

  # Sheet Header component
  class SheetHeaderComponent < BaseComponent
    BASE_CLASSES = "flex flex-col space-y-2 text-center sm:text-left"

    renders_one :title, lambda { |**options|
      SheetTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      SheetDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([title, description, content].compact), class: merge_classes(BASE_CLASSES))
    end
  end

  # Sheet Title component
  class SheetTitleComponent < BaseComponent
    BASE_CLASSES = "text-lg font-semibold text-foreground"

    def call
      content_tag(:h2, content, class: merge_classes(BASE_CLASSES))
    end
  end

  # Sheet Description component
  class SheetDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm text-muted-foreground"

    def call
      content_tag(:p, content, class: merge_classes(BASE_CLASSES))
    end
  end

  # Sheet Footer component
  class SheetFooterComponent < BaseComponent
    BASE_CLASSES = "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
