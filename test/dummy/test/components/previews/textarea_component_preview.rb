# frozen_string_literal: true

# @label Textarea
class TextareaComponentPreview < ViewComponent::Preview
  # @label Default
  def default
    render Ui::TextareaComponent.new(placeholder: "Type your message here...")
  end

  # @label Disabled
  def disabled
    render Ui::TextareaComponent.new(placeholder: "Disabled", disabled: true)
  end

  # @label With Value
  def with_value
    render Ui::TextareaComponent.new(value: "This is some pre-filled content in the textarea.")
  end

  # @!group Playground
  # @param placeholder text
  # @param rows range { min: 2, max: 10, step: 1 }
  # @param disabled toggle
  def playground(placeholder: "Enter text...", rows: 3, disabled: false)
    render Ui::TextareaComponent.new(placeholder: placeholder, rows: rows.to_i, disabled: disabled)
  end
  # @!endgroup
end
