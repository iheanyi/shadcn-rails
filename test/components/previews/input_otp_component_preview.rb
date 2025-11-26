# frozen_string_literal: true

# @label Input OTP
# @display bg_color "#ffffff"
class InputOtpComponentPreview < ViewComponent::Preview
  # @label Default
  # 6-digit OTP input
  def default
    render(Shadcn::InputOtpComponent.new(length: 6, name: "otp"))
  end

  # @label 4-Digit PIN
  # 4-digit PIN input
  def pin
    render(Shadcn::InputOtpComponent.new(length: 4, name: "pin"))
  end

  # @label Disabled
  # Disabled OTP input
  def disabled
    render(Shadcn::InputOtpComponent.new(length: 6, name: "otp", disabled: true))
  end

  # @label Numeric Only
  # Numeric pattern validation
  def numeric
    render(Shadcn::InputOtpComponent.new(length: 6, name: "otp", pattern: "^[0-9]*$"))
  end

  # @label In Form
  # OTP input within a form context
  def in_form
    render_with_template
  end
end
