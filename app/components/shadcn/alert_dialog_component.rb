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

    private

    def alert_dialog_classes
      class_name
    end

    def alert_dialog_data_attrs
      {
        controller: "shadcn--dialog",
        "shadcn--dialog-open-value": @open.to_s,
        "shadcn--dialog-modal-value": "true"
      }
    end
  end
end
