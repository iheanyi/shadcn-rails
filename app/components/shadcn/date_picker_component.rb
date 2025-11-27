# frozen_string_literal: true

module Shadcn
  # Date Picker component - a button that opens a calendar popover
  # Composition of Popover and Calendar components
  # Matches shadcn/ui Date Picker component
  #
  # @example Basic date picker
  #   <%= render Shadcn::DatePickerComponent.new %>
  #
  # @example With selected date
  #   <%= render Shadcn::DatePickerComponent.new(selected: Date.today) %>
  #
  # @example With name for form submission
  #   <%= render Shadcn::DatePickerComponent.new(name: "event[date]") %>
  #
  # @example With date constraints
  #   <%= render Shadcn::DatePickerComponent.new(
  #     min_date: Date.today,
  #     max_date: Date.today + 30.days
  #   ) %>
  #
  class DatePickerComponent < BaseComponent
    TRIGGER_CLASSES = "inline-flex items-center justify-start whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground h-9 px-4 py-2 w-[240px] pl-3 text-left"
    PLACEHOLDER_CLASSES = "text-muted-foreground"
    CONTENT_CLASSES = "p-0 w-auto"

    MONTHS = %w[January February March April May June July August September October November December].freeze

    # @param selected [Date, nil] Currently selected date
    # @param month [Date, nil] Month to display (defaults to current month)
    # @param min_date [Date, nil] Minimum selectable date
    # @param max_date [Date, nil] Maximum selectable date
    # @param name [String, nil] Form field name for hidden input
    # @param disabled_dates [Array<Date>] Specific dates that cannot be selected
    # @param disabled_days_of_week [Array<Integer>] Days of week to disable (0=Sun, 6=Sat)
    # @param show_outside_days [Boolean] Whether to show days outside current month
    # @param week_starts_on [Integer] First day of week (0=Sunday, 1=Monday, etc.)
    # @param placeholder [String] Placeholder text when no date selected
    # @param format [Symbol] Date format (:short, :medium, :long)
    # @param disabled [Boolean] Whether the date picker is disabled
    def initialize(
      selected: nil,
      month: nil,
      min_date: nil,
      max_date: nil,
      name: nil,
      disabled_dates: [],
      disabled_days_of_week: [],
      show_outside_days: true,
      week_starts_on: 0,
      placeholder: "Pick a date",
      format: :medium,
      disabled: false,
      **options
    )
      super(**options)
      @selected = selected
      @month = month || selected || Date.today
      @min_date = min_date
      @max_date = max_date
      @name = name
      @disabled_dates = disabled_dates
      @disabled_days_of_week = disabled_days_of_week
      @show_outside_days = show_outside_days
      @week_starts_on = week_starts_on
      @placeholder = placeholder
      @format = format
      @disabled = disabled
    end

    def call
      content_tag(:div, picker_content, picker_attributes)
    end

    private

    def picker_content
      safe_join([
        hidden_input,
        trigger_button,
        popover_content
      ].compact)
    end

    def hidden_input
      return unless @name

      tag.input(
        type: "hidden",
        name: @name,
        value: @selected&.iso8601,
        data: { "shadcn--date-picker-target": "hiddenInput" }
      )
    end

    def trigger_button
      content_tag(:button,
        trigger_content,
        type: "button",
        class: cn(TRIGGER_CLASSES, ("cursor-not-allowed opacity-50" if @disabled)),
        disabled: @disabled || nil,
        "aria-haspopup": "dialog",
        "aria-expanded": "false",
        data: {
          "shadcn--date-picker-target": "trigger",
          action: "click->shadcn--date-picker#toggle"
        }
      )
    end

    def trigger_content
      safe_join([
        calendar_icon,
        date_display
      ])
    end

    def calendar_icon
      content_tag(:svg,
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: "mr-2 h-4 w-4"
      ) do
        safe_join([
          tag.path(d: "M8 2v4"),
          tag.path(d: "M16 2v4"),
          tag.rect(width: "18", height: "18", x: "3", y: "4", rx: "2"),
          tag.path(d: "M3 10h18")
        ])
      end
    end

    def date_display
      if @selected
        content_tag(:span, format_date(@selected), data: { "shadcn--date-picker-target": "displayValue" })
      else
        content_tag(:span, @placeholder, class: PLACEHOLDER_CLASSES, data: { "shadcn--date-picker-target": "displayValue" })
      end
    end

    def format_date(date)
      case @format
      when :short
        date.strftime("%m/%d/%Y")
      when :medium
        date.strftime("%B %-d, %Y") # e.g., "November 26, 2024"
      when :long
        date.strftime("%A, %B %-d, %Y") # e.g., "Tuesday, November 26, 2024"
      when :iso
        date.iso8601
      else
        date.strftime("%B %-d, %Y")
      end
    end

    def popover_content
      content_tag(:div,
        calendar,
        class: cn("absolute z-50 mt-1 rounded-md border bg-popover shadow-md", CONTENT_CLASSES),
        "data-shadcn--date-picker-target": "content",
        style: "display: none;"
      )
    end

    def calendar
      content_tag(:div, calendar_content, calendar_attributes)
    end

    def calendar_content
      safe_join([
        calendar_header,
        weekday_header,
        days_grid
      ])
    end

    def calendar_header
      content_tag(:div, class: "flex items-center justify-between p-3 pb-0") do
        safe_join([
          prev_month_button,
          month_year_label,
          next_month_button
        ])
      end
    end

    def prev_month_button
      content_tag(:button,
        chevron_left_icon,
        type: "button",
        class: "inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground h-7 w-7",
        "aria-label": "Previous month",
        data: { action: "click->shadcn--date-picker#previousMonth" }
      )
    end

    def next_month_button
      content_tag(:button,
        chevron_right_icon,
        type: "button",
        class: "inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground h-7 w-7",
        "aria-label": "Next month",
        data: { action: "click->shadcn--date-picker#nextMonth" }
      )
    end

    def month_year_label
      content_tag(:div,
        "#{MONTHS[@month.month - 1]} #{@month.year}",
        class: "text-sm font-medium",
        data: { "shadcn--date-picker-target": "monthYear" }
      )
    end

    def weekday_header
      content_tag(:div, class: "grid grid-cols-7 gap-1 p-3 pb-0") do
        safe_join(CalendarComponent::WEEKDAYS.map do |day|
          content_tag(:div, day, class: "text-center text-xs font-medium text-muted-foreground")
        end)
      end
    end

    def days_grid
      content_tag(:div, class: "grid grid-cols-7 gap-1 p-3", data: { "shadcn--date-picker-target": "grid" }) do
        safe_join(calendar_days.map { |day| render_day(day) })
      end
    end

    def calendar_days
      first_day = @month.beginning_of_month
      last_day = @month.end_of_month

      start_date = first_day.beginning_of_week(:sunday)
      end_date = last_day.end_of_week(:sunday)

      (start_date..end_date).to_a
    end

    def render_day(date)
      is_outside = date.month != @month.month
      is_selected = @selected && date == @selected
      is_today = date == Date.today
      is_disabled = date_disabled?(date)

      return empty_day if is_outside && !@show_outside_days

      classes = ["h-8 w-8 text-center text-sm p-0 relative flex items-center justify-center rounded-md cursor-pointer hover:bg-accent hover:text-accent-foreground focus:outline-none focus:ring-1 focus:ring-ring"]
      classes << "bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground" if is_selected
      classes << "bg-accent text-accent-foreground" if is_today && !is_selected
      classes << "text-muted-foreground opacity-50" if is_outside
      classes << "text-muted-foreground opacity-50 pointer-events-none" if is_disabled

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
          "shadcn--date-picker-target": "day",
          action: is_disabled ? nil : "click->shadcn--date-picker#selectDay"
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
        class: "p-0",
        role: "grid",
        "aria-label": "Calendar",
        data: {
          "shadcn--date-picker-month-value": @month.iso8601,
          "shadcn--date-picker-selected-value": @selected&.iso8601,
          "shadcn--date-picker-format-value": @format.to_s,
          "shadcn--date-picker-placeholder-value": @placeholder
        }
      }
    end

    def picker_attributes
      {
        class: cn("relative inline-block", class_name),
        data: stimulus_data
      }.merge(html_options).merge(build_data)
    end

    def stimulus_data
      data = {
        controller: "shadcn--date-picker",
        "shadcn--date-picker-open-value": "false",
        "shadcn--date-picker-month-value": @month.iso8601,
        "shadcn--date-picker-selected-value": @selected&.iso8601,
        "shadcn--date-picker-format-value": @format.to_s,
        "shadcn--date-picker-placeholder-value": @placeholder,
        "shadcn--date-picker-show-outside-days-value": @show_outside_days.to_s,
        "shadcn--date-picker-week-starts-on-value": @week_starts_on.to_s,
        action: "keydown.escape->shadcn--date-picker#close click@window->shadcn--date-picker#closeOnClickOutside"
      }

      # Add optional values only if present
      data["shadcn--date-picker-min-date-value"] = @min_date.iso8601 if @min_date
      data["shadcn--date-picker-max-date-value"] = @max_date.iso8601 if @max_date
      data["shadcn--date-picker-disabled-dates-value"] = format_disabled_dates if @disabled_dates.any?
      data["shadcn--date-picker-disabled-days-of-week-value"] = @disabled_days_of_week.join(",") if @disabled_days_of_week.any?

      data
    end

    def format_disabled_dates
      @disabled_dates.map(&:iso8601).join(",")
    end
  end
end
