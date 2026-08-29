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

    BASE_CLASSES = "shadcn-toast group pointer-events-auto relative flex w-full items-center justify-between space-x-2 overflow-hidden rounded-md border p-4 pr-6 shadow-lg transition-all data-[swipe=cancel]:translate-x-0 data-[swipe=end]:translate-x-[var(--radix-toast-swipe-end-x)] data-[swipe=move]:translate-x-[var(--radix-toast-swipe-move-x)] data-[swipe=move]:transition-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[swipe=end]:animate-out data-[state=open]:fade-in-0 data-[state=closed]:fade-out-0 data-[state=open]:slide-in-from-right-full data-[state=closed]:slide-out-to-right-full"

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

    private

    def toast_classes
      cn(BASE_CLASSES, VARIANTS[@variant], class_name)
    end

    def has_custom_close?
      close?
    end

    def data_state
      @open ? "open" : "closed"
    end
  end
end
