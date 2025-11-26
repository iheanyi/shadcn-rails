# frozen_string_literal: true

# @label Input
# @display bg_color "#ffffff"
class InputComponentPreview < ViewComponent::Preview
  # @label Default
  # Default text input
  def default
    render(Shadcn::InputComponent.new(type: "text", placeholder: "Enter text..."))
  end

  # @label Email
  # Email input type
  def email
    render(Shadcn::InputComponent.new(type: "email", placeholder: "email@example.com"))
  end

  # @label Password
  # Password input type
  def password
    render(Shadcn::InputComponent.new(type: "password", placeholder: "Enter password"))
  end

  # @label With Label
  # Input with associated label
  def with_label
    render_with_template
  end

  # @label Disabled
  # Disabled input
  def disabled
    render(Shadcn::InputComponent.new(
      type: "text",
      placeholder: "Disabled",
      disabled: true,
      value: "Can't edit this"
    ))
  end

  # @label File
  # File input type
  def file
    render(Shadcn::InputComponent.new(type: "file"))
  end

  # @label Search
  # Search input type
  def search
    render(Shadcn::InputComponent.new(type: "search", placeholder: "Search..."))
  end

  # @label Number
  # Number input type
  # @param min number
  # @param max number
  # @param step number
  def number(min: 0, max: 100, step: 1)
    render(Shadcn::InputComponent.new(
      type: "number",
      min: min,
      max: max,
      step: step,
      placeholder: "0"
    ))
  end

  # @label With Validation
  # Input with validation attributes
  def with_validation
    render(Shadcn::InputComponent.new(
      type: "email",
      placeholder: "email@example.com",
      required: true,
      pattern: "[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$"
    ))
  end
end
