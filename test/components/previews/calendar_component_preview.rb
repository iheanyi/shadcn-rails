# frozen_string_literal: true

# @label Calendar
# @display bg_color "#ffffff"
class CalendarComponentPreview < ViewComponent::Preview
  # @label Default
  # Interactive calendar with a selected date
  def default
    render(Shadcn::CalendarComponent.new(selected: Date.new(2026, 8, 29), month: Date.new(2026, 8, 1)))
  end
end
