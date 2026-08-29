# frozen_string_literal: true

# @label Label
# @display bg_color "#ffffff"
class LabelComponentPreview < ViewComponent::Preview
  # @label Default
  # Default label
  def default
    render(Shadcn::LabelComponent.new(for: "email")) { "Email Address" }
  end

  # @label Required Field
  # Label with required indicator
  def required_field
    render(Shadcn::LabelComponent.new(for: "name", required: true)) { "Name" }
  end

  # @label Optional Field
  # Label for optional field
  def optional_field
    render(Shadcn::LabelComponent.new(for: "phone")) { "Phone Number" }
  end

  # @label Custom Styling
  # Label with custom CSS classes
  def custom_styling
    render(Shadcn::LabelComponent.new(for: "bio", class_name: "text-lg font-bold")) { "Biography" }
  end

  # @label With Input
  # Label associated with an input field
  def with_input
    render(Shadcn::LabelComponent.new(for: "email")) { "Email Address" }
  end

  # @label Form Example
  # Multiple labels in a form
  def form_example
    render(Shadcn::LabelComponent.new(for: "name", required: true)) { "Name" }
  end

  # @label Without For
  # Label without a for attribute (standalone)
  def without_for
    render(Shadcn::LabelComponent.new) { "Standalone Label" }
  end

  # @label Disabled Context
  # Label in disabled input context (uses peer classes)
  def disabled_context
    render(Shadcn::LabelComponent.new(for: "disabled", class_name: "opacity-50")) { "Disabled Field" }
  end
end
