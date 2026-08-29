# frozen_string_literal: true

# @label Field
# @display bg_color "#ffffff"
class FieldComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic field with label and input
  def default
    render(Shadcn::FieldComponent.new(name: "email")) do |field|
      field.with_label { "Email" }
      field.with_input(type: :email, placeholder: "you@example.com")
    end
  end

  # @label With Description
  # Field with helpful description text
  def with_description
    render(Shadcn::FieldComponent.new(name: "username")) do |field|
      field.with_label { "Username" }
      field.with_input(placeholder: "shadcn")
      field.with_description { "This is your public display name." }
    end
  end

  # @label With Error
  # Field showing validation error
  def with_error
    render(Shadcn::FieldComponent.new(name: "password")) do |field|
      field.with_label { "Password" }
      field.with_error { "Password is required." }
      field.with_input(type: :password)
    end
  end

  # @label Email Field
  # Email field with placeholder
  def email
    render(Shadcn::FieldComponent.new(name: "email")) do |field|
      field.with_label { "Email" }
      field.with_input(type: :email, placeholder: "you@example.com")
    end
  end

  # @label Required Field
  # Field marked as required
  def required
    render(Shadcn::FieldComponent.new(name: "name")) do |field|
      field.with_label(required: true) { "Name" }
      field.with_input(placeholder: "Jane Doe")
    end
  end
end
