# frozen_string_literal: true

require "test_helper"

class FieldComponentTest < ViewComponent::TestCase
  def test_renders_field_container
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Email" }
      field.with_input(type: :email)
    end

    assert_selector "div.space-y-2"
  end

  def test_renders_label_and_input
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Username" }
      field.with_input(placeholder: "Enter username")
    end

    assert_selector "label", text: "Username"
    assert_selector "input[placeholder='Enter username']"
  end

  def test_connects_label_to_input
    render_inline(Shadcn::FieldComponent.new(id: "test-field")) do |field|
      field.with_label { "Name" }
      field.with_input
    end

    assert_selector "label[for='test-field']"
    assert_selector "input[id='test-field']"
  end

  def test_renders_description
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Bio" }
      field.with_input
      field.with_description { "Tell us about yourself." }
    end

    assert_selector "p.text-muted-foreground", text: "Tell us about yourself."
  end

  def test_renders_error_message
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Password" }
      field.with_input(type: :password)
      field.with_error { "Password is required." }
    end

    assert_selector "p[role='alert']", text: "Password is required."
    assert_selector "p.text-destructive"
  end

  def test_renders_with_custom_control
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Description" }
      field.with_control do
        "<textarea>Custom content</textarea>".html_safe
      end
    end

    assert_selector "label", text: "Description"
    assert_selector "textarea"
  end

  def test_renders_with_name_attribute
    render_inline(Shadcn::FieldComponent.new(name: "user[email]")) do |field|
      field.with_label { "Email" }
      field.with_input
    end

    assert_selector "input[name='user[email]']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::FieldComponent.new(class_name: "my-field")) do |field|
      field.with_label { "Test" }
      field.with_input
    end

    assert_selector "div.my-field"
  end

  def test_input_has_error_styles_when_error_present
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Email" }
      field.with_input(error: true)
      field.with_error { "Invalid email" }
    end

    assert_selector "input.border-destructive"
  end

  def test_input_has_error_styles_when_error_slot_defined_first
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Email" }
      field.with_error { "Invalid email" }
      field.with_input  # error? will be true since with_error was called first
    end

    assert_selector "input.border-destructive"
  end
end
