# frozen_string_literal: true

module Shadcn
  # Alert Dialog Cancel button component
  class AlertDialogCancelComponent < BaseComponent
    def call
      render ButtonComponent.new(
        variant: :outline,
        class_name: class_name,
        data: button_data,
        **html_options
      ) do
        content
      end
    end

    private

    def button_data
      merge_data_attributes(
        { slot: "alert-dialog-cancel", action: "click->shadcn--dialog#close" },
        data
      ).transform_keys { |key| key.delete_prefix("data-") }
    end
  end
end
