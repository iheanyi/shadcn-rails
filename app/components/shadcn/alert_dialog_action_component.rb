# frozen_string_literal: true

module Shadcn
  # Alert Dialog Action button component
  class AlertDialogActionComponent < BaseComponent
    def call
      render ButtonComponent.new(
        variant: :default,
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
        { slot: "alert-dialog-action", action: "click->shadcn--dialog#close" },
        data
      ).transform_keys { |key| key.delete_prefix("data-") }
    end
  end
end
