import { Controller } from "@hotwired/stimulus"

/**
 * Date Picker controller
 * Handles opening/closing the calendar popover and date selection
 *
 * API inspired by React DayPicker (https://daypicker.dev/)
 */
export default class extends Controller {
  static targets = ["trigger", "content", "grid", "monthYear", "day", "displayValue", "hiddenInput"]
  static values = {
    open: { type: Boolean, default: false },
    month: String,
    selected: String,
    format: { type: String, default: "medium" },
    placeholder: { type: String, default: "Pick a date" }
  }

  static MONTHS = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ]

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

  toggle() {
    this.openValue = !this.openValue
  }

  open() {
    this.openValue = true
  }

  close() {
    this.openValue = false
  }

  openValueChanged() {
    if (this.hasContentTarget) {
      this.contentTarget.style.display = this.openValue ? "block" : "none"
    }
    if (this.hasTriggerTarget) {
      this.triggerTarget.setAttribute("aria-expanded", this.openValue.toString())
    }
  }

  closeOnClickOutside(event) {
    if (!this.openValue) return
    if (this.element.contains(event.target)) return

    this.close()
  }

  previousMonth() {
    this.currentMonth.setMonth(this.currentMonth.getMonth() - 1)
    this.render()
  }

  nextMonth() {
    this.currentMonth.setMonth(this.currentMonth.getMonth() + 1)
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

    // Update display value
    if (this.hasDisplayValueTarget) {
      this.displayValueTarget.textContent = this.formatDate(this.selectedDate)
      this.displayValueTarget.classList.remove("text-muted-foreground")
    }

    // Re-render calendar to update selection styling
    this.render()

    // Close the popover
    this.close()

    // Dispatch custom event
    this.dispatch("select", {
      detail: {
        date: this.selectedDate,
        dateString: dateStr
      }
    })
  }

  formatDate(date) {
    switch (this.formatValue) {
      case "short":
        return `${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getDate().toString().padStart(2, '0')}/${date.getFullYear()}`
      case "long":
        return date.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric', year: 'numeric' })
      case "iso":
        // Use local date components to avoid timezone issues
        return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
      case "medium":
      default:
        return date.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })
    }
  }

  render() {
    // Update month/year label
    if (this.hasMonthYearTarget) {
      const monthName = this.constructor.MONTHS[this.currentMonth.getMonth()]
      const year = this.currentMonth.getFullYear()
      this.monthYearTarget.textContent = `${monthName} ${year}`
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

      html += `<button type="button" class="${classes}" data-date="${dateStr}" data-shadcn--date-picker-target="day" data-action="click->shadcn--date-picker#selectDay"${isSelected ? ' aria-selected="true"' : ""}>${currentDate.getDate()}</button>`

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
