# frozen_string_literal: true

require "test_helper"

class FieldComponentTest < ViewComponent::TestCase
  def test_renders_field_container
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Email" }
      field.with_input(type: :email)
    end

    assert_selector "div[role='group'][data-slot='field'][data-orientation='vertical']"
  end

  def test_renders_v4_field_container_classes_without_legacy_spacing_or_size_variants
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Email" }
      field.with_input(type: :email)
    end

    classes = page.find("div[data-slot='field']")["class"].split

    assert_includes classes, "group/field"
    assert_includes classes, "flex"
    assert_includes classes, "w-full"
    assert_includes classes, "gap-3"
    assert_includes classes, "data-[invalid=true]:text-destructive"
    assert_includes classes, "flex-col"
    assert_includes classes, "[&>*]:w-full"
    assert_includes classes, "[&>.sr-only]:w-auto"

    refute_includes classes, "space-y-2"
    refute_includes classes, "data-[size=default]:grid"
    refute_includes classes, "data-[size=default]:gap-2"
  end

  def test_renders_v4_horizontal_field_container_classes
    render_inline(Shadcn::FieldComponent.new(orientation: :horizontal)) do |field|
      field.with_label { "Email" }
      field.with_input(type: :email)
    end

    classes = page.find("div[data-slot='field']")["class"].split

    assert_includes classes, "flex-row"
    assert_includes classes, "items-center"
    assert_includes classes, "[&>[data-slot=field-label]]:flex-auto"
    assert_includes classes, "has-[>[data-slot=field-content]]:items-start"
    assert_includes classes, "has-[>[data-slot=field-content]]:[&>[role=checkbox],[role=radio]]:mt-px"

    refute_includes classes, "space-y-2"
    refute_includes classes, "data-[size=default]:grid"
  end

  def test_renders_v4_responsive_field_container_classes
    render_inline(Shadcn::FieldComponent.new(orientation: :responsive)) do |field|
      field.with_label { "Email" }
      field.with_input(type: :email)
    end

    classes = page.find("div[data-slot='field']")["class"].split

    assert_includes classes, "flex-col"
    assert_includes classes, "@md/field-group:flex-row"
    assert_includes classes, "@md/field-group:items-center"
    assert_includes classes, "[&>*]:w-full"
    assert_includes classes, "@md/field-group:[&>*]:w-auto"
    assert_includes classes, "[&>.sr-only]:w-auto"
    assert_includes classes, "@md/field-group:[&>[data-slot=field-label]]:flex-auto"
    assert_includes classes, "@md/field-group:has-[>[data-slot=field-content]]:items-start"
    assert_includes classes, "@md/field-group:has-[>[data-slot=field-content]]:[&>[role=checkbox],[role=radio]]:mt-px"

    refute_includes classes, "space-y-2"
    refute_includes classes, "data-[size=default]:grid"
  end

  def test_renders_label_and_input
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Username" }
      field.with_input(placeholder: "Enter username")
    end

    assert_selector "label", text: "Username"
    assert_selector "label[data-slot='field-label']"
    assert_selector "input[placeholder='Enter username']"
  end

  def test_renders_v4_field_label_classes
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Username" }
      field.with_input
    end

    classes = page.find("label[data-slot='field-label']")["class"].split

    assert_includes classes, "group/field-label"
    assert_includes classes, "peer/field-label"
    assert_includes classes, "flex"
    assert_includes classes, "w-fit"
    assert_includes classes, "gap-2"
    assert_includes classes, "leading-snug"
    assert_includes classes, "group-data-[disabled=true]/field:opacity-50"
    assert_includes classes, "has-[>[data-slot=field]]:w-full"
    assert_includes classes, "has-[>[data-slot=field]]:flex-col"
    assert_includes classes, "has-[>[data-slot=field]]:rounded-md"
    assert_includes classes, "has-[>[data-slot=field]]:border"
    assert_includes classes, "[&>*]:data-[slot=field]:p-4"
    assert_includes classes, "has-data-[state=checked]:border-primary"
    assert_includes classes, "has-data-[state=checked]:bg-primary/5"
    assert_includes classes, "dark:has-data-[state=checked]:bg-primary/10"

    refute_includes classes, "leading-none"
    refute_includes classes, "peer-disabled:opacity-70"
    refute_includes classes, "data-[size=default]:text-sm"
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
    assert_selector "p[data-slot='field-description']"
  end

  def test_renders_v4_field_description_classes
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Bio" }
      field.with_input
      field.with_description { "Tell us about yourself." }
    end

    classes = page.find("p[data-slot='field-description']")["class"].split

    assert_includes classes, "text-sm"
    assert_includes classes, "leading-normal"
    assert_includes classes, "font-normal"
    assert_includes classes, "text-muted-foreground"
    assert_includes classes, "group-has-[[data-orientation=horizontal]]/field:text-balance"
    assert_includes classes, "last:mt-0"
    assert_includes classes, "nth-last-2:-mt-1"
    assert_includes classes, "[[data-variant=legend]+&]:-mt-1.5"
    assert_includes classes, "[&>a]:underline"
    assert_includes classes, "[&>a]:underline-offset-4"
    assert_includes classes, "[&>a:hover]:text-primary"

    refute_includes classes, "text-[0.8rem]"
    refute_includes classes, "data-[size=default]:text-sm"
  end

  def test_renders_error_message
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Password" }
      field.with_input(type: :password)
      field.with_error { "Password is required." }
    end

    assert_selector "div[role='alert'][data-slot='field-error']", text: "Password is required."
    assert_selector "div.text-destructive"
  end

  def test_renders_v4_field_error_classes
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Password" }
      field.with_input(type: :password)
      field.with_error { "Password is required." }
    end

    classes = page.find("div[data-slot='field-error']")["class"].split

    assert_includes classes, "text-sm"
    assert_includes classes, "font-normal"
    assert_includes classes, "text-destructive"

    refute_includes classes, "text-[0.8rem]"
    refute_includes classes, "font-medium"
    refute_includes classes, "data-[size=default]:text-sm"
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

  def test_marks_field_invalid_when_error_slot_is_present
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_label { "Email" }
      field.with_input
      field.with_error { "Invalid email" }
    end

    assert_selector "div[data-slot='field'][data-invalid='true']"
  end

  def test_renders_v4_field_group_classes
    render_inline(Shadcn::FieldComponent::GroupComponent.new) { "Group content" }

    classes = page.find("div[data-slot='field-group']")["class"].split

    assert_includes classes, "group/field-group"
    assert_includes classes, "@container/field-group"
    assert_includes classes, "flex"
    assert_includes classes, "w-full"
    assert_includes classes, "flex-col"
    assert_includes classes, "gap-7"
    assert_includes classes, "data-[slot=checkbox-group]:gap-3"
    assert_includes classes, "[&>[data-slot=field-group]]:gap-4"

    refute_includes classes, "space-y-2"
    refute_includes classes, "data-[size=default]:gap-2"
  end

  def test_renders_v4_field_content_classes
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_field_content { "Content" }
    end

    classes = page.find("div[data-slot='field-content']")["class"].split

    assert_includes classes, "group/field-content"
    assert_includes classes, "flex"
    assert_includes classes, "flex-1"
    assert_includes classes, "flex-col"
    assert_includes classes, "gap-1.5"
    assert_includes classes, "leading-snug"

    refute_includes classes, "space-y-2"
    refute_includes classes, "data-[size=default]:gap-2"
  end

  def test_renders_v4_field_separator_classes
    render_inline(Shadcn::FieldComponent.new) do |field|
      field.with_separator { "or" }
    end

    separator = page.find("div[data-slot='field-separator']")
    classes = separator["class"].split
    content_classes = page.find("span[data-slot='field-separator-content']")["class"].split

    assert_equal "true", separator["data-content"]
    assert_includes classes, "relative"
    assert_includes classes, "-my-2"
    assert_includes classes, "h-5"
    assert_includes classes, "text-sm"
    assert_includes classes, "group-data-[variant=outline]/field-group:-mb-2"
    assert_includes content_classes, "relative"
    assert_includes content_classes, "mx-auto"
    assert_includes content_classes, "block"
    assert_includes content_classes, "w-fit"
    assert_includes content_classes, "bg-background"
    assert_includes content_classes, "px-2"
    assert_includes content_classes, "text-muted-foreground"

    refute_includes classes, "space-y-2"
    refute_includes classes, "data-[size=default]:h-5"
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
