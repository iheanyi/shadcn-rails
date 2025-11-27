# frozen_string_literal: true

module Shadcn
  # Calendar component - date picker grid
  # Matches shadcn/ui Calendar component
  #
  # @example Basic calendar
  #   <%= render Shadcn::CalendarComponent.new %>
  #
  # @example With selected date
  #   <%= render Shadcn::CalendarComponent.new(selected: Date.today) %>
  #
  # @example With name for form submission
  #   <%= render Shadcn::CalendarComponent.new(name: "event[date]") %>
  #
  class CalendarComponent < BaseComponent
    CONTAINER_CLASSES = "p-3 rounded-md border bg-background"
    HEADER_CLASSES = "flex items-center justify-between mb-4"
    MONTH_YEAR_CLASSES = "text-sm font-medium"
    NAV_BUTTON_CLASSES = "inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground h-7 w-7"
    WEEKDAY_CLASSES = "text-center text-xs font-medium text-muted-foreground"
    DAY_CLASSES = "h-8 w-8 text-center text-sm p-0 relative flex items-center justify-center rounded-md cursor-pointer hover:bg-accent hover:text-accent-foreground focus:outline-none focus:ring-1 focus:ring-ring"
    DAY_SELECTED_CLASSES = "bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground"
    DAY_TODAY_CLASSES = "bg-accent text-accent-foreground"
    DAY_OUTSIDE_CLASSES = "text-muted-foreground opacity-50"
    DAY_DISABLED_CLASSES = "text-muted-foreground opacity-50 pointer-events-none"

    WEEKDAYS = %w[Su Mo Tu We Th Fr Sa].freeze
    MONTHS = %w[January February March April May June July August September October November December].freeze

    # @param selected [Date, nil] Currently selected date
    # @param month [Date, nil] Month to display (defaults to current month)
    # @param min_date [Date, nil] Minimum selectable date
    # @param max_date [Date, nil] Maximum selectable date
    # @param name [String, nil] Form field name for hidden input
    # @param disabled_dates [Array<Date>] Specific dates that cannot be selected
    # @param show_outside_days [Boolean] Whether to show days outside current month
    def initialize(
      selected: nil,
      month: nil,
      min_date: nil,
      max_date: nil,
      name: nil,
      disabled_dates: [],
      show_outside_days: true,
      **options
    )
      super(**options)
      @selected = selected
      @month = month || selected || Date.today
      @min_date = min_date
      @max_date = max_date
      @name = name
      @disabled_dates = disabled_dates
      @show_outside_days = show_outside_days
    end

    def call
      content_tag(:div, calendar_content, **calendar_attributes)
    end

    private

    def calendar_content
      safe_join([
        hidden_input,
        header,
        weekday_header,
        days_grid
      ].compact)
    end

    def hidden_input
      return unless @name

      tag.input(
        type: "hidden",
        name: @name,
        value: @selected&.iso8601,
        data: { "shadcn--calendar-target": "hiddenInput" }
      )
    end

    def header
      content_tag(:div, class: HEADER_CLASSES) do
        safe_join([
          prev_button,
          month_year_selectors,
          next_button
        ])
      end
    end

    def prev_button
      content_tag(:button,
        chevron_left_icon,
        type: "button",
        class: NAV_BUTTON_CLASSES,
        "aria-label": "Previous month",
        data: { action: "click->shadcn--calendar#previousMonth" }
      )
    end

    def next_button
      content_tag(:button,
        chevron_right_icon,
        type: "button",
        class: NAV_BUTTON_CLASSES,
        "aria-label": "Next month",
        data: { action: "click->shadcn--calendar#nextMonth" }
      )
    end

    def month_year_selectors
      content_tag(:div, class: "flex items-center gap-1") do
        safe_join([
          month_select,
          year_select
        ])
      end
    end

    def month_select
      content_tag(:select,
        class: cn(
          "appearance-none bg-transparent text-sm font-medium cursor-pointer",
          "hover:bg-accent hover:text-accent-foreground rounded px-2 py-1",
          "focus:outline-none focus:ring-1 focus:ring-ring"
        ),
        data: {
          "shadcn--calendar-target": "monthSelect",
          action: "change->shadcn--calendar#selectMonth"
        }
      ) do
        safe_join(MONTHS.each_with_index.map { |month, index|
          content_tag(:option, month, value: index, selected: index == @month.month - 1)
        })
      end
    end

    def year_select
      # Generate year range: current year -10 to +10
      current_year = @month.year
      year_range = (current_year - 10)..(current_year + 10)

      content_tag(:select,
        class: cn(
          "appearance-none bg-transparent text-sm font-medium cursor-pointer",
          "hover:bg-accent hover:text-accent-foreground rounded px-2 py-1",
          "focus:outline-none focus:ring-1 focus:ring-ring"
        ),
        data: {
          "shadcn--calendar-target": "yearSelect",
          action: "change->shadcn--calendar#selectYear"
        }
      ) do
        safe_join(year_range.map { |year|
          content_tag(:option, year, value: year, selected: year == current_year)
        })
      end
    end

    def weekday_header
      content_tag(:div, class: "grid grid-cols-7 gap-1 mb-2") do
        safe_join(WEEKDAYS.map { |day| content_tag(:div, day, class: WEEKDAY_CLASSES) })
      end
    end

    def days_grid
      content_tag(:div, class: "grid grid-cols-7 gap-1", data: { "shadcn--calendar-target": "grid" }) do
        safe_join(calendar_days.map { |day| render_day(day) })
      end
    end

    def calendar_days
      first_day = @month.beginning_of_month
      last_day = @month.end_of_month

      # Get the starting day (Sunday of the week containing the first day)
      start_date = first_day.beginning_of_week(:sunday)
      # Get the ending day (Saturday of the week containing the last day)
      end_date = last_day.end_of_week(:sunday)

      (start_date..end_date).to_a
    end

    def render_day(date)
      is_outside = date.month != @month.month
      is_selected = @selected && date == @selected
      is_today = date == Date.today
      is_disabled = date_disabled?(date)

      return empty_day if is_outside && !@show_outside_days

      classes = [DAY_CLASSES]
      classes << DAY_SELECTED_CLASSES if is_selected
      classes << DAY_TODAY_CLASSES if is_today && !is_selected
      classes << DAY_OUTSIDE_CLASSES if is_outside
      classes << DAY_DISABLED_CLASSES if is_disabled

      content_tag(:button,
        date.day.to_s,
        type: "button",
        class: cn(*classes),
        tabindex: is_disabled ? "-1" : "0",
        "aria-selected": is_selected || nil,
        "aria-disabled": is_disabled || nil,
        disabled: is_disabled || nil,
        data: {
          date: date.iso8601,
          "shadcn--calendar-target": "day",
          action: is_disabled ? nil : "click->shadcn--calendar#selectDay"
        }.compact
      )
    end

    def empty_day
      content_tag(:div, "", class: "h-8 w-8")
    end

    def date_disabled?(date)
      return true if @min_date && date < @min_date
      return true if @max_date && date > @max_date
      return true if @disabled_dates.include?(date)

      false
    end

    def chevron_left_icon
      content_tag(:svg,
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round"
      ) do
        tag.path(d: "m15 18-6-6 6-6")
      end
    end

    def chevron_right_icon
      content_tag(:svg,
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round"
      ) do
        tag.path(d: "m9 18 6-6-6-6")
      end
    end

    def calendar_attributes
      {
        class: cn(CONTAINER_CLASSES, class_name),
        role: "grid",
        "aria-label": "Calendar",
        data: {
          controller: "shadcn--calendar",
          "shadcn--calendar-month-value": @month.iso8601,
          "shadcn--calendar-selected-value": @selected&.iso8601
        }
      }.merge(html_options).merge(build_data)
    end
  end
end
