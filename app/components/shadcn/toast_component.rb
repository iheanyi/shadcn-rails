# frozen_string_literal: true

module Shadcn
  # Toast component for notifications
  # Matches shadcn/ui Toast component
  # Uses Stimulus for interactivity
  #
  # @example Basic toast (typically rendered via JavaScript/Turbo)
  #   <%= render Shadcn::ToastComponent.new(variant: :default) do |toast| %>
  #     <% toast.with_title { "Scheduled" } %>
  #     <% toast.with_description { "Your message has been scheduled." } %>
  #   <% end %>
  #
  # @example Destructive toast
  #   <%= render Shadcn::ToastComponent.new(variant: :destructive) do |toast| %>
  #     <% toast.with_title { "Error" } %>
  #     <% toast.with_description { "Something went wrong." } %>
  #     <% toast.with_action(alt_text: "Try again") do %>
  #       <%= render Shadcn::ButtonComponent.new(variant: :outline, size: :sm) { "Try again" } %>
  #     <% end %>
  #   <% end %>
  #
  class ToastComponent < BaseComponent
    VARIANTS = {
      default: "border bg-background text-foreground",
      destructive: "destructive group border-destructive bg-destructive text-destructive-foreground"
    }.freeze

    BASE_CLASSES = "group pointer-events-auto relative flex w-full items-center justify-between space-x-2 overflow-hidden rounded-md border p-4 pr-6 shadow-lg transition-all data-[swipe=cancel]:translate-x-0 data-[swipe=end]:translate-x-[var(--radix-toast-swipe-end-x)] data-[swipe=move]:translate-x-[var(--radix-toast-swipe-move-x)] data-[swipe=move]:transition-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[swipe=end]:animate-out data-[state=closed]:fade-out-80 data-[state=closed]:slide-out-to-right-full data-[state=open]:slide-in-from-top-full data-[state=open]:sm:slide-in-from-bottom-full"

    renders_one :title, lambda { |**options|
      ToastTitleComponent.new(**options)
    }
    renders_one :description, lambda { |**options|
      ToastDescriptionComponent.new(**options)
    }
    renders_one :action, lambda { |alt_text:, **options, &block|
      ToastActionComponent.new(alt_text: alt_text, **options, &block)
    }
    renders_one :close

    # @param variant [Symbol] Toast variant (:default, :destructive)
    # @param duration [Integer] Auto-dismiss duration in ms (0 for no auto-dismiss)
    # @param open [Boolean] Whether toast is visible
    def initialize(variant: :default, duration: 5000, open: true, **options)
      super(**options)
      @variant = variant.to_sym
      @duration = duration
      @open = open
    end

    def call
      content_tag(:li, toast_content, toast_attributes)
    end

    private

    def toast_content
      safe_join([
        content_wrapper,
        action,
        close_button
      ].compact)
    end

    def content_wrapper
      content_tag(:div, safe_join([title, description, content].compact), class: "grid gap-1")
    end

    def close_button
      close || default_close_button
    end

    def default_close_button
      content_tag(:button, close_icon, {
        type: "button",
        class: "absolute right-1 top-1 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none focus:ring-1 group-hover:opacity-100 group-[.destructive]:text-red-300 group-[.destructive]:hover:text-red-50 group-[.destructive]:focus:ring-red-400 group-[.destructive]:focus:ring-offset-red-600",
        "data-action": "click->shadcn--toast#close",
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

    def toast_classes
      cn(BASE_CLASSES, VARIANTS[@variant], class_name)
    end

    def toast_attributes
      attrs = {
        class: toast_classes,
        role: "status",
        "aria-live": "polite",
        "data-controller": "shadcn--toast",
        "data-shadcn--toast-duration-value": @duration,
        "data-shadcn--toast-open-value": @open.to_s,
        "data-state": @open ? "open" : "closed"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Toast Title component
  class ToastTitleComponent < BaseComponent
    BASE_CLASSES = "text-sm font-semibold [&+div]:text-xs"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES))
    end
  end

  # Toast Description component
  class ToastDescriptionComponent < BaseComponent
    BASE_CLASSES = "text-sm opacity-90"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES))
    end
  end

  # Toast Action component
  class ToastActionComponent < BaseComponent
    BASE_CLASSES = "inline-flex h-8 shrink-0 items-center justify-center rounded-md border bg-transparent px-3 text-sm font-medium transition-colors hover:bg-secondary focus:outline-none focus:ring-1 focus:ring-ring disabled:pointer-events-none disabled:opacity-50 group-[.destructive]:border-muted/40 group-[.destructive]:hover:border-destructive/30 group-[.destructive]:hover:bg-destructive group-[.destructive]:hover:text-destructive-foreground group-[.destructive]:focus:ring-destructive"

    # @param alt_text [String] Alternative text for accessibility
    def initialize(alt_text:, **options)
      super(**options)
      @alt_text = alt_text
    end

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), "aria-label": @alt_text)
    end
  end

  # Toast Viewport (container for all toasts)
  class ToastViewportComponent < BaseComponent
    BASE_CLASSES = "fixed top-0 z-[100] flex max-h-screen w-full flex-col-reverse p-4 sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]"

    def call
      content_tag(:ol, content, class: merge_classes(BASE_CLASSES), tabindex: "-1", "data-shadcn--toaster-target": "viewport")
    end
  end
end
