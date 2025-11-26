# frozen_string_literal: true

module Shadcn
  # Alert Dialog component for important confirmation dialogs
  # Matches shadcn/ui AlertDialog component
  # Uses Stimulus for interactivity (reuses dialog controller)
  #
  # @example Basic alert dialog
  #   <%= render Shadcn::AlertDialogComponent.new do |dialog| %>
  #     <% dialog.with_trigger do %>
  #       <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Delete Account" } %>
  #     <% end %>
  #     <% dialog.with_body do |body| %>
  #       <% body.with_header do |header| %>
  #         <% header.with_title { "Are you absolutely sure?" } %>
  #         <% header.with_description { "This action cannot be undone." } %>
  #       <% end %>
  #       <% body.with_footer do |footer| %>
  #         <% footer.with_cancel { "Cancel" } %>
  #         <% footer.with_action { "Continue" } %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class AlertDialogComponent < BaseComponent
    renders_one :trigger
    renders_one :body, lambda { |**options|
      AlertDialogContentComponent.new(**options)
    }

    # @param open [Boolean] Whether dialog starts open
    def initialize(open: false, **options)
      super(**options)
      @open = open
    end

    def call
      content_tag(:div, dialog_content, dialog_attributes)
    end

    private

    def dialog_content
      safe_join([
        trigger_wrapper,
        body
      ].compact)
    end

    def trigger_wrapper
      return unless trigger

      content_tag(:div, trigger, {
        "data-shadcn--dialog-target": "trigger",
        "data-action": "click->shadcn--dialog#open"
      })
    end

    def dialog_attributes
      attrs = {
        class: class_name,
        "data-controller": "shadcn--dialog",
        "data-shadcn--dialog-open-value": @open.to_s,
        "data-shadcn--dialog-modal-value": "true"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Alert Dialog Content component
  class AlertDialogContentComponent < BaseComponent
    OVERLAY_CLASSES = "fixed inset-0 z-50 bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
    CONTENT_CLASSES = "fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%] data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg"

    renders_one :header, lambda { |**options|
      AlertDialogHeaderComponent.new(**options)
    }
    renders_one :footer, lambda { |**options|
      AlertDialogFooterComponent.new(**options)
    }

    def call
      content_tag(:template, content_wrapper, { "data-shadcn--dialog-target": "template" })
    end

    private

    def content_wrapper
      safe_join([
        overlay,
        dialog_panel
      ])
    end

    def overlay
      content_tag(:div, "", {
        class: OVERLAY_CLASSES,
        "data-shadcn--dialog-target": "overlay",
        "data-state": "closed",
        "aria-hidden": "true"
      })
    end

    def dialog_panel
      content_tag(:div, panel_content, {
        class: cn(CONTENT_CLASSES, class_name),
        role: "alertdialog",
        "aria-modal": "true",
        "data-shadcn--dialog-target": "content",
        "data-state": "closed",
        tabindex: "-1"
      })
    end

    def panel_content
      safe_join([
        header,
        content,
        footer
      ].compact)
    end
  end

  # Alert Dialog Header component
  class AlertDialogHeaderComponent < BaseComponent
    BASE_CLASSES = "flex flex-col space-y-2 text-center sm:text-left"

    renders_one :title, lambda { |**options|
      AlertDialogTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      AlertDialogDescriptionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([title, description, content].compact), class: merge_classes(BASE_CLASSES))
    end
  end

  # Alert Dialog Title component
  class AlertDialogTitleComponent < BaseComponent
    BASE_CLASSES = "text-lg font-semibold"

    def call
      content_tag(:h2, content, class: merge_classes(BASE_CLASSES))
    end
  end

  # Alert Dialog Description component
  class AlertDialogDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm text-muted-foreground"

    def call
      content_tag(:p, content, class: merge_classes(BASE_CLASSES))
    end
  end

  # Alert Dialog Footer component
  class AlertDialogFooterComponent < BaseComponent
    BASE_CLASSES = "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2"

    renders_one :cancel, lambda { |**options|
      AlertDialogCancelComponent.new(**options)
    }
    renders_one :action, lambda { |**options|
      AlertDialogActionComponent.new(**options)
    }

    def call
      content_tag(:div, safe_join([cancel, action, content].compact), class: merge_classes(BASE_CLASSES))
    end
  end

  # Alert Dialog Cancel button component
  class AlertDialogCancelComponent < BaseComponent
    BASE_CLASSES = "mt-2 sm:mt-0 inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground h-9 px-4 py-2"

    def call
      content_tag(:button, content, button_attributes)
    end

    private

    def button_attributes
      attrs = {
        type: "button",
        class: merge_classes(BASE_CLASSES),
        "data-action": "click->shadcn--dialog#close"
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end

  # Alert Dialog Action button component
  class AlertDialogActionComponent < BaseComponent
    BASE_CLASSES = "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground shadow hover:bg-primary/90 h-9 px-4 py-2"

    def call
      content_tag(:button, content, button_attributes)
    end

    private

    def button_attributes
      attrs = {
        type: "button",
        class: merge_classes(BASE_CLASSES),
        "data-action": "click->shadcn--dialog#close"
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end
end
