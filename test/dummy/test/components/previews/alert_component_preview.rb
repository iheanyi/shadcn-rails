# frozen_string_literal: true

# @label Alert
class AlertComponentPreview < ViewComponent::Preview
  # @label Default
  def default
    render Ui::AlertComponent.new do |alert|
      alert.with_title { "Heads up!" }
      alert.with_description { "You can add components to your app using the cli." }
    end
  end

  # @label Destructive
  def destructive
    render Ui::AlertComponent.new(variant: :destructive) do |alert|
      alert.with_title { "Error" }
      alert.with_description { "Your session has expired. Please log in again." }
    end
  end
end
