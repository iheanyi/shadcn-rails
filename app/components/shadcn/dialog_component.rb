# frozen_string_literal: true

module Shadcn
  # Dialog component for modal windows
  # Matches shadcn/ui Dialog component
  # Uses Stimulus for interactivity
  #
  # @example Basic dialog
  #   <%= render Shadcn::DialogComponent.new do |dialog| %>
  #     <% dialog.with_trigger do %>
  #       <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Open Dialog" } %>
  #     <% end %>
  #     <% dialog.with_content do |content| %>
  #       <% content.with_header do %>
  #         <% content.with_title { "Dialog Title" } %>
  #         <% content.with_description { "Dialog description here." } %>
  #       <% end %>
  #       <p>Dialog body content</p>
  #       <% content.with_footer do %>
  #         <%= render Shadcn::ButtonComponent.new { "Save" } %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class DialogComponent < BaseComponent
    renders_one :trigger
    renders_one :body, lambda { |**options|
      DialogContentComponent.new(**options)
    }
    alias_method :with_content, :with_body

    # @param id [String] Unique identifier for the dialog (used for Turbo Stream targeting)
    # @param open [Boolean] Whether dialog starts open
    # @param modal [Boolean] Whether dialog is modal (traps focus, blocks interaction)
    def initialize(id: nil, open: false, modal: true, **options)
      super(**options)
      @id = id
      @open = open
      @modal = modal
    end

    private

    def dialog_classes
      class_name
    end

    def dialog_data_attrs
      {
        controller: "shadcn--dialog",
        "shadcn--dialog-open-value": @open.to_s,
        "shadcn--dialog-modal-value": @modal.to_s,
        "dialog-id": @id
      }
    end
  end
end
