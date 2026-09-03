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
    CONTAINER_CLASSES = "group/calendar bg-background p-3 [--cell-size:--spacing(8)] [[data-slot=card-content]_&]:bg-transparent [[data-slot=popover-content]_&]:bg-transparent"
    MONTHS_CLASSES = "relative flex flex-col gap-4 md:flex-row"
    MONTH_CLASSES = "flex w-full flex-col gap-4"
    NAV_CLASSES = "absolute inset-x-0 top-0 flex w-full items-center justify-between gap-1"
    MONTH_CAPTION_CLASSES = "flex h-(--cell-size) w-full items-center justify-center px-(--cell-size)"
    MONTH_YEAR_CLASSES = "flex h-(--cell-size) w-full items-center justify-center gap-1.5 text-sm font-medium"
    NAV_BUTTON_CLASSES = "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all outline-none focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background shadow-xs hover:bg-accent hover:text-accent-foreground size-(--cell-size) p-0 select-none aria-disabled:opacity-50"
    MONTH_GRID_CLASSES = "w-full border-collapse"
    WEEKDAY_ROW_CLASSES = "flex"
    WEEKDAY_CLASSES = "flex-1 rounded-md text-[0.8rem] font-normal text-muted-foreground select-none"
    WEEK_CLASSES = "mt-2 flex w-full"
    DAY_CLASSES = "group/day relative aspect-square h-full w-full p-0 text-center select-none [&:last-child[data-selected=true]_button]:rounded-r-md [&:first-child[data-selected=true]_button]:rounded-l-md"
    DAY_BUTTON_CLASSES = "flex aspect-square size-auto w-full min-w-(--cell-size) flex-col gap-1 leading-none font-normal group-data-[focused=true]/day:relative group-data-[focused=true]/day:z-10 group-data-[focused=true]/day:border-ring group-data-[focused=true]/day:ring-[3px] group-data-[focused=true]/day:ring-ring/50 data-[range-end=true]:rounded-md data-[range-end=true]:rounded-r-md data-[range-end=true]:bg-primary data-[range-end=true]:text-primary-foreground data-[range-middle=true]:rounded-none data-[range-middle=true]:bg-accent data-[range-middle=true]:text-accent-foreground data-[range-start=true]:rounded-md data-[range-start=true]:rounded-l-md data-[range-start=true]:bg-primary data-[range-start=true]:text-primary-foreground data-[selected-single=true]:bg-primary data-[selected-single=true]:text-primary-foreground dark:hover:text-accent-foreground [&>span]:text-xs [&>span]:opacity-70"
    DAY_TODAY_CLASSES = "rounded-md bg-accent text-accent-foreground data-[selected=true]:rounded-none"
    DAY_OUTSIDE_CLASSES = "text-muted-foreground aria-selected:text-muted-foreground"
    DAY_DISABLED_CLASSES = "text-muted-foreground opacity-50 pointer-events-none"

    WEEKDAYS = %w[Su Mo Tu We Th Fr Sa].freeze
    # Mapping for Rails beginning_of_week symbols
    WEEK_START_SYMBOLS = {
      0 => :sunday,
      1 => :monday,
      2 => :tuesday,
      3 => :wednesday,
      4 => :thursday,
      5 => :friday,
      6 => :saturday
    }.freeze
    MONTHS = %w[January February March April May June July August September October November December].freeze

    MODES = %i[single multiple range].freeze

    # @param selected [Date, Array<Date>, nil] Currently selected date(s)
    # @param month [Date, nil] Month to display (defaults to current month)
    # @param min_date [Date, nil] Minimum selectable date
    # @param max_date [Date, nil] Maximum selectable date
    # @param name [String, nil] Form field name for hidden input
    # @param disabled_dates [Array<Date>] Specific dates that cannot be selected
    # @param disabled_days_of_week [Array<Integer>] Days of week to disable (0=Sun, 6=Sat)
    # @param show_outside_days [Boolean] Whether to show days outside current month
    # @param mode [Symbol] Selection mode: :single, :multiple, or :range
    # @param required [Boolean] Whether a selection is required (prevents deselection)
    # @param week_starts_on [Integer] First day of week (0=Sunday, 1=Monday, etc.)
    def initialize(
      selected: nil,
      month: nil,
      min_date: nil,
      max_date: nil,
      name: nil,
      disabled_dates: [],
      disabled_days_of_week: [],
      show_outside_days: true,
      mode: :single,
      required: false,
      week_starts_on: 0,
      **options
    )
      super(**options)
      @selected = selected
      @month = month || (selected.is_a?(Array) ? selected.first : selected) || Date.today
      @min_date = min_date
      @max_date = max_date
      @name = name
      @disabled_dates = disabled_dates
      @disabled_days_of_week = disabled_days_of_week
      @show_outside_days = show_outside_days
      @mode = mode.to_sym
      @required = required
      @week_starts_on = week_starts_on
    end

    def call
      content_tag(:div, calendar_content, **calendar_attributes)
    end

    private

    def calendar_content
      safe_join([
        hidden_input,
        content_tag(:div, month_content, class: MONTHS_CLASSES)
      ].compact)
    end

    def hidden_input
      return unless @name

      tag.input(
        type: "hidden",
        name: @name,
        value: format_selected_value,
        data: { "shadcn--calendar-target": "hiddenInput" }
      )
    end

    def header
      content_tag(:div, class: MONTH_CAPTION_CLASSES) do
        safe_join([
          content_tag(:div, safe_join([prev_button, next_button]), class: NAV_CLASSES),
          month_year_selectors
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
      content_tag(:div, class: MONTH_YEAR_CLASSES) do
        safe_join([
          month_select,
          year_select
        ])
      end
    end

    def month_select
      content_tag(:select,
        class: cn(
          "relative rounded-md border border-input bg-transparent text-sm font-medium shadow-xs cursor-pointer",
          "hover:bg-accent hover:text-accent-foreground px-2 py-1",
          "outline-hidden has-focus:border-ring has-focus:ring-[3px] has-focus:ring-ring/50 focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50"
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
          "relative rounded-md border border-input bg-transparent text-sm font-medium shadow-xs cursor-pointer",
          "hover:bg-accent hover:text-accent-foreground px-2 py-1",
          "outline-hidden has-focus:border-ring has-focus:ring-[3px] has-focus:ring-ring/50 focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50"
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
      content_tag(:div, class: WEEKDAY_ROW_CLASSES) do
        safe_join(rotated_weekdays.map { |day| content_tag(:div, day, class: WEEKDAY_CLASSES) })
      end
    end

    def rotated_weekdays
      WEEKDAYS.rotate(@week_starts_on)
    end

    def days_grid
      content_tag(:div, class: MONTH_GRID_CLASSES, data: { "shadcn--calendar-target": "grid" }) do
        safe_join(calendar_weeks.map { |week| content_tag(:div, safe_join(week.map { |day| render_day(day) }), class: WEEK_CLASSES) })
      end
    end

    def month_content
      content_tag(:div, safe_join([header, weekday_header, days_grid]), class: MONTH_CLASSES)
    end

    def calendar_days
      first_day = @month.beginning_of_month
      last_day = @month.end_of_month

      # Get the week start symbol from the mapping (defaults to :sunday)
      week_start_symbol = WEEK_START_SYMBOLS[@week_starts_on] || :sunday

      # Get the starting day based on week_starts_on
      start_date = first_day.beginning_of_week(week_start_symbol)
      # Get the ending day based on week_starts_on
      end_date = last_day.end_of_week(week_start_symbol)

      (start_date..end_date).to_a
    end

    def calendar_weeks
      calendar_days.each_slice(7)
    end

    def render_day(date)
      is_outside = date.month != @month.month
      is_selected = selected_date?(date)
      is_today = date == Date.today
      is_disabled = date_disabled?(date)

      return empty_day if is_outside && !@show_outside_days

      content_tag(:div, day_button(date, is_selected, is_today, is_outside, is_disabled), day_cell_attributes(date, is_selected))
    end

    def empty_day
      content_tag(:div, "", class: "invisible")
    end

    def day_button(date, is_selected, is_today, is_outside, is_disabled)
      content_tag(:button,
        date.day.to_s,
        type: "button",
        class: cn(
          DAY_BUTTON_CLASSES,
          is_today && !is_selected ? DAY_TODAY_CLASSES : "",
          is_outside ? DAY_OUTSIDE_CLASSES : "",
          is_disabled ? DAY_DISABLED_CLASSES : ""
        ),
        tabindex: is_disabled ? "-1" : "0",
        "aria-selected": is_selected || nil,
        "aria-disabled": is_disabled || nil,
        disabled: is_disabled || nil,
        data: day_button_data(date, is_selected, is_disabled)
      )
    end

    def day_cell_attributes(date, is_selected)
      {
        class: cn(DAY_CLASSES, range_cell_classes(date)),
        "data-selected": is_selected ? "true" : nil,
        "data-focused": "false"
      }.compact
    end

    def day_button_data(date, is_selected, is_disabled)
      {
        date: date.iso8601,
        "shadcn--calendar-target": "day",
        action: is_disabled ? nil : "click->shadcn--calendar#selectDay",
        selected: is_selected ? "true" : nil,
        "selected-single": @mode == :single && is_selected ? "true" : nil,
        "range-start": range_start?(date) ? "true" : nil,
        "range-middle": range_middle?(date) ? "true" : nil,
        "range-end": range_end?(date) ? "true" : nil
      }.compact
    end

    def range_cell_classes(date)
      return "" unless @mode == :range

      if range_start?(date)
        "rounded-l-md bg-accent"
      elsif range_middle?(date)
        "rounded-none"
      elsif range_end?(date)
        "rounded-r-md bg-accent"
      else
        ""
      end
    end

    def selected_date?(date)
      case @selected
      when Array
        @selected.include?(date) || (@mode == :range && range_middle?(date))
      else
        @selected && date == @selected
      end
    end

    def range_start?(date)
      @mode == :range && @selected.is_a?(Array) && @selected.first == date
    end

    def range_middle?(date)
      return false unless @mode == :range && @selected.is_a?(Array) && @selected.size >= 2

      date > @selected.first && date < @selected.last
    end

    def range_end?(date)
      @mode == :range && @selected.is_a?(Array) && @selected.last == date
    end

    def date_disabled?(date)
      return true if @min_date && date < @min_date
      return true if @max_date && date > @max_date
      return true if @disabled_dates.include?(date)
      return true if @disabled_days_of_week.include?(date.wday)

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
        data: stimulus_data
      }.merge(html_options).merge(build_data)
    end

    def stimulus_data
      data = {
        controller: "shadcn--calendar",
        "shadcn--calendar-month-value": @month.iso8601,
        "shadcn--calendar-selected-value": format_selected_value,
        "shadcn--calendar-mode-value": @mode.to_s,
        "shadcn--calendar-required-value": @required.to_s,
        "shadcn--calendar-week-starts-on-value": @week_starts_on.to_s,
        "shadcn--calendar-show-outside-days-value": @show_outside_days.to_s
      }

      # Add optional values only if present
      data["shadcn--calendar-min-date-value"] = @min_date.iso8601 if @min_date
      data["shadcn--calendar-max-date-value"] = @max_date.iso8601 if @max_date
      data["shadcn--calendar-disabled-dates-value"] = format_disabled_dates if @disabled_dates.any?
      data["shadcn--calendar-disabled-days-of-week-value"] = @disabled_days_of_week.join(",") if @disabled_days_of_week.any?

      data
    end

    def format_selected_value
      return nil unless @selected

      case @selected
      when Array
        @selected.map(&:iso8601).join(",")
      else
        @selected.iso8601
      end
    end

    def format_disabled_dates
      @disabled_dates.map(&:iso8601).join(",")
    end
  end
end
