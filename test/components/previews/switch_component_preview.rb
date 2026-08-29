# frozen_string_literal: true

# @label Switch
# @display bg_color "#ffffff"
class SwitchComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic switch
  def default
    render(Shadcn::SwitchComponent.new(name: "notifications", id: "notifications"))
  end

  # @label Checked
  # Switch in checked (on) state
  def checked
    render(Shadcn::SwitchComponent.new(name: "dark_mode", id: "dark_mode", checked: true))
  end

  # @label Disabled
  # Disabled switch
  def disabled
    render(Shadcn::SwitchComponent.new(name: "locked", id: "locked", disabled: true))
  end

  # @label Disabled & Checked
  # Disabled switch in checked state
  def disabled_checked
    render(Shadcn::SwitchComponent.new(name: "locked_on", id: "locked_on", checked: true, disabled: true))
  end

  # @label With Description
  # Switch with label and description
  def with_description
    render(Shadcn::SwitchComponent.new(name: "airplane_mode", id: "airplane_mode"))
  end

  # @label Settings Panel
  # Multiple switches in a settings panel
  def settings_panel
    render(Shadcn::SwitchComponent.new(name: "email_notifications", id: "email_notifications", checked: true))
  end

  # @label Privacy Settings
  # Switches for privacy options
  def privacy_settings
    render(Shadcn::SwitchComponent.new(name: "activity_status", id: "activity_status", checked: true))
  end

  # @label Required Switch
  # Switch marked as required
  def required
    render(Shadcn::SwitchComponent.new(name: "agreement", id: "agreement", required: true))
  end

  # @label Interactive States
  # Shows all interactive states
  # @param checked toggle
  # @param disabled toggle
  def interactive_states(checked: false, disabled: false)
    render(Shadcn::SwitchComponent.new(
      name: "interactive",
      id: "interactive",
      checked: checked,
      disabled: disabled
    ))
  end
end
