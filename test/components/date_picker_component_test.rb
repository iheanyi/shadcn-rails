# frozen_string_literal: true

require "test_helper"

class DatePickerComponentTest < ViewComponent::TestCase
  def test_renders_basic_date_picker
    render_inline(Shadcn::DatePickerComponent.new)

    assert_selector "[data-controller='shadcn--date-picker']"
    assert_selector "button[aria-haspopup='dialog']"
  end

  def test_renders_trigger_button
    render_inline(Shadcn::DatePickerComponent.new)

    assert_selector "button[data-shadcn--date-picker-target='trigger']"
    assert_selector "button[data-action='click->shadcn--date-picker#toggle']"
    assert_selector "button[data-slot='button']"

    classes = page.find("button[data-shadcn--date-picker-target='trigger']")["class"].split
    assert_includes classes, "shadow-xs"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "focus-visible:ring-ring/50"
    assert_includes classes, "h-9"
    assert_includes classes, "has-[>svg]:px-3"
    refute_includes classes, "border-input"
    refute_includes classes, "shadow-sm"
    refute_includes classes, "focus-visible:outline-none"
    refute_includes classes, "focus-visible:ring-1"
  end

  def test_renders_placeholder_when_no_date_selected
    render_inline(Shadcn::DatePickerComponent.new(placeholder: "Select a date"))

    assert_text "Select a date"
    assert_selector ".text-muted-foreground"
  end

  def test_renders_selected_date
    selected = Date.new(2024, 6, 15)
    render_inline(Shadcn::DatePickerComponent.new(selected: selected))

    # Default medium format
    assert_text "June 15, 2024"
  end

  def test_renders_short_date_format
    selected = Date.new(2024, 6, 15)
    render_inline(Shadcn::DatePickerComponent.new(selected: selected, format: :short))

    assert_text "06/15/2024"
  end

  def test_renders_long_date_format
    selected = Date.new(2024, 6, 15) # Saturday
    render_inline(Shadcn::DatePickerComponent.new(selected: selected, format: :long))

    assert_text "Saturday, June 15, 2024"
  end

  def test_renders_calendar_icon
    render_inline(Shadcn::DatePickerComponent.new)

    assert_selector "svg"
    assert_includes rendered_content, "M8 2v4" # Calendar icon path
    assert_includes rendered_content, "mr-2 size-4"
    refute_includes rendered_content, "mr-2 h-4 w-4"
  end

  def test_renders_popover_content_hidden
    render_inline(Shadcn::DatePickerComponent.new)

    assert_includes rendered_content, "data-shadcn--date-picker-target=\"content\""
    assert_includes rendered_content, 'style="display: none;"'
  end

  def test_renders_calendar_inside_popover
    render_inline(Shadcn::DatePickerComponent.new(month: Date.new(2024, 6, 1)))

    # Calendar elements inside hidden popover - use raw HTML check
    assert_includes rendered_content, 'role="grid"'
    assert_includes rendered_content, 'data-slot="calendar"'
    assert_includes rendered_content, "data-shadcn--date-picker-target=\"monthYear\""
    assert_includes rendered_content, "June 2024"
    assert_includes rendered_content, "data-shadcn--date-picker-target=\"grid\""
  end

  def test_renders_navigation_buttons
    render_inline(Shadcn::DatePickerComponent.new)

    # Navigation buttons inside hidden popover
    assert_includes rendered_content, "aria-label=\"Previous month\""
    assert_includes rendered_content, "aria-label=\"Next month\""
    # HTML escapes -> to -&gt;
    assert_includes rendered_content, "click-&gt;shadcn--date-picker#previousMonth"
    assert_includes rendered_content, "click-&gt;shadcn--date-picker#nextMonth"
    assert_includes rendered_content, "size-(--cell-size)"
    refute_includes rendered_content, "shadow-sm"
    refute_includes rendered_content, "h-7 w-7"
  end

  def test_renders_weekday_headers
    render_inline(Shadcn::DatePickerComponent.new)

    %w[Su Mo Tu We Th Fr Sa].each do |day|
      assert_includes rendered_content, day
    end
  end

  def test_renders_days_grid
    render_inline(Shadcn::DatePickerComponent.new(month: Date.new(2024, 6, 1)))

    # Days inside hidden popover
    assert_includes rendered_content, "data-shadcn--date-picker-target=\"day\""
    assert_includes rendered_content, "data-date=\"2024-06-15\""
    assert_includes rendered_content, "data-date=\"2024-06-01\""
  end

  def test_hides_outside_days_with_sized_placeholders
    render_inline(Shadcn::DatePickerComponent.new(
      month: Date.new(2024, 6, 1),
      show_outside_days: false
    ))

    refute_includes rendered_content, 'data-date="2024-05-26"'
    assert_selector "div.invisible"
    classes = page.first("div.invisible")["class"].split
    assert_includes classes, "min-w-(--cell-size)"
    assert_includes classes, "w-full"
  end

  def test_day_buttons_use_v4_focus_visible_ring_styles
    render_inline(Shadcn::DatePickerComponent.new(month: Date.new(2024, 6, 1)))

    assert_includes rendered_content, "min-w-(--cell-size)"
    assert_includes rendered_content, "size-auto"
    assert_includes rendered_content, "focus-visible:border-ring"
    assert_includes rendered_content, "focus-visible:ring-[3px]"
    assert_includes rendered_content, "focus-visible:ring-ring/50"
    refute_includes rendered_content, "focus:ring-1"
    refute_includes rendered_content, "focus:outline-none"
    refute_includes rendered_content, "h-8 w-8"
    assert_includes rendered_content, 'data-slot="button"'
    assert_includes rendered_content, "data-day="
  end

  def test_renders_hidden_input_with_name
    render_inline(Shadcn::DatePickerComponent.new(
      name: "event[date]",
      selected: Date.new(2024, 6, 15)
    ))

    assert_includes rendered_content, "input"
    assert_includes rendered_content, "type=\"hidden\""
    assert_includes rendered_content, "name=\"event[date]\""
    assert_includes rendered_content, "value=\"2024-06-15\""
    assert_includes rendered_content, "data-shadcn--date-picker-target=\"hiddenInput\""
  end

  def test_does_not_render_hidden_input_without_name
    render_inline(Shadcn::DatePickerComponent.new(selected: Date.new(2024, 6, 15)))

    refute_includes rendered_content, "type=\"hidden\""
  end

  def test_renders_disabled_state
    render_inline(Shadcn::DatePickerComponent.new(disabled: true))

    assert_selector "button[disabled]"
    assert_includes rendered_content, "cursor-not-allowed"
    assert_includes rendered_content, "opacity-50"
  end

  def test_renders_min_date_constraint
    render_inline(Shadcn::DatePickerComponent.new(
      month: Date.new(2024, 6, 1),
      min_date: Date.new(2024, 6, 15)
    ))

    # Days before min_date should be disabled - check raw HTML
    assert_includes rendered_content, 'data-date="2024-06-14"'
    # Check for disabled attribute on early dates
    refute_includes rendered_content, 'data-date="2024-06-14" data-shadcn--date-picker-target="day" data-action="click'
  end

  def test_renders_max_date_constraint
    render_inline(Shadcn::DatePickerComponent.new(
      month: Date.new(2024, 6, 1),
      max_date: Date.new(2024, 6, 15)
    ))

    # Days after max_date should not have click action
    refute_includes rendered_content, 'data-date="2024-06-16" data-shadcn--date-picker-target="day" data-action="click'
    # Days on or before max_date should have click action
    assert_includes rendered_content, 'data-date="2024-06-15" data-shadcn--date-picker-target="day" data-action="click'
  end

  def test_renders_disabled_dates
    disabled = [Date.new(2024, 6, 10), Date.new(2024, 6, 20)]
    render_inline(Shadcn::DatePickerComponent.new(
      month: Date.new(2024, 6, 1),
      disabled_dates: disabled
    ))

    # Disabled dates should have disabled attribute
    assert_includes rendered_content, 'data-date="2024-06-10"'
    assert_includes rendered_content, 'data-date="2024-06-20"'
    # Check for aria-disabled on those dates
    assert_includes rendered_content, 'aria-disabled="true"'
  end

  def test_renders_selected_day_styling
    selected = Date.new(2024, 6, 15)
    render_inline(Shadcn::DatePickerComponent.new(selected: selected, month: selected))

    assert_includes rendered_content, 'aria-selected="true"'
    assert_includes rendered_content, "bg-primary text-primary-foreground"
  end

  def test_passes_stimulus_data_attributes
    selected = Date.new(2024, 6, 15)
    render_inline(Shadcn::DatePickerComponent.new(
      month: Date.new(2024, 6, 1),
      selected: selected,
      format: :short,
      placeholder: "Choose date"
    ))

    assert_selector "[data-shadcn--date-picker-month-value='2024-06-01']"
    assert_selector "[data-shadcn--date-picker-selected-value='2024-06-15']"
    assert_selector "[data-shadcn--date-picker-format-value='short']"
    assert_selector "[data-shadcn--date-picker-placeholder-value='Choose date']"
  end

  def test_renders_custom_class
    render_inline(Shadcn::DatePickerComponent.new(class_name: "custom-picker"))

    assert_selector ".custom-picker"
  end

  def test_click_outside_action
    render_inline(Shadcn::DatePickerComponent.new)

    # HTML entities get escaped, so check for the escaped version
    assert_includes rendered_content, "click@window-&gt;shadcn--date-picker#closeOnClickOutside"
  end

  def test_escape_key_action
    render_inline(Shadcn::DatePickerComponent.new)

    # HTML entities get escaped
    assert_includes rendered_content, "keydown.escape-&gt;shadcn--date-picker#close"
  end

  def test_day_buttons_have_click_action
    render_inline(Shadcn::DatePickerComponent.new(month: Date.new(2024, 6, 1)))

    # Day buttons should have the select action (HTML escapes -> to -&gt;)
    assert_includes rendered_content, 'data-action="click-&gt;shadcn--date-picker#selectDay"'
    # Multiple occurrences
    assert rendered_content.scan('click-&gt;shadcn--date-picker#selectDay').count >= 28
  end
end
