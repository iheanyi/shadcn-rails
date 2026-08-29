# frozen_string_literal: true

# @label Date Picker
# @display bg_color "#ffffff"
class DatePickerComponentPreview < ViewComponent::Preview
  # @label Default
  # Date picker with a selected date
  def default
    render(Shadcn::DatePickerComponent.new(selected: Date.new(2026, 8, 29), month: Date.new(2026, 8, 1)))
  end
end
