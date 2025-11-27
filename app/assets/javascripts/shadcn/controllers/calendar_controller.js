import { Controller } from "@hotwired/stimulus"

/**
 * Calendar controller for date picker
 * Handles month navigation, date selection, and rendering
 *
 * API inspired by React DayPicker (https://daypicker.dev/)
 */
export default class extends Controller {
  static targets = ["grid", "monthYear", "monthSelect", "yearSelect", "day", "hiddenInput"]
  static values = {
    month: String,
    selected: String
  }

  static MONTHS = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ]
  static WEEKDAYS = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

  connect() {
    this.currentMonth = this.monthValue ? this.parseLocalDate(this.monthValue) : new Date()
    this.selectedDate = this.selectedValue ? this.parseLocalDate(this.selectedValue) : null
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

    this.selectedDate = this.parseLocalDate(dateStr)
    this.selectedValue = dateStr

    // Update hidden input
    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = dateStr
    }

    // Re-render to update selection styling
    this.render()

    // Dispatch custom event
    this.dispatch("select", {
      detail: {
        date: this.selectedDate,
        dateString: dateStr
      }
    })
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

    // Get start date (Sunday of first week)
    const startDate = new Date(firstDay)
    startDate.setDate(firstDay.getDate() - firstDay.getDay())

    // Get end date (Saturday of last week)
    const endDate = new Date(lastDay)
    endDate.setDate(lastDay.getDate() + (6 - lastDay.getDay()))

    const today = new Date()
    today.setHours(0, 0, 0, 0)

    let html = ""
    const currentDate = new Date(startDate)

    while (currentDate <= endDate) {
      const isOutside = currentDate.getMonth() !== month
      const isToday = currentDate.getTime() === today.getTime()
      const isSelected = this.selectedDate &&
        currentDate.toDateString() === this.selectedDate.toDateString()

      // Use local date components to avoid timezone issues with toISOString()
      const dateStr = `${currentDate.getFullYear()}-${String(currentDate.getMonth() + 1).padStart(2, '0')}-${String(currentDate.getDate()).padStart(2, '0')}`

      let classes = "h-8 w-8 text-center text-sm p-0 relative flex items-center justify-center rounded-md cursor-pointer hover:bg-accent hover:text-accent-foreground focus:outline-none focus:ring-1 focus:ring-ring"

      if (isSelected) {
        classes += " bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground"
      } else if (isToday) {
        classes += " bg-accent text-accent-foreground"
      }

      if (isOutside) {
        classes += " text-muted-foreground opacity-50"
      }

      html += `<button type="button" class="${classes}" data-date="${dateStr}" data-shadcn--calendar-target="day" data-action="click->shadcn--calendar#selectDay"${isSelected ? ' aria-selected="true"' : ""}>${currentDate.getDate()}</button>`

      currentDate.setDate(currentDate.getDate() + 1)
    }

    return html
  }

  monthValueChanged() {
    if (this.monthValue) {
      this.currentMonth = this.parseLocalDate(this.monthValue)
    }
  }

  selectedValueChanged() {
    if (this.selectedValue) {
      this.selectedDate = this.parseLocalDate(this.selectedValue)
    }
  }
}
