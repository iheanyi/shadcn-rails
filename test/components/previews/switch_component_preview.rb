# frozen_string_literal: true

# @label Switch
# @display bg_color "#ffffff"
class SwitchComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic switch
  def default
    content_tag(:div, class: "flex items-center space-x-2") do
      render(Shadcn::SwitchComponent.new(name: "notifications", id: "notifications")) +
      content_tag(:label, "Enable notifications",
        for: "notifications",
        class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      )
    end
  end

  # @label Checked
  # Switch in checked (on) state
  def checked
    content_tag(:div, class: "flex items-center space-x-2") do
      render(Shadcn::SwitchComponent.new(name: "dark_mode", id: "dark_mode", checked: true)) +
      content_tag(:label, "Dark mode enabled",
        for: "dark_mode",
        class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      )
    end
  end

  # @label Disabled
  # Disabled switch
  def disabled
    content_tag(:div, class: "flex items-center space-x-2") do
      render(Shadcn::SwitchComponent.new(name: "locked", id: "locked", disabled: true)) +
      content_tag(:label, "This option is disabled",
        for: "locked",
        class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      )
    end
  end

  # @label Disabled & Checked
  # Disabled switch in checked state
  def disabled_checked
    content_tag(:div, class: "flex items-center space-x-2") do
      render(Shadcn::SwitchComponent.new(name: "locked_on", id: "locked_on", checked: true, disabled: true)) +
      content_tag(:label, "This option is locked on",
        for: "locked_on",
        class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      )
    end
  end

  # @label With Description
  # Switch with label and description
  def with_description
    content_tag(:div, class: "flex items-start space-x-2") do
      content_tag(:div, class: "pt-0.5") do
        render(Shadcn::SwitchComponent.new(name: "airplane_mode", id: "airplane_mode"))
      end +
      content_tag(:div, class: "grid gap-1.5 leading-none") do
        content_tag(:label, "Airplane mode",
          for: "airplane_mode",
          class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
        ) +
        content_tag(:p, "Disable all wireless connections on your device.",
          class: "text-sm text-muted-foreground"
        )
      end
    end
  end

  # @label Settings Panel
  # Multiple switches in a settings panel
  def settings_panel
    content_tag(:div, class: "space-y-4 max-w-md") do
      content_tag(:div, class: "space-y-2") do
        content_tag(:h3, "Notification Settings", class: "text-lg font-semibold") +
        content_tag(:p, "Manage how you receive notifications", class: "text-sm text-muted-foreground")
      end +
      content_tag(:div, class: "space-y-4") do
        content_tag(:div, class: "flex items-center justify-between space-x-2") do
          content_tag(:label, for: "email_notifications", class: "flex flex-col space-y-1") do
            content_tag(:span, "Email notifications", class: "text-sm font-medium leading-none") +
            content_tag(:span, "Receive notifications via email", class: "text-sm text-muted-foreground")
          end +
          render(Shadcn::SwitchComponent.new(name: "email_notifications", id: "email_notifications", checked: true))
        end +
        content_tag(:div, class: "flex items-center justify-between space-x-2") do
          content_tag(:label, for: "push_notifications", class: "flex flex-col space-y-1") do
            content_tag(:span, "Push notifications", class: "text-sm font-medium leading-none") +
            content_tag(:span, "Receive push notifications on your device", class: "text-sm text-muted-foreground")
          end +
          render(Shadcn::SwitchComponent.new(name: "push_notifications", id: "push_notifications", checked: true))
        end +
        content_tag(:div, class: "flex items-center justify-between space-x-2") do
          content_tag(:label, for: "sms_notifications", class: "flex flex-col space-y-1") do
            content_tag(:span, "SMS notifications", class: "text-sm font-medium leading-none") +
            content_tag(:span, "Receive notifications via text message", class: "text-sm text-muted-foreground")
          end +
          render(Shadcn::SwitchComponent.new(name: "sms_notifications", id: "sms_notifications"))
        end
      end
    end
  end

  # @label Privacy Settings
  # Switches for privacy options
  def privacy_settings
    content_tag(:div, class: "space-y-4 max-w-md") do
      content_tag(:div, class: "space-y-2") do
        content_tag(:h3, "Privacy Settings", class: "text-lg font-semibold") +
        content_tag(:p, "Control your privacy and data sharing", class: "text-sm text-muted-foreground")
      end +
      content_tag(:div, class: "space-y-4") do
        content_tag(:div, class: "flex items-center justify-between space-x-2") do
          content_tag(:label, for: "public_profile", class: "flex flex-col space-y-1") do
            content_tag(:span, "Public profile", class: "text-sm font-medium leading-none") +
            content_tag(:span, "Make your profile visible to everyone", class: "text-sm text-muted-foreground")
          end +
          render(Shadcn::SwitchComponent.new(name: "public_profile", id: "public_profile"))
        end +
        content_tag(:div, class: "flex items-center justify-between space-x-2") do
          content_tag(:label, for: "activity_status", class: "flex flex-col space-y-1") do
            content_tag(:span, "Show activity status", class: "text-sm font-medium leading-none") +
            content_tag(:span, "Let others see when you're online", class: "text-sm text-muted-foreground")
          end +
          render(Shadcn::SwitchComponent.new(name: "activity_status", id: "activity_status", checked: true))
        end +
        content_tag(:div, class: "flex items-center justify-between space-x-2") do
          content_tag(:label, for: "read_receipts", class: "flex flex-col space-y-1") do
            content_tag(:span, "Read receipts", class: "text-sm font-medium leading-none") +
            content_tag(:span, "Send read receipts in messages", class: "text-sm text-muted-foreground")
          end +
          render(Shadcn::SwitchComponent.new(name: "read_receipts", id: "read_receipts", checked: true))
        end +
        content_tag(:div, class: "flex items-center justify-between space-x-2") do
          content_tag(:label, for: "data_collection", class: "flex flex-col space-y-1") do
            content_tag(:span, "Anonymous analytics", class: "text-sm font-medium leading-none") +
            content_tag(:span, "Help us improve by sharing anonymous usage data", class: "text-sm text-muted-foreground")
          end +
          render(Shadcn::SwitchComponent.new(name: "data_collection", id: "data_collection"))
        end
      end
    end
  end

  # @label Required Switch
  # Switch marked as required
  def required
    content_tag(:div, class: "flex items-center space-x-2") do
      render(Shadcn::SwitchComponent.new(name: "agreement", id: "agreement", required: true)) +
      content_tag(:label, for: "agreement", class: "text-sm font-medium leading-none") do
        "I agree to the terms and conditions ".html_safe +
        content_tag(:span, "*", class: "text-destructive")
      end
    end
  end

  # @label Interactive States
  # Shows all interactive states
  # @param checked toggle
  # @param disabled toggle
  def interactive_states(checked: false, disabled: false)
    content_tag(:div, class: "flex items-center space-x-2") do
      render(Shadcn::SwitchComponent.new(
        name: "interactive",
        id: "interactive",
        checked: checked,
        disabled: disabled
      )) +
      content_tag(:label, "Toggle switch",
        for: "interactive",
        class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      )
    end
  end
end
