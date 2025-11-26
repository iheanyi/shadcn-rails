# frozen_string_literal: true

# @label Alert
# @display bg_color "#ffffff"
class AlertComponentPreview < ViewComponent::Preview
  # @label Default
  # Default alert style
  def default
    render(Shadcn::AlertComponent.new) do |alert|
      alert.with_title { "Heads up!" }
      alert.with_description { "You can add components to your app using the cli." }
    end
  end

  # @label Destructive
  # Destructive alert for errors
  def destructive
    render(Shadcn::AlertComponent.new(variant: :destructive)) do |alert|
      alert.with_title { "Error" }
      alert.with_description { "Your session has expired. Please log in again." }
    end
  end

  # @label With Icon
  # Alert with an icon
  def with_icon
    render(Shadcn::AlertComponent.new) do |alert|
      alert.with_icon do
        '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>'.html_safe
      end
      alert.with_title { "Information" }
      alert.with_description { "This is an informational message about an important update." }
    end
  end

  # @label Success Style
  # Custom success alert using class override
  def success
    render(Shadcn::AlertComponent.new(class_name: "border-green-500/50 text-green-700 [&>svg]:text-green-700")) do |alert|
      alert.with_icon do
        '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>'.html_safe
      end
      alert.with_title { "Success" }
      alert.with_description { "Your changes have been saved successfully." }
    end
  end
end
