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

    # @param open [Boolean] Whether dialog starts open
    # @param modal [Boolean] Whether dialog is modal (traps focus, blocks interaction)
    def initialize(open: false, modal: true, **options)
      super(**options)
      @open = open
      @modal = modal
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
        "data-shadcn--dialog-modal-value": @modal.to_s
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
