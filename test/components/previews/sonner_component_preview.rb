# frozen_string_literal: true

# @label Sonner
# @display bg_color "#ffffff"
class SonnerComponentPreview < ViewComponent::Preview
  # @label Default
  # Recommended toast API with a persistent toaster viewport
  def default
    render(Shadcn::SonnerComponent.new(id: "sonner-default-viewport", limit: 5, duration: 15_000)) do
      <<~HTML.html_safe
        <div class="flex flex-wrap gap-2">
          #{demo_button("Create invoice", "Invoice created", "Invoice #1042 was created for Acme Studio.", "default", 0)}
          #{demo_button("Save customer", "Customer saved", "Billing contact and tax ID were updated.", "success", 0)}
          #{demo_button("Simulate error", "Payment failed", "The card was declined. Ask the customer for another payment method.", "destructive", 0)}
          #{demo_button("Warn shipping", "Address needs review", "Shipping rates changed after the postal code update.", "warning", 0)}
          #{demo_button("Show audit note", "Audit log updated", "Maya Chen added a note to the customer timeline.", "info", 0)}
        </div>
      HTML
    end
  end

  # @label Top Center
  # A toaster positioned at the top center
  def top_center
    render(Shadcn::SonnerComponent.new(id: "sonner-top-center-viewport", position: :top_center, duration: 5000)) do
      demo_button("Publish post", "Post published", "The changelog is live and subscribers were notified.", "info")
    end
  end

  # @label With Limit
  # Limits the stack to two visible notifications
  def with_limit
    render(Shadcn::SonnerComponent.new(id: "sonner-limit-viewport", limit: 2, duration: 8000)) do
      <<~HTML.html_safe
        <div class="flex flex-wrap gap-2">
          #{demo_button("Create draft", "Draft created", "Proposal #918 is ready for review.")}
          #{demo_button("Save edits", "Proposal saved", "Line items and delivery terms were updated.", "success")}
          #{demo_button("Show error", "Sync failed", "CRM sync timed out. Retry from the activity feed.", "destructive")}
        </div>
      HTML
    end
  end

  # @label No Auto Dismiss
  # Toasts can stay open until dismissed
  def no_auto_dismiss
    render(Shadcn::ToasterComponent.new(id: "sonner-persistent-viewport", duration: 0)) do
      demo_button("Save profile", "Profile saved", "Avatar, display name, and notification settings were saved.", "success", 0)
    end
  end

  private

  def demo_button(label, title, description, variant = "default", duration = nil)
    duration_attribute = duration.nil? ? "" : %( data-duration="#{duration}")

    <<~HTML.squish.html_safe
      <button
        type="button"
        class="inline-flex h-9 items-center justify-center rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground shadow-xs transition-colors hover:bg-primary/90 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
        data-action="click->shadcn--sonner#demo"
        data-title="#{ERB::Util.html_escape(title)}"
        data-description="#{ERB::Util.html_escape(description)}"
        data-variant="#{variant}"#{duration_attribute}>
        #{ERB::Util.html_escape(label)}
      </button>
    HTML
  end
end
