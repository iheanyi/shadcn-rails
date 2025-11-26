# frozen_string_literal: true

# @label Checkbox
# @display bg_color "#ffffff"
class CheckboxComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic checkbox
  def default
    content_tag(:div, class: "flex items-center space-x-2") do
      render(Shadcn::CheckboxComponent.new(name: "terms", id: "terms")) +
      content_tag(:label, "Accept terms and conditions",
        for: "terms",
        class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      )
    end
  end

  # @label Checked
  # Checkbox in checked state
  def checked
    content_tag(:div, class: "flex items-center space-x-2") do
      render(Shadcn::CheckboxComponent.new(name: "subscribe", id: "subscribe", checked: true)) +
      content_tag(:label, "Subscribe to newsletter",
        for: "subscribe",
        class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      )
    end
  end

  # @label Disabled
  # Disabled checkbox
  def disabled
    content_tag(:div, class: "flex items-center space-x-2") do
      render(Shadcn::CheckboxComponent.new(name: "locked", id: "locked", disabled: true)) +
      content_tag(:label, "This option is disabled",
        for: "locked",
        class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      )
    end
  end

  # @label Disabled & Checked
  # Disabled checkbox in checked state
  def disabled_checked
    content_tag(:div, class: "flex items-center space-x-2") do
      render(Shadcn::CheckboxComponent.new(name: "locked_checked", id: "locked_checked", checked: true, disabled: true)) +
      content_tag(:label, "This option is locked on",
        for: "locked_checked",
        class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      )
    end
  end

  # @label Indeterminate
  # Checkbox in indeterminate state (mixed)
  def indeterminate
    content_tag(:div, class: "flex items-center space-x-2") do
      render(Shadcn::CheckboxComponent.new(name: "mixed", id: "mixed", indeterminate: true)) +
      content_tag(:label, "Indeterminate state",
        for: "mixed",
        class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      )
    end
  end

  # @label With Description
  # Checkbox with label and description
  def with_description
    content_tag(:div, class: "flex items-start space-x-2") do
      content_tag(:div, class: "pt-0.5") do
        render(Shadcn::CheckboxComponent.new(name: "mobile", id: "mobile"))
      end +
      content_tag(:div, class: "grid gap-1.5 leading-none") do
        content_tag(:label, "Use different settings for mobile",
          for: "mobile",
          class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
        ) +
        content_tag(:p, "Your mobile settings will override desktop settings when on mobile devices.",
          class: "text-sm text-muted-foreground"
        )
      end
    end
  end

  # @label Multiple Checkboxes
  # Group of related checkboxes
  def multiple
    content_tag(:div, class: "space-y-4") do
      content_tag(:div) do
        content_tag(:h4, "Select your interests", class: "text-sm font-medium mb-3")
      end +
      content_tag(:div, class: "space-y-3") do
        content_tag(:div, class: "flex items-center space-x-2") do
          render(Shadcn::CheckboxComponent.new(name: "interests[]", id: "tech", value: "technology")) +
          content_tag(:label, "Technology",
            for: "tech",
            class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
          )
        end +
        content_tag(:div, class: "flex items-center space-x-2") do
          render(Shadcn::CheckboxComponent.new(name: "interests[]", id: "design", value: "design", checked: true)) +
          content_tag(:label, "Design",
            for: "design",
            class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
          )
        end +
        content_tag(:div, class: "flex items-center space-x-2") do
          render(Shadcn::CheckboxComponent.new(name: "interests[]", id: "business", value: "business")) +
          content_tag(:label, "Business",
            for: "business",
            class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
          )
        end +
        content_tag(:div, class: "flex items-center space-x-2") do
          render(Shadcn::CheckboxComponent.new(name: "interests[]", id: "science", value: "science", checked: true)) +
          content_tag(:label, "Science",
            for: "science",
            class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
          )
        end
      end
    end
  end

  # @label Form Example
  # Checkbox in a form context
  def form_example
    content_tag(:div, class: "space-y-4 max-w-md") do
      content_tag(:div, class: "space-y-2") do
        content_tag(:h3, "Create Account", class: "text-lg font-semibold") +
        content_tag(:p, "Please review and accept our terms", class: "text-sm text-muted-foreground")
      end +
      content_tag(:div, class: "space-y-3") do
        content_tag(:div, class: "flex items-center space-x-2") do
          render(Shadcn::CheckboxComponent.new(name: "terms_of_service", id: "terms_of_service", required: true)) +
          content_tag(:label, for: "terms_of_service", class: "text-sm font-medium leading-none") do
            "I agree to the ".html_safe +
            content_tag(:a, "Terms of Service", href: "#", class: "underline") +
            " ".html_safe +
            content_tag(:span, "*", class: "text-destructive")
          end
        end +
        content_tag(:div, class: "flex items-center space-x-2") do
          render(Shadcn::CheckboxComponent.new(name: "privacy_policy", id: "privacy_policy", required: true)) +
          content_tag(:label, for: "privacy_policy", class: "text-sm font-medium leading-none") do
            "I agree to the ".html_safe +
            content_tag(:a, "Privacy Policy", href: "#", class: "underline") +
            " ".html_safe +
            content_tag(:span, "*", class: "text-destructive")
          end
        end +
        content_tag(:div, class: "flex items-center space-x-2") do
          render(Shadcn::CheckboxComponent.new(name: "marketing", id: "marketing")) +
          content_tag(:label, for: "marketing", class: "text-sm leading-none") do
            "Send me marketing emails (optional)"
          end
        end
      end
    end
  end
end
