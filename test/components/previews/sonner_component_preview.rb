# frozen_string_literal: true

# @label Sonner
# @display bg_color "#ffffff"
class SonnerComponentPreview < ViewComponent::Preview
  # @label Default
  # Recommended toast API with a persistent toaster viewport
  def default
    render(Shadcn::SonnerComponent.new(duration: 5000)) do
      <<~HTML.html_safe
        <div class="flex flex-wrap gap-2">
          #{demo_button("Show toast", "Event has been created", "Friday, February 10, 2023 at 5:57 PM")}
          #{demo_button("Show success", "Saved", "Your changes were saved.", "success")}
          #{demo_button("Show error", "Uh oh! Something went wrong.", "There was a problem with your request.", "destructive")}
        </div>
      HTML
    end
  end

  # @label Top Center
  # A toaster positioned at the top center
  def top_center
    render(Shadcn::SonnerComponent.new(position: :top_center, duration: 5000)) do
      demo_button("Show top toast", "Heads up", "This toast appears from the top.", "info")
    end
  end

  # @label With Limit
  # Limits the stack to two visible notifications
  def with_limit
    render(Shadcn::SonnerComponent.new(limit: 2, duration: 8000)) do
      <<~HTML.html_safe
        <div class="flex flex-wrap gap-2">
          #{demo_button("First", "First toast", "Older toasts leave when the stack is full.")}
          #{demo_button("Second", "Second toast", "The limit for this preview is two.")}
          #{demo_button("Third", "Third toast", "Click all three to see the oldest dismiss.")}
        </div>
      HTML
    end
  end

  # @label No Auto Dismiss
  # Toasts can stay open until dismissed
  def no_auto_dismiss
    render(Shadcn::ToasterComponent.new(duration: 0)) do
      demo_button("Show persistent toast", "Manual dismiss required", "This toast remains until you close it.", "warning", 0)
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
