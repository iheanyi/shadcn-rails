# frozen_string_literal: true

# @label Textarea
# @display bg_color "#ffffff"
class TextareaComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic textarea with placeholder
  def default
    render(Shadcn::TextareaComponent.new(
      name: "bio",
      placeholder: "Tell us about yourself..."
    ))
  end

  # @label With Value
  # Textarea with initial value
  def with_value
    render(Shadcn::TextareaComponent.new(
      name: "description",
      value: "This is a pre-filled textarea with some initial content.",
      placeholder: "Enter description..."
    ))
  end

  # @label Custom Rows
  # Textarea with custom number of rows
  # @param rows select { choices: [3, 5, 8, 10] }
  def custom_rows(rows: 5)
    render(Shadcn::TextareaComponent.new(
      name: "message",
      rows: rows.to_i,
      placeholder: "Type your message here..."
    ))
  end

  # @label Disabled
  # Disabled textarea that cannot be edited
  def disabled
    render(Shadcn::TextareaComponent.new(
      name: "disabled_field",
      value: "This textarea is disabled and cannot be edited.",
      disabled: true
    ))
  end

  # @label Readonly
  # Readonly textarea that can be focused but not edited
  def readonly
    render(Shadcn::TextareaComponent.new(
      name: "readonly_field",
      value: "This textarea is readonly. You can select and copy the text, but you cannot edit it.",
      readonly: true
    ))
  end

  # @label With Character Limit
  # Textarea with maximum character length
  def with_character_limit
    render(Shadcn::TextareaComponent.new(
      name: "limited_text",
      placeholder: "Maximum 280 characters...",
      maxlength: 280
    ))
  end

  # @label Required Field
  # Textarea marked as required with minimum length
  def required_field
    tag.form do
      tag.div(class: "space-y-2") do
        safe_join([
          tag.label("Comment (required)", for: "comment", class: "text-sm font-medium"),
          render(Shadcn::TextareaComponent.new(
            id: "comment",
            name: "comment",
            placeholder: "Please enter at least 10 characters...",
            required: true,
            minlength: 10
          ))
        ])
      end
    end
  end

  # @label With Label and Description
  # Textarea with proper form labeling
  def with_label_and_description
    render(Shadcn::TextareaComponent.new(
      id: "bio",
      name: "bio",
      placeholder: "Tell us a little bit about yourself",
      rows: 4
    ))
  end

  # @label Autofocus
  # Textarea that automatically receives focus on page load
  def autofocus
    render(Shadcn::TextareaComponent.new(
      name: "autofocus_field",
      placeholder: "This textarea will be focused on load",
      autofocus: true
    ))
  end

  # @label With Custom Styling
  # Textarea with additional custom classes
  def with_custom_styling
    render(Shadcn::TextareaComponent.new(
      name: "custom_styled",
      placeholder: "Custom styled textarea",
      class_name: "font-mono text-xs resize-none"
    ))
  end
end
