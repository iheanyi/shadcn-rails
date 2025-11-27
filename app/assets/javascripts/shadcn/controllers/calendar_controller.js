import { Controller } from "@hotwired/stimulus"

/**
 * Calendar controller for date picker
 * Handles month navigation, date selection, and rendering
 *
 * API inspired by React DayPicker (https://daypicker.dev/)
 *
 * Selection modes:
 * - single: Select one date at a time (default)
 * - multiple: Select multiple individual dates
 * - range: Select a date range (start to end)
 *
 * Disabled dates:
 * - minDate/maxDate: Disable dates outside a range
 * - disabledDates: Comma-separated list of YYYY-MM-DD dates
 * - disabledDaysOfWeek: Comma-separated list of day numbers (0=Sun, 6=Sat)
 */
export default class extends Controller {
  static targets = ["grid", "monthYear", "monthSelect", "yearSelect", "day", "hiddenInput"]
  static values = {
    month: String,
    selected: String,
    mode: { type: String, default: "single" }, // single, multiple, range
    minDate: String,
    maxDate: String,
    disabledDates: String, // comma-separated YYYY-MM-DD
    disabledDaysOfWeek: String, // comma-separated 0-6
    required: { type: Boolean, default: false },
    weekStartsOn: { type: Number, default: 0 } // 0 = Sunday, 1 = Monday, etc.
  }

  static MONTHS = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ]
  static WEEKDAYS = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

  connect() {
    this.currentMonth = this.monthValue ? this.parseLocalDate(this.monthValue) : new Date()
    this.initializeSelection()
    this.focusedDate = null
    this.boundHandleKeydown = this.handleKeydown.bind(this)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundHandleKeydown)
  }

  /**
   * Initialize selected date(s) based on mode
   */
  initializeSelection() {
    if (!this.selectedValue) {
      this.selectedDate = this.modeValue === "multiple" ? [] : null
      this.rangeStart = null
      this.rangeEnd = null
      return
    }

    switch (this.modeValue) {
      case "multiple":
        this.selectedDate = this.selectedValue.split(",").map(d => this.parseLocalDate(d.trim())).filter(Boolean)
        break
      case "range":
        const [start, end] = this.selectedValue.split(",").map(d => this.parseLocalDate(d.trim()))
        this.rangeStart = start || null
        this.rangeEnd = end || null
        this.selectedDate = null
        break
      default:
        this.selectedDate = this.parseLocalDate(this.selectedValue)
    }
  }

  /**
   * Parse a date string (YYYY-MM-DD) as local date, not UTC
   * This prevents timezone issues where "2024-11-26" becomes Nov 25 in western timezones
   */
  parseLocalDate(dateStr) {
    if (!dateStr) return null
    const [year, month, day] = dateStr.split('-').map(Number)
    return new Date(year, month - 1, day)
  }

  /**
   * Format a date as YYYY-MM-DD using local date components
   */
  formatDateString(date) {
    if (!date) return ''
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
  }

  /**
   * Check if a date is disabled
   */
  isDateDisabled(date) {
    const dateStr = this.formatDateString(date)

    // Check min/max date
    if (this.minDateValue) {
      const minDate = this.parseLocalDate(this.minDateValue)
      if (date < minDate) return true
    }
    if (this.maxDateValue) {
      const maxDate = this.parseLocalDate(this.maxDateValue)
      if (date > maxDate) return true
    }

    // Check disabled dates list
    if (this.disabledDatesValue) {
      const disabledDates = this.disabledDatesValue.split(",").map(d => d.trim())
      if (disabledDates.includes(dateStr)) return true
    }

    // Check disabled days of week
    if (this.disabledDaysOfWeekValue) {
      const disabledDays = this.disabledDaysOfWeekValue.split(",").map(d => parseInt(d.trim(), 10))
      if (disabledDays.includes(date.getDay())) return true
    }

    return false
  }

  /**
   * Check if a date is selected
   */
  isDateSelected(date) {
    if (this.modeValue === "multiple" && Array.isArray(this.selectedDate)) {
      return this.selectedDate.some(d => d.toDateString() === date.toDateString())
    }
    if (this.modeValue === "range") {
      if (this.rangeStart && date.toDateString() === this.rangeStart.toDateString()) return true
      if (this.rangeEnd && date.toDateString() === this.rangeEnd.toDateString()) return true
      return false
    }
    return this.selectedDate && date.toDateString() === this.selectedDate.toDateString()
  }

  /**
   * Check if a date is in range (for range mode)
   */
  isDateInRange(date) {
    if (this.modeValue !== "range" || !this.rangeStart || !this.rangeEnd) return false
    return date > this.rangeStart && date < this.rangeEnd
  }

  /**
   * Check if date is the start of a range
   */
  isRangeStart(date) {
    if (this.modeValue !== "range" || !this.rangeStart) return false
    return date.toDateString() === this.rangeStart.toDateString()
  }

  /**
   * Check if date is the end of a range
   */
  isRangeEnd(date) {
    if (this.modeValue !== "range" || !this.rangeEnd) return false
    return date.toDateString() === this.rangeEnd.toDateString()
  }

  previousMonth() {
    this.currentMonth.setMonth(this.currentMonth.getMonth() - 1)
    this.render()
  }

  nextMonth() {
    this.currentMonth.setMonth(this.currentMonth.getMonth() + 1)
    this.render()
  }

  selectMonth(event) {
    const month = parseInt(event.target.value, 10)
    this.currentMonth.setMonth(month)
    this.render()
  }

  selectYear(event) {
    const year = parseInt(event.target.value, 10)
    this.currentMonth.setFullYear(year)
    this.render()
  }

  selectDay(event) {
    const dateStr = event.currentTarget.dataset.date
    if (!dateStr) return

    const date = this.parseLocalDate(dateStr)

    // Check if disabled
    if (this.isDateDisabled(date)) return

    switch (this.modeValue) {
      case "multiple":
        this.handleMultipleSelection(date, dateStr)
        break
      case "range":
        this.handleRangeSelection(date, dateStr)
        break
      default:
        this.handleSingleSelection(date, dateStr)
    }

    // Re-render to update selection styling
    this.render()
  }

  handleSingleSelection(date, dateStr) {
    // If required is true, don't allow deselection
    if (this.requiredValue && this.selectedDate && date.toDateString() === this.selectedDate.toDateString()) {
      return
    }

    // Toggle selection if already selected
    if (this.selectedDate && date.toDateString() === this.selectedDate.toDateString()) {
      this.selectedDate = null
      this.selectedValue = ""
      if (this.hasHiddenInputTarget) {
        this.hiddenInputTarget.value = ""
      }
      this.dispatchSelectEvent(null, "")
      return
    }

    this.selectedDate = date
    this.selectedValue = dateStr

    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = dateStr
    }

    this.dispatchSelectEvent(date, dateStr)
  }

  handleMultipleSelection(date, dateStr) {
    const index = this.selectedDate.findIndex(d => d.toDateString() === date.toDateString())

    if (index >= 0) {
      // Deselect if required allows it
      if (!this.requiredValue || this.selectedDate.length > 1) {
        this.selectedDate.splice(index, 1)
      }
    } else {
      this.selectedDate.push(date)
    }

    const dateStrings = this.selectedDate.map(d => this.formatDateString(d))
    this.selectedValue = dateStrings.join(",")

    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = this.selectedValue
    }

    this.dispatch("select", {
      detail: {
        dates: this.selectedDate,
        dateStrings: dateStrings
      }
    })
  }

  handleRangeSelection(date, dateStr) {
    // If no start, set start
    if (!this.rangeStart) {
      this.rangeStart = date
      this.rangeEnd = null
      this.selectedValue = dateStr
    }
    // If start exists but no end, set end (ensure start < end)
    else if (!this.rangeEnd) {
      if (date < this.rangeStart) {
        this.rangeEnd = this.rangeStart
        this.rangeStart = date
      } else if (date.toDateString() === this.rangeStart.toDateString()) {
        // Clicking same date resets
        this.rangeStart = null
        this.selectedValue = ""
      } else {
        this.rangeEnd = date
      }
      this.selectedValue = this.rangeStart
        ? `${this.formatDateString(this.rangeStart)}${this.rangeEnd ? `,${this.formatDateString(this.rangeEnd)}` : ""}`
        : ""
    }
    // If both exist, start new selection
    else {
      this.rangeStart = date
      this.rangeEnd = null
      this.selectedValue = dateStr
    }

    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = this.selectedValue
    }

    this.dispatch("select", {
      detail: {
        rangeStart: this.rangeStart,
        rangeEnd: this.rangeEnd,
        dateString: this.selectedValue
      }
    })
  }

  dispatchSelectEvent(date, dateStr) {
    this.dispatch("select", {
      detail: {
        date: date,
        dateString: dateStr
      }
    })
  }

  /**
   * Handle keyboard navigation
   */
  handleKeydown(event) {
    if (!this.focusedDate) {
      this.focusedDate = this.selectedDate || new Date()
    }

    let newDate = new Date(this.focusedDate)
    let handled = false

    switch (event.key) {
      case "ArrowLeft":
        newDate.setDate(newDate.getDate() - 1)
        handled = true
        break
      case "ArrowRight":
        newDate.setDate(newDate.getDate() + 1)
        handled = true
        break
      case "ArrowUp":
        newDate.setDate(newDate.getDate() - 7)
        handled = true
        break
      case "ArrowDown":
        newDate.setDate(newDate.getDate() + 7)
        handled = true
        break
      case "PageUp":
        if (event.shiftKey) {
          newDate.setFullYear(newDate.getFullYear() - 1)
        } else {
          newDate.setMonth(newDate.getMonth() - 1)
        }
        handled = true
        break
      case "PageDown":
        if (event.shiftKey) {
          newDate.setFullYear(newDate.getFullYear() + 1)
        } else {
          newDate.setMonth(newDate.getMonth() + 1)
        }
        handled = true
        break
      case "Home":
        newDate.setDate(1)
        handled = true
        break
      case "End":
        newDate = new Date(newDate.getFullYear(), newDate.getMonth() + 1, 0)
        handled = true
        break
      case "Enter":
      case " ":
        if (!this.isDateDisabled(this.focusedDate)) {
          this.selectDay({
            currentTarget: {
              dataset: { date: this.formatDateString(this.focusedDate) }
            }
          })
        }
        handled = true
        break
    }

    if (handled) {
      event.preventDefault()

      // Skip disabled dates when navigating
      while (this.isDateDisabled(newDate)) {
        const direction = event.key.includes("Left") || event.key.includes("Up") ? -1 : 1
        newDate.setDate(newDate.getDate() + direction)
      }

      this.focusedDate = newDate

      // Update current month if focused date is in different month
      if (newDate.getMonth() !== this.currentMonth.getMonth() ||
          newDate.getFullYear() !== this.currentMonth.getFullYear()) {
        this.currentMonth = new Date(newDate.getFullYear(), newDate.getMonth(), 1)
      }

      this.render()
      this.focusDay(newDate)
    }
  }

  /**
   * Focus a specific day button
   */
  focusDay(date) {
    const dateStr = this.formatDateString(date)
    const dayButton = this.element.querySelector(`[data-date="${dateStr}"]`)
    if (dayButton) {
      dayButton.focus()
    }
  }

  /**
   * Enable keyboard navigation when calendar gets focus
   */
  enableKeyboard() {
    document.addEventListener("keydown", this.boundHandleKeydown)
    if (!this.focusedDate) {
      this.focusedDate = this.selectedDate || new Date()
    }
  }

  /**
   * Disable keyboard navigation
   */
  disableKeyboard() {
    document.removeEventListener("keydown", this.boundHandleKeydown)
  }

  render() {
    // Update month/year label (for backwards compatibility)
    if (this.hasMonthYearTarget) {
      const monthName = this.constructor.MONTHS[this.currentMonth.getMonth()]
      const year = this.currentMonth.getFullYear()
      this.monthYearTarget.textContent = `${monthName} ${year}`
    }

    // Update month select
    if (this.hasMonthSelectTarget) {
      this.monthSelectTarget.value = this.currentMonth.getMonth()
    }

    // Update year select
    if (this.hasYearSelectTarget) {
      this.yearSelectTarget.value = this.currentMonth.getFullYear()
    }

    // Render days grid
    if (this.hasGridTarget) {
      this.gridTarget.innerHTML = this.renderDays()
    }
  }

  renderDays() {
    const year = this.currentMonth.getFullYear()
    const month = this.currentMonth.getMonth()

    // Get first and last day of month
    const firstDay = new Date(year, month, 1)
    const lastDay = new Date(year, month + 1, 0)

    // Get start date based on weekStartsOn
    const startDate = new Date(firstDay)
    const dayOffset = (firstDay.getDay() - this.weekStartsOnValue + 7) % 7
    startDate.setDate(firstDay.getDate() - dayOffset)

    // Get end date (complete the last week)
    const endDate = new Date(lastDay)
    const endDayOffset = (6 - lastDay.getDay() + this.weekStartsOnValue) % 7
    endDate.setDate(lastDay.getDate() + endDayOffset)

    const today = new Date()
    today.setHours(0, 0, 0, 0)

    let html = ""
    const currentDate = new Date(startDate)

    while (currentDate <= endDate) {
      const isOutside = currentDate.getMonth() !== month
      const isToday = currentDate.getTime() === today.getTime()
      const isSelected = this.isDateSelected(currentDate)
      const isInRange = this.isDateInRange(currentDate)
      const isRangeStart = this.isRangeStart(currentDate)
      const isRangeEnd = this.isRangeEnd(currentDate)
      const isDisabled = this.isDateDisabled(currentDate)
      const isFocused = this.focusedDate && currentDate.toDateString() === this.focusedDate.toDateString()

      const dateStr = this.formatDateString(currentDate)

      let classes = "h-8 w-8 text-center text-sm p-0 relative flex items-center justify-center focus:outline-none focus:ring-1 focus:ring-ring"

      // Range styling
      if (isInRange) {
        classes += " bg-accent/50"
      }
      if (isRangeStart) {
        classes += " rounded-l-md"
      }
      if (isRangeEnd) {
        classes += " rounded-r-md"
      }
      if (!isRangeStart && !isRangeEnd && !isInRange) {
        classes += " rounded-md"
      }

      // Selection and state styling
      if (isDisabled) {
        classes += " text-muted-foreground opacity-50 cursor-not-allowed"
      } else if (isSelected) {
        classes += " bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground cursor-pointer"
      } else if (isToday && !isInRange) {
        classes += " bg-accent text-accent-foreground cursor-pointer hover:bg-accent hover:text-accent-foreground"
      } else if (!isInRange) {
        classes += " cursor-pointer hover:bg-accent hover:text-accent-foreground"
      } else {
        classes += " cursor-pointer hover:bg-accent hover:text-accent-foreground"
      }

      if (isOutside && !isDisabled) {
        classes += " text-muted-foreground opacity-50"
      }

      const ariaAttrs = []
      if (isSelected) ariaAttrs.push('aria-selected="true"')
      if (isDisabled) ariaAttrs.push('aria-disabled="true"')
      if (isFocused) ariaAttrs.push('tabindex="0"')
      else ariaAttrs.push('tabindex="-1"')

      html += `<button type="button" class="${classes}" data-date="${dateStr}" data-shadcn--calendar-target="day" data-action="click->shadcn--calendar#selectDay focus->shadcn--calendar#enableKeyboard blur->shadcn--calendar#disableKeyboard" ${ariaAttrs.join(" ")}>${currentDate.getDate()}</button>`

      currentDate.setDate(currentDate.getDate() + 1)
    }

    return html
  }

  /**
   * Go to today's date
   */
  goToToday() {
    const today = new Date()
    this.currentMonth = new Date(today.getFullYear(), today.getMonth(), 1)
    this.focusedDate = today
    this.render()
  }

  monthValueChanged() {
    if (this.monthValue) {
      this.currentMonth = this.parseLocalDate(this.monthValue)
    }
  }

  selectedValueChanged() {
    this.initializeSelection()
  }
}
