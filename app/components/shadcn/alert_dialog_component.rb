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
end
