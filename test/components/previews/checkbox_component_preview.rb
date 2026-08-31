# frozen_string_literal: true

# @label Checkbox
# @display bg_color "#ffffff"
class CheckboxComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic checkbox
  def default
    render(Shadcn::CheckboxComponent.new(name: "terms", id: "terms"))
  end

  # @label Checked
  # Checkbox in checked state
  def checked
    render(Shadcn::CheckboxComponent.new(name: "subscribe", id: "subscribe", checked: true))
  end

  # @label Disabled
  # Disabled checkbox
  def disabled
    render(Shadcn::CheckboxComponent.new(name: "locked", id: "locked", disabled: true))
  end

  # @label Disabled & Checked
  # Disabled checkbox in checked state
  def disabled_checked
    render(Shadcn::CheckboxComponent.new(name: "locked_checked", id: "locked_checked", checked: true, disabled: true))
  end

  # @label With Description
  # Checkbox with label and description
  def with_description
    render(Shadcn::CheckboxComponent.new(name: "mobile", id: "mobile"))
  end

  # @label Multiple Checkboxes
  # Group of related checkboxes
  def multiple
    render(Shadcn::CheckboxComponent.new(name: "interests[]", id: "design", value: "design", checked: true))
  end

  # @label Form Example
  # Checkbox in a form context
  def form_example
    render(Shadcn::CheckboxComponent.new(name: "terms_of_service", id: "terms_of_service", required: true))
  end
end
