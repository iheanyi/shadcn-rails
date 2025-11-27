# frozen_string_literal: true

# @label Toast
# @display bg_color "#ffffff"
class ToastComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic toast notification with title and description
  def default
    render(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Scheduled: Catch up" }
      toast.with_description { "Friday, February 10, 2023 at 5:57 PM" }
    end
  end

  # @label All Variants
  # Shows different toast variants
  # @param variant select { choices: [default, destructive] }
  def variants(variant: :default)
    render(Shadcn::ToastComponent.new(variant: variant.to_sym)) do |toast|
      toast.with_title { variant == :destructive ? "Error" : "Success" }
      toast.with_description { variant == :destructive ? "Something went wrong." : "Your changes have been saved." }
    end
  end

  # @label Simple
  # Simple toast with just a title
  def simple
    render(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Email sent successfully" }
    end
  end

  # @label With Description
  # Toast with title and description
  def with_description
    render(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Scheduled: Catch up" }
      toast.with_description { "Friday, February 10, 2023 at 5:57 PM" }
    end
  end

  # @label With Action
  # Toast with an action button
  def with_action
    render(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Uh oh! Something went wrong." }
      toast.with_description { "There was a problem with your request." }
      toast.with_action(alt_text: "Try again") do
        button_html(:outline, "Try again", "h-8 px-3 text-xs")
      end
    end
  end

  # @label Destructive
  # Destructive variant for errors
  def destructive
    render(Shadcn::ToastComponent.new(variant: :destructive)) do |toast|
      toast.with_title { "Uh oh! Something went wrong." }
      toast.with_description { "There was a problem with your request." }
    end
  end

  # @label Destructive with Action
  # Destructive toast with action button
  def destructive_with_action
    render(Shadcn::ToastComponent.new(variant: :destructive)) do |toast|
      toast.with_title { "Uh oh! Something went wrong." }
      toast.with_description { "There was a problem with your request." }
      toast.with_action(alt_text: "Try again") do
        %(<button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-8 px-3 text-xs border-destructive/30 hover:border-destructive/40 hover:bg-destructive hover:text-destructive-foreground">Try again</button>).html_safe
      end
    end
  end

  # @label Success
  # Success notification
  def success
    render(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Success!" }
      toast.with_description { "Your changes have been saved successfully." }
    end
  end

  # @label Warning
  # Warning notification (using default variant)
  def warning
    render(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Warning" }
      toast.with_description { "Your session will expire in 5 minutes." }
      toast.with_action(alt_text: "Extend session") do
        button_html(:outline, "Extend", "h-8 px-3 text-xs")
      end
    end
  end

  # @label Long Duration
  # Toast that stays visible longer (10 seconds)
  def long_duration
    render(Shadcn::ToastComponent.new(duration: 10000)) do |toast|
      toast.with_title { "Important message" }
      toast.with_description { "This toast will stay visible for 10 seconds." }
    end
  end

  # @label No Auto Dismiss
  # Toast that doesn't auto-dismiss (duration: 0)
  def no_auto_dismiss
    render(Shadcn::ToastComponent.new(duration: 0)) do |toast|
      toast.with_title { "Manual dismiss required" }
      toast.with_description { "This toast will not auto-dismiss. Click the X to close." }
    end
  end

  # @label Multiple Toasts
  # Example showing multiple toasts - Note: In real apps, toasts appear in a ToastViewport
  # This preview shows a single toast. See documentation for stacked toast examples.
  def multiple
    render(Shadcn::ToastComponent.new) do |toast|
      toast.with_title { "Multiple Toasts Example" }
      toast.with_description { "In a real app, multiple toasts stack in the ToastViewport container. See docs for integration guide." }
    end
  end

  private

  def button_html(variant, text, extra_class = nil)
    base_classes = "inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2"

    variant_classes = case variant
    when :default
      "bg-primary text-primary-foreground hover:bg-primary/90"
    when :destructive
      "bg-destructive text-destructive-foreground hover:bg-destructive/90"
    when :outline
      "border border-input bg-background hover:bg-accent hover:text-accent-foreground"
    when :secondary
      "bg-secondary text-secondary-foreground hover:bg-secondary/80"
    when :ghost
      "hover:bg-accent hover:text-accent-foreground"
    when :link
      "text-primary underline-offset-4 hover:underline"
    else
      "bg-primary text-primary-foreground hover:bg-primary/90"
    end

    classes = [base_classes, variant_classes, extra_class].compact.join(" ")
    %(<button type="button" class="#{classes}">#{text}</button>).html_safe
  end
end
