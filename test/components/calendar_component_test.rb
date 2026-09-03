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

    # Month and year are now shown via selects
    assert_selector "select[data-shadcn--calendar-target='monthSelect']"
    assert_selector "select[data-shadcn--calendar-target='yearSelect']"
    assert_selector "option[selected]", text: "June"
    assert_selector "option[selected]", text: "2024"
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

  def test_day_buttons_use_v4_focus_visible_ring_styles
    render_inline(Shadcn::CalendarComponent.new(month: Date.new(2024, 6, 1)))

    classes = page.first("button[data-shadcn--calendar-target='day']")["class"].split
    assert_includes classes, "min-w-(--cell-size)"
    assert_includes classes, "group-data-[focused=true]/day:border-ring"
    assert_includes classes, "group-data-[focused=true]/day:ring-[3px]"
    assert_includes classes, "group-data-[focused=true]/day:ring-ring/50"
    refute_includes classes, "focus:ring-1"
    refute_includes classes, "focus:outline-none"
  end

  def test_month_year_selects_use_focus_visible_ring_styles
    render_inline(Shadcn::CalendarComponent.new(month: Date.new(2024, 6, 1)))

    classes = page.find("select[data-shadcn--calendar-target='monthSelect']")["class"].split
    assert_includes classes, "focus-visible:border-ring"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "focus-visible:ring-ring/50"
    refute_includes classes, "focus:ring-1"
    refute_includes classes, "focus:outline-none"
  end

  def test_renders_selected_date
    selected = Date.new(2024, 6, 15)
    render_inline(Shadcn::CalendarComponent.new(selected: selected, month: selected))

    assert_selector "button[aria-selected='true']", text: "15"
    assert_includes rendered_content, "data-[selected-single=true]:bg-primary"
    assert_includes rendered_content, "data-[selected-single=true]:text-primary-foreground"
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
    assert_selector "div.invisible"
  end

  def test_calendar_root_uses_v4_group_and_cell_size_tokens
    render_inline(Shadcn::CalendarComponent.new(month: Date.new(2024, 6, 1)))

    root_classes = page.find("[data-controller='shadcn--calendar']")["class"].split
    assert_includes root_classes, "group/calendar"
    assert_includes root_classes, "[--cell-size:--spacing(8)]"
  end

  def test_range_mode_uses_v4_range_state_tokens
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 6, 1),
      mode: :range,
      selected: [Date.new(2024, 6, 10), Date.new(2024, 6, 12)]
    ))

    assert_selector "button[data-date='2024-06-10'][data-range-start='true']"
    assert_selector "button[data-date='2024-06-11'][data-range-middle='true']"
    assert_selector "button[data-date='2024-06-12'][data-range-end='true']"
    assert_includes rendered_content, "data-[range-middle=true]:bg-accent"
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

    # Month and year should be selected in dropdowns
    assert_selector "option[selected]", text: month_name
    assert_selector "option[selected]", text: today.year.to_s
  end

  def test_defaults_month_to_selected_date_month
    selected = Date.new(2024, 12, 25)
    render_inline(Shadcn::CalendarComponent.new(selected: selected))

    # December and 2024 should be selected
    assert_selector "option[selected]", text: "December"
    assert_selector "option[selected]", text: "2024"
  end

  # Tests for week_starts_on functionality
  def test_renders_weekday_headers_starting_sunday_by_default
    render_inline(Shadcn::CalendarComponent.new)

    weekday_divs = page.all(".flex-1.rounded-md.text-\\[0\\.8rem\\].font-normal.text-muted-foreground")
    weekday_texts = weekday_divs.map(&:text)

    assert_equal %w[Su Mo Tu We Th Fr Sa], weekday_texts
  end

  def test_renders_weekday_headers_starting_monday
    render_inline(Shadcn::CalendarComponent.new(week_starts_on: 1))

    weekday_divs = page.all(".flex-1.rounded-md.text-\\[0\\.8rem\\].font-normal.text-muted-foreground")
    weekday_texts = weekday_divs.map(&:text)

    assert_equal %w[Mo Tu We Th Fr Sa Su], weekday_texts
  end

  def test_renders_weekday_headers_starting_saturday
    render_inline(Shadcn::CalendarComponent.new(week_starts_on: 6))

    weekday_divs = page.all(".flex-1.rounded-md.text-\\[0\\.8rem\\].font-normal.text-muted-foreground")
    weekday_texts = weekday_divs.map(&:text)

    assert_equal %w[Sa Su Mo Tu We Th Fr], weekday_texts
  end

  def test_renders_correct_first_day_for_monday_start
    # December 2024: December 1st is a Sunday
    # Week starting Monday should show Nov 25 (Monday) as first day
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 12, 1),
      week_starts_on: 1
    ))

    # First button should be Nov 25 (the Monday before Dec 1)
    assert_selector "button[data-date='2024-11-25']"

    # Verify grid starts with Mon Nov 25
    grid = page.find("[data-shadcn--calendar-target='grid']")
    first_button = grid.all("button[data-shadcn--calendar-target='day']").first
    assert_equal "2024-11-25", first_button["data-date"]
  end

  def test_renders_correct_first_day_for_sunday_start
    # December 2024: December 1st is a Sunday
    # Week starting Sunday should show Dec 1 as first day
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 12, 1),
      week_starts_on: 0
    ))

    grid = page.find("[data-shadcn--calendar-target='grid']")
    first_button = grid.all("button[data-shadcn--calendar-target='day']").first
    assert_equal "2024-12-01", first_button["data-date"]
  end

  def test_week_starts_on_passes_correct_stimulus_value
    render_inline(Shadcn::CalendarComponent.new(week_starts_on: 1))

    assert_selector "[data-shadcn--calendar-week-starts-on-value='1']"
  end

  def test_november_2024_monday_start_correct_layout
    # November 2024: November 1st is a Friday
    # Week starting Monday: first row should be Oct 28 (Mon), Oct 29, Oct 30, Oct 31, Nov 1, Nov 2, Nov 3
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 11, 1),
      week_starts_on: 1
    ))

    # First day in grid should be Monday Oct 28
    grid = page.find("[data-shadcn--calendar-target='grid']")
    all_buttons = grid.all("button[data-shadcn--calendar-target='day']")
    first_button = all_buttons.first

    assert_equal "2024-10-28", first_button["data-date"], "First day should be Monday Oct 28"

    # Nov 1 (Friday) should be the 5th button (index 4)
    nov_1_button = all_buttons[4]
    assert_equal "2024-11-01", nov_1_button["data-date"], "Nov 1 should be in 5th position (Friday)"
  end

  def test_june_2024_monday_start_correct_layout
    # June 2024: June 1st is a Saturday
    # Week starting Monday: first row should be May 27 (Mon), May 28, May 29, May 30, May 31, June 1, June 2
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 6, 1),
      week_starts_on: 1
    ))

    grid = page.find("[data-shadcn--calendar-target='grid']")
    all_buttons = grid.all("button[data-shadcn--calendar-target='day']")

    # First day should be Monday May 27
    assert_equal "2024-05-27", all_buttons[0]["data-date"], "First day should be Monday May 27"

    # June 1 (Saturday) should be the 6th button (index 5)
    assert_equal "2024-06-01", all_buttons[5]["data-date"], "June 1 should be in 6th position (Saturday)"
  end

  def test_february_2024_leap_year_monday_start
    # February 2024: Feb 1 is a Thursday (leap year)
    # Week starting Monday: first row should be Jan 29 (Mon), Jan 30, Jan 31, Feb 1, Feb 2, Feb 3, Feb 4
    render_inline(Shadcn::CalendarComponent.new(
      month: Date.new(2024, 2, 1),
      week_starts_on: 1
    ))

    grid = page.find("[data-shadcn--calendar-target='grid']")
    all_buttons = grid.all("button[data-shadcn--calendar-target='day']")

    # First day should be Monday Jan 29
    assert_equal "2024-01-29", all_buttons[0]["data-date"], "First day should be Monday Jan 29"

    # Feb 29 should exist (leap year)
    assert_selector "button[data-date='2024-02-29']"
  end

  # Month navigation tests (JavaScript handles navigation, Ruby just renders initial state)
  def test_renders_month_select_with_correct_initial_value
    render_inline(Shadcn::CalendarComponent.new(month: Date.new(2024, 6, 15)))

    assert_selector "select[data-shadcn--calendar-target='monthSelect']"
    month_select = page.find("select[data-shadcn--calendar-target='monthSelect']")

    # June should be selected (value 5, 0-indexed)
    selected_option = month_select.find("option[selected]")
    assert_equal "5", selected_option.value
    assert_equal "June", selected_option.text
  end

  def test_renders_year_select_with_correct_range
    render_inline(Shadcn::CalendarComponent.new(month: Date.new(2024, 6, 15)))

    year_select = page.find("select[data-shadcn--calendar-target='yearSelect']")
    options = year_select.all("option")

    # Should have years from 2014 to 2034 (current year ± 10)
    assert_equal 21, options.length

    # Selected year should be 2024
    selected_option = year_select.find("option[selected]")
    assert_equal "2024", selected_option.value
    assert_equal "2024", selected_option.text
  end

  def test_renders_correct_navigation_button_actions
    render_inline(Shadcn::CalendarComponent.new)

    assert_selector "button[data-action='click->shadcn--calendar#previousMonth']"
    assert_selector "button[data-action='click->shadcn--calendar#nextMonth']"
    assert_selector "select[data-action='change->shadcn--calendar#selectMonth']"
    assert_selector "select[data-action='change->shadcn--calendar#selectYear']"
  end
end
