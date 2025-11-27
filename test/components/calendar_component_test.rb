# frozen_string_literal: true

require "test_helper"

class CalendarComponentTest < ViewComponent::TestCase
  def test_renders_basic_calendar
    render_inline(Shadcn::CalendarComponent.new)

    assert_selector "[data-controller='shadcn--calendar']"
    assert_selector "[role='grid']"
    assert_selector "[aria-label='Calendar']"
  end

  def test_renders_month_year_header
    render_inline(Shadcn::CalendarComponent.new(month: Date.new(2024, 6, 15)))

    assert_selector "[data-shadcn--calendar-target='monthYear']", text: "June 2024"
  end

  def test_renders_navigation_buttons
    render_inline(Shadcn::CalendarComponent.new)

    assert_selector "button[aria-label='Previous month']"
    assert_selector "button[aria-label='Next month']"
    assert_selector "button[data-action='click->shadcn--calendar#previousMonth']"
    assert_selector "button[data-action='click->shadcn--calendar#nextMonth']"
  end

  def test_renders_weekday_headers
    render_inline(Shadcn::CalendarComponent.new)

    %w[Su Mo Tu We Th Fr Sa].each do |day|
      assert_text day
    end
  end

  def test_renders_days_grid
    render_inline(Shadcn::CalendarComponent.new(month: Date.new(2024, 6, 1)))

    assert_selector "[data-shadcn--calendar-target='grid']"
    assert_selector "button[data-shadcn--calendar-target='day']", minimum: 28
  end

  def test_renders_selected_date
    selected = Date.new(2024, 6, 15)
    render_inline(Shadcn::CalendarComponent.new(selected: selected, month: selected))

    assert_selector "button[aria-selected='true']", text: "15"
    assert_includes rendered_content, "bg-primary text-primary-foreground"
  end

  def test_renders_today_styling
    today = Date.today
    render_inline(Shadcn::CalendarComponent.new(month: today))

    assert_selector "button[data-date='#{today.iso8601}']"
    # Today gets accent styling if not selected
    assert_includes rendered_content, "bg-accent text-accent-foreground"
  end

  def test_renders_hidden_input_with_name
    render_inline(Shadcn::CalendarComponent.new(
      name: "event[date]",
      selected: Date.new(2024, 6, 15)
    ))

    assert_includes rendered_content, "input"
    assert_includes rendered_content, "type=\"hidden\""
    assert_includes rendered_content, "name=\"event[date]\""
    assert_includes rendered_content, "value=\"2024-06-15\""
    assert_includes rendered_content, "data-shadcn--calendar-target=\"hiddenInput\""
  end

  def test_does_not_render_hidden_input_without_name
    render_inline(Shadcn::CalendarComponent.new(selected: Date.new(2024, 6, 15)))

    assert_no_selector "input[type='hidden']"
  end

  def test_renders_disabled_dates
    disabled = [Date.new(2024, 6, 10), Date.new(2024, 6, 20)]
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 6, 1),
      disabled_dates: disabled
    ))

    assert_selector "button[data-date='2024-06-10'][disabled]"
    assert_selector "button[data-date='2024-06-20'][disabled]"
    assert_selector "button[data-date='2024-06-10'][aria-disabled='true']"
  end

  def test_renders_min_date_constraint
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 6, 1),
      min_date: Date.new(2024, 6, 15)
    ))

    # Days before min_date should be disabled
    assert_selector "button[data-date='2024-06-14'][disabled]"
    assert_selector "button[data-date='2024-06-10'][disabled]"
    # Days on or after min_date should not be disabled
    assert_no_selector "button[data-date='2024-06-15'][disabled]"
    assert_no_selector "button[data-date='2024-06-16'][disabled]"
  end

  def test_renders_max_date_constraint
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 6, 1),
      max_date: Date.new(2024, 6, 15)
    ))

    # Days after max_date should be disabled
    assert_selector "button[data-date='2024-06-16'][disabled]"
    assert_selector "button[data-date='2024-06-20'][disabled]"
    # Days on or before max_date should not be disabled
    assert_no_selector "button[data-date='2024-06-15'][disabled]"
    assert_no_selector "button[data-date='2024-06-14'][disabled]"
  end

  def test_renders_outside_days_by_default
    # June 2024 starts on Saturday, so May 26-31 should appear
    render_inline(Shadcn::CalendarComponent.new(month: Date.new(2024, 6, 1)))

    # Should show days from previous month
    assert_selector "button[data-date='2024-05-26']"
    # Should have opacity styling for outside days
    assert_includes rendered_content, "opacity-50"
  end

  def test_hides_outside_days_when_disabled
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 6, 1),
      show_outside_days: false
    ))

    # Should not render day buttons for May dates
    assert_no_selector "button[data-date='2024-05-26']"
    # Should have empty placeholders instead
    assert_selector "div.h-8.w-8"
  end

  def test_passes_stimulus_data_attributes
    selected = Date.new(2024, 6, 15)
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 6, 1),
      selected: selected
    ))

    assert_selector "[data-shadcn--calendar-month-value='2024-06-01']"
    assert_selector "[data-shadcn--calendar-selected-value='2024-06-15']"
  end

  def test_day_buttons_have_click_action
    render_inline(Shadcn::CalendarComponent.new(month: Date.new(2024, 6, 1)))

    # Non-disabled days should have click action
    assert_selector "button[data-action='click->shadcn--calendar#selectDay']", minimum: 28
  end

  def test_disabled_days_have_no_click_action
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 6, 1),
      disabled_dates: [Date.new(2024, 6, 15)]
    ))

    # Disabled day should not have click action
    assert_no_selector "button[data-date='2024-06-15'][data-action]"
  end

  def test_renders_custom_class
    render_inline(Shadcn::CalendarComponent.new(class_name: "custom-calendar"))

    assert_selector ".custom-calendar"
  end

  def test_renders_chevron_icons
    render_inline(Shadcn::CalendarComponent.new)

    assert_selector "svg", count: 2
    assert_selector "path[d='m15 18-6-6 6-6']" # Left chevron
    assert_selector "path[d='m9 18 6-6-6-6']" # Right chevron
  end

  def test_defaults_to_current_month
    render_inline(Shadcn::CalendarComponent.new)

    today = Date.today
    month_name = %w[January February March April May June July August September October November December][today.month - 1]

    assert_selector "[data-shadcn--calendar-target='monthYear']", text: "#{month_name} #{today.year}"
  end

  def test_defaults_month_to_selected_date_month
    selected = Date.new(2024, 12, 25)
    render_inline(Shadcn::CalendarComponent.new(selected: selected))

    assert_selector "[data-shadcn--calendar-target='monthYear']", text: "December 2024"
  end
end
