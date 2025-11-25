# frozen_string_literal: true

# @label Input
class InputComponentPreview < ViewComponent::Preview
  # @label Default
  def default
    render Ui::InputComponent.new(placeholder: "Email")
  end

  # @label With Label
  def with_label
    render_with_template
  end

  # @label File Input
  def file
    render Ui::InputComponent.new(type: "file")
  end

  # @label Disabled
  def disabled
    render Ui::InputComponent.new(placeholder: "Disabled", disabled: true)
  end

  # @label Types
  def types
    render_with_template
  end

  # @!group Playground
  # @param type select { choices: [text, email, password, number, tel, url, search, date, time] }
  # @param placeholder text
  # @param disabled toggle
  def playground(type: "text", placeholder: "Enter text...", disabled: false)
    render Ui::InputComponent.new(type: type, placeholder: placeholder, disabled: disabled)
  end
  # @!endgroup
end
