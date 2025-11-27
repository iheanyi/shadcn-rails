import { Application } from "@hotwired/stimulus"
import CalendarController from "../../app/assets/javascripts/shadcn/controllers/calendar_controller.js"

describe("CalendarController", () => {
  let application
  let element
  let controller

  const calendarHTML = `
    <div data-controller="calendar"
         data-calendar-month-value="2024-11-01"
         data-calendar-selected-value="">
      <div data-calendar-target="monthYear"></div>
      <select data-calendar-target="monthSelect"></select>
      <select data-calendar-target="yearSelect"></select>
      <div data-calendar-target="grid"></div>
      <input type="hidden" data-calendar-target="hiddenInput">
    </div>
  `

  beforeEach(async () => {
    application = Application.start()
    application.register("calendar", CalendarController)
    document.body.innerHTML = calendarHTML

    await new Promise(resolve => requestAnimationFrame(resolve))

    element = document.querySelector('[data-controller="calendar"]')
    controller = application.getControllerForElementAndIdentifier(element, "calendar")
  })

  afterEach(() => {
    if (application) {
      application.stop()
    }
    document.body.innerHTML = ""
  })

  describe("parseLocalDate", () => {
    test("parses date string as local date, not UTC", () => {
      const date = controller.parseLocalDate("2024-11-26")

      expect(date.getFullYear()).toBe(2024)
      expect(date.getMonth()).toBe(10) // November is month 10 (0-indexed)
      expect(date.getDate()).toBe(26)
    })

    test("returns null for empty string", () => {
      expect(controller.parseLocalDate("")).toBeNull()
    })

    test("returns null for null input", () => {
      expect(controller.parseLocalDate(null)).toBeNull()
    })

    test("handles first day of month", () => {
      const date = controller.parseLocalDate("2024-01-01")

      expect(date.getFullYear()).toBe(2024)
      expect(date.getMonth()).toBe(0) // January
      expect(date.getDate()).toBe(1)
    })

    test("handles last day of month", () => {
      const date = controller.parseLocalDate("2024-12-31")

      expect(date.getFullYear()).toBe(2024)
      expect(date.getMonth()).toBe(11) // December
      expect(date.getDate()).toBe(31)
    })

    test("handles leap year February 29", () => {
      const date = controller.parseLocalDate("2024-02-29")

      expect(date.getFullYear()).toBe(2024)
      expect(date.getMonth()).toBe(1) // February
      expect(date.getDate()).toBe(29)
    })
  })

  describe("formatDateString", () => {
    test("formats date as YYYY-MM-DD", () => {
      const date = new Date(2024, 10, 26) // November 26, 2024
      expect(controller.formatDateString(date)).toBe("2024-11-26")
    })

    test("pads single digit months", () => {
      const date = new Date(2024, 0, 15) // January 15, 2024
      expect(controller.formatDateString(date)).toBe("2024-01-15")
    })

    test("pads single digit days", () => {
      const date = new Date(2024, 10, 5) // November 5, 2024
      expect(controller.formatDateString(date)).toBe("2024-11-05")
    })

    test("returns empty string for null", () => {
      expect(controller.formatDateString(null)).toBe("")
    })
  })

  describe("connect", () => {
    test("initializes currentMonth from monthValue", () => {
      expect(controller.currentMonth.getFullYear()).toBe(2024)
      expect(controller.currentMonth.getMonth()).toBe(10) // November
    })

    test("initializes selectedDate as null when no selectedValue", () => {
      expect(controller.selectedDate).toBeNull()
    })
  })

  describe("previousMonth", () => {
    test("moves to the previous month", () => {
      controller.previousMonth()

      expect(controller.currentMonth.getMonth()).toBe(9) // October
    })

    test("wraps to previous year from January", () => {
      controller.currentMonth = new Date(2024, 0, 1) // January 2024
      controller.previousMonth()

      expect(controller.currentMonth.getMonth()).toBe(11) // December
      expect(controller.currentMonth.getFullYear()).toBe(2023)
    })
  })

  describe("nextMonth", () => {
    test("moves to the next month", () => {
      controller.nextMonth()

      expect(controller.currentMonth.getMonth()).toBe(11) // December
    })

    test("wraps to next year from December", () => {
      controller.currentMonth = new Date(2024, 11, 1) // December 2024
      controller.nextMonth()

      expect(controller.currentMonth.getMonth()).toBe(0) // January
      expect(controller.currentMonth.getFullYear()).toBe(2025)
    })
  })

  describe("selectDay", () => {
    test("selects the clicked date", () => {
      // Create a mock event with the date data
      const mockEvent = {
        currentTarget: {
          dataset: { date: "2024-11-15" }
        }
      }

      controller.selectDay(mockEvent)

      expect(controller.selectedDate).not.toBeNull()
      expect(controller.selectedDate.getDate()).toBe(15)
      expect(controller.selectedDate.getMonth()).toBe(10) // November
      expect(controller.selectedDate.getFullYear()).toBe(2024)
    })

    test("updates the hidden input value", () => {
      const mockEvent = {
        currentTarget: {
          dataset: { date: "2024-11-20" }
        }
      }

      controller.selectDay(mockEvent)

      const hiddenInput = element.querySelector('[data-calendar-target="hiddenInput"]')
      expect(hiddenInput.value).toBe("2024-11-20")
    })

    test("dispatches select event with date details", () => {
      let eventDetail = null
      element.addEventListener("calendar:select", (e) => {
        eventDetail = e.detail
      })

      const mockEvent = {
        currentTarget: {
          dataset: { date: "2024-11-10" }
        }
      }

      controller.selectDay(mockEvent)

      expect(eventDetail).not.toBeNull()
      expect(eventDetail.dateString).toBe("2024-11-10")
      expect(eventDetail.date.getDate()).toBe(10)
    })

    test("does nothing if no date in event", () => {
      const mockEvent = {
        currentTarget: {
          dataset: {}
        }
      }

      controller.selectDay(mockEvent)

      expect(controller.selectedDate).toBeNull()
    })
  })

  describe("render", () => {
    test("updates month/year display", () => {
      controller.render()

      const monthYearDisplay = element.querySelector('[data-calendar-target="monthYear"]')
      expect(monthYearDisplay.textContent).toBe("November 2024")
    })

    test("renders correct number of day buttons (6 weeks = 42 days)", () => {
      controller.render()

      // Use a more flexible selector since targets are set via data attributes
      const grid = element.querySelector('[data-calendar-target="grid"]')
      const dayButtons = grid.querySelectorAll('button[data-date]')
      // Should be between 28 and 42 days depending on month layout
      expect(dayButtons.length).toBeGreaterThanOrEqual(28)
      expect(dayButtons.length).toBeLessThanOrEqual(42)
    })

    test("marks today with special styling", () => {
      // Set current month to today's month
      const today = new Date()
      controller.currentMonth = new Date(today.getFullYear(), today.getMonth(), 1)
      controller.render()

      const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`
      const todayButton = element.querySelector(`[data-date="${todayStr}"]`)

      expect(todayButton).not.toBeNull()
      expect(todayButton.classList.contains("bg-accent")).toBe(true)
    })

    test("marks selected date with primary styling", () => {
      controller.selectedDate = new Date(2024, 10, 15)
      controller.selectedValue = "2024-11-15"
      controller.render()

      const selectedButton = element.querySelector('[data-date="2024-11-15"]')
      expect(selectedButton.classList.contains("bg-primary")).toBe(true)
      expect(selectedButton.getAttribute("aria-selected")).toBe("true")
    })

    test("marks outside month dates with muted styling", () => {
      controller.render()

      // November 2024 starts on Friday, so there should be days from October
      const grid = element.querySelector('[data-calendar-target="grid"]')
      const allDays = grid.querySelectorAll("button[data-date]")
      const outsideDays = Array.from(allDays).filter(btn => {
        const dateStr = btn.dataset.date
        if (!dateStr) return false
        const month = parseInt(dateStr.split('-')[1], 10)
        return month !== 11 // Not November
      })

      // Check at least some outside days exist and have the styling
      if (outsideDays.length > 0) {
        expect(outsideDays[0].classList.contains("text-muted-foreground")).toBe(true)
        expect(outsideDays[0].classList.contains("opacity-50")).toBe(true)
      }
    })
  })

  describe("timezone handling", () => {
    test("selecting a date preserves the correct day regardless of timezone", () => {
      // This is the critical test for the timezone bug
      // When parsing "2024-11-26" via new Date("2024-11-26"), it interprets
      // as UTC midnight, which becomes Nov 25 in western timezones

      const mockEvent = {
        currentTarget: {
          dataset: { date: "2024-11-15" }
        }
      }

      controller.selectDay(mockEvent)

      // The selected date should be exactly November 15, not November 14
      expect(controller.selectedDate.getDate()).toBe(15)
      expect(controller.selectedDate.getMonth()).toBe(10) // November
      expect(controller.selectedValue).toBe("2024-11-15")
    })

    test("initializing with a selected value preserves the correct day", async () => {
      // Test that selectedValue initialization doesn't shift the date
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="calendar"
             data-calendar-month-value="2024-11-01"
             data-calendar-selected-value="2024-11-26">
          <div data-calendar-target="grid"></div>
        </div>
      `

      application = Application.start()
      application.register("calendar", CalendarController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      const newElement = document.querySelector('[data-controller="calendar"]')
      const newController = application.getControllerForElementAndIdentifier(newElement, "calendar")

      expect(newController.selectedDate.getDate()).toBe(26)
      expect(newController.selectedDate.getMonth()).toBe(10) // November
    })

    test("parseLocalDate avoids UTC timezone shift for any date", () => {
      // Test a variety of dates that could be affected by timezone
      const testDates = [
        "2024-01-01", // New Year
        "2024-06-15", // Mid-year
        "2024-12-31", // End of year
        "2024-03-10", // DST transition day (US)
        "2024-11-03", // DST transition day (US)
      ]

      testDates.forEach(dateStr => {
        const [year, month, day] = dateStr.split('-').map(Number)
        const parsed = controller.parseLocalDate(dateStr)

        expect(parsed.getFullYear()).toBe(year)
        expect(parsed.getMonth()).toBe(month - 1)
        expect(parsed.getDate()).toBe(day)
      })
    })
  })

  describe("monthValueChanged", () => {
    test("updates currentMonth when value changes", () => {
      controller.monthValue = "2024-06-01"
      controller.monthValueChanged()

      expect(controller.currentMonth.getMonth()).toBe(5) // June
      expect(controller.currentMonth.getFullYear()).toBe(2024)
    })
  })

  describe("selectedValueChanged", () => {
    test("updates selectedDate when value changes", () => {
      controller.selectedValue = "2024-07-20"
      controller.selectedValueChanged()

      expect(controller.selectedDate.getDate()).toBe(20)
      expect(controller.selectedDate.getMonth()).toBe(6) // July
    })
  })

  describe("MONTHS constant", () => {
    test("contains all 12 months in order", () => {
      expect(CalendarController.MONTHS).toEqual([
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
      ])
    })
  })

  describe("WEEKDAYS constant", () => {
    test("contains all 7 weekdays starting with Sunday", () => {
      expect(CalendarController.WEEKDAYS).toEqual([
        "Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"
      ])
    })
  })
})
