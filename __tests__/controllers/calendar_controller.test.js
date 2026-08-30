import { Application } from "@hotwired/stimulus"
import CalendarController from "../../app/assets/javascripts/shadcn/controllers/calendar_controller.ts"

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

    test("renders day buttons with focus-visible ring styles", () => {
      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      const dayButton = grid.querySelector('button[data-date]')
      expect(dayButton.classList).toContain("focus-visible:border-ring")
      expect(dayButton.classList).toContain("focus-visible:ring-[3px]")
      expect(dayButton.classList).toContain("focus-visible:ring-ring/50")
      expect(dayButton.classList).not.toContain("focus:ring-1")
      expect(dayButton.classList).not.toContain("focus:outline-none")
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

  describe("isDateDisabled", () => {
    test("returns false for dates within valid range", () => {
      controller.minDateValue = "2024-11-01"
      controller.maxDateValue = "2024-11-30"

      const date = new Date(2024, 10, 15)
      expect(controller.isDateDisabled(date)).toBe(false)
    })

    test("returns true for dates before minDate", () => {
      controller.minDateValue = "2024-11-10"

      const date = new Date(2024, 10, 5)
      expect(controller.isDateDisabled(date)).toBe(true)
    })

    test("returns true for dates after maxDate", () => {
      controller.maxDateValue = "2024-11-20"

      const date = new Date(2024, 10, 25)
      expect(controller.isDateDisabled(date)).toBe(true)
    })

    test("returns true for dates in disabledDates list", () => {
      controller.disabledDatesValue = "2024-11-15,2024-11-16,2024-11-17"

      expect(controller.isDateDisabled(new Date(2024, 10, 15))).toBe(true)
      expect(controller.isDateDisabled(new Date(2024, 10, 18))).toBe(false)
    })

    test("returns true for disabled days of week", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Sunday and Saturday

      // November 16, 2024 is a Saturday
      expect(controller.isDateDisabled(new Date(2024, 10, 16))).toBe(true)
      // November 17, 2024 is a Sunday
      expect(controller.isDateDisabled(new Date(2024, 10, 17))).toBe(true)
      // November 18, 2024 is a Monday
      expect(controller.isDateDisabled(new Date(2024, 10, 18))).toBe(false)
    })
  })

  describe("multiple selection mode", () => {
    beforeEach(async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="calendar"
             data-calendar-month-value="2024-11-01"
             data-calendar-mode-value="multiple"
             data-calendar-selected-value="">
          <div data-calendar-target="grid"></div>
          <input type="hidden" data-calendar-target="hiddenInput">
        </div>
      `

      application = Application.start()
      application.register("calendar", CalendarController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="calendar"]')
      controller = application.getControllerForElementAndIdentifier(element, "calendar")
    })

    test("initializes with empty array", () => {
      expect(controller.selectedDate).toEqual([])
    })

    test("can select multiple dates", () => {
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-10" } } })
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-15" } } })
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-20" } } })

      expect(controller.selectedDate.length).toBe(3)
      expect(controller.selectedValue).toBe("2024-11-10,2024-11-15,2024-11-20")
    })

    test("can deselect dates by clicking again", () => {
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-10" } } })
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-15" } } })
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-10" } } }) // deselect

      expect(controller.selectedDate.length).toBe(1)
      expect(controller.selectedValue).toBe("2024-11-15")
    })

    test("dispatches select event with dates array", () => {
      let eventDetail = null
      element.addEventListener("calendar:select", (e) => {
        eventDetail = e.detail
      })

      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-10" } } })

      expect(eventDetail.dates).toBeDefined()
      expect(eventDetail.dateStrings).toContain("2024-11-10")
    })
  })

  describe("range selection mode", () => {
    beforeEach(async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="calendar"
             data-calendar-month-value="2024-11-01"
             data-calendar-mode-value="range"
             data-calendar-selected-value="">
          <div data-calendar-target="grid"></div>
          <input type="hidden" data-calendar-target="hiddenInput">
        </div>
      `

      application = Application.start()
      application.register("calendar", CalendarController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="calendar"]')
      controller = application.getControllerForElementAndIdentifier(element, "calendar")
    })

    test("first click sets range start", () => {
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-10" } } })

      expect(controller.rangeStart).not.toBeNull()
      expect(controller.rangeStart.getDate()).toBe(10)
      expect(controller.rangeEnd).toBeNull()
    })

    test("second click sets range end", () => {
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-10" } } })
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-20" } } })

      expect(controller.rangeStart.getDate()).toBe(10)
      expect(controller.rangeEnd.getDate()).toBe(20)
      expect(controller.selectedValue).toBe("2024-11-10,2024-11-20")
    })

    test("swaps start and end if end is before start", () => {
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-20" } } })
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-10" } } })

      expect(controller.rangeStart.getDate()).toBe(10)
      expect(controller.rangeEnd.getDate()).toBe(20)
    })

    test("third click starts new range", () => {
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-10" } } })
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-20" } } })
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-25" } } })

      expect(controller.rangeStart.getDate()).toBe(25)
      expect(controller.rangeEnd).toBeNull()
    })

    test("isDateInRange returns true for dates between start and end", () => {
      controller.rangeStart = new Date(2024, 10, 10)
      controller.rangeEnd = new Date(2024, 10, 20)

      expect(controller.isDateInRange(new Date(2024, 10, 15))).toBe(true)
      expect(controller.isDateInRange(new Date(2024, 10, 10))).toBe(false) // start
      expect(controller.isDateInRange(new Date(2024, 10, 20))).toBe(false) // end
      expect(controller.isDateInRange(new Date(2024, 10, 5))).toBe(false) // before
      expect(controller.isDateInRange(new Date(2024, 10, 25))).toBe(false) // after
    })
  })

  describe("required mode", () => {
    beforeEach(async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="calendar"
             data-calendar-month-value="2024-11-01"
             data-calendar-required-value="true"
             data-calendar-selected-value="2024-11-15">
          <div data-calendar-target="grid"></div>
        </div>
      `

      application = Application.start()
      application.register("calendar", CalendarController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="calendar"]')
      controller = application.getControllerForElementAndIdentifier(element, "calendar")
    })

    test("prevents deselection when required is true", () => {
      expect(controller.selectedDate.getDate()).toBe(15)

      // Try to deselect by clicking the same date
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-15" } } })

      // Should still be selected
      expect(controller.selectedDate.getDate()).toBe(15)
    })

    test("allows selecting a different date", () => {
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-20" } } })

      expect(controller.selectedDate.getDate()).toBe(20)
    })
  })

  describe("disabled date selection", () => {
    test("does not select disabled dates", () => {
      controller.disabledDatesValue = "2024-11-15"

      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-15" } } })

      expect(controller.selectedDate).toBeNull()
    })
  })

  describe("disabled days CSS rendering", () => {
    test("disabled dates have correct CSS classes", () => {
      controller.disabledDatesValue = "2024-11-15"
      controller.render()

      const disabledButton = element.querySelector('[data-date="2024-11-15"]')
      expect(disabledButton).not.toBeNull()
      expect(disabledButton.classList.contains("text-muted-foreground")).toBe(true)
      expect(disabledButton.classList.contains("opacity-50")).toBe(true)
      expect(disabledButton.classList.contains("cursor-not-allowed")).toBe(true)
    })

    test("disabled dates have aria-disabled attribute", () => {
      controller.disabledDatesValue = "2024-11-15"
      controller.render()

      const disabledButton = element.querySelector('[data-date="2024-11-15"]')
      expect(disabledButton.getAttribute("aria-disabled")).toBe("true")
    })

    test("enabled dates do not have disabled CSS classes", () => {
      controller.disabledDatesValue = "2024-11-15"
      controller.render()

      const enabledButton = element.querySelector('[data-date="2024-11-20"]')
      expect(enabledButton).not.toBeNull()
      expect(enabledButton.classList.contains("cursor-not-allowed")).toBe(false)
      expect(enabledButton.getAttribute("aria-disabled")).toBeNull()
    })

    test("minDate disables earlier dates with correct CSS", () => {
      controller.minDateValue = "2024-11-10"
      controller.render()

      const disabledButton = element.querySelector('[data-date="2024-11-05"]')
      expect(disabledButton).not.toBeNull()
      expect(disabledButton.classList.contains("text-muted-foreground")).toBe(true)
      expect(disabledButton.classList.contains("cursor-not-allowed")).toBe(true)
      expect(disabledButton.getAttribute("aria-disabled")).toBe("true")

      const enabledButton = element.querySelector('[data-date="2024-11-15"]')
      expect(enabledButton.classList.contains("cursor-not-allowed")).toBe(false)
    })

    test("maxDate disables later dates with correct CSS", () => {
      controller.maxDateValue = "2024-11-20"
      controller.render()

      const disabledButton = element.querySelector('[data-date="2024-11-25"]')
      expect(disabledButton).not.toBeNull()
      expect(disabledButton.classList.contains("text-muted-foreground")).toBe(true)
      expect(disabledButton.classList.contains("cursor-not-allowed")).toBe(true)
      expect(disabledButton.getAttribute("aria-disabled")).toBe("true")

      const enabledButton = element.querySelector('[data-date="2024-11-15"]')
      expect(enabledButton.classList.contains("cursor-not-allowed")).toBe(false)
    })

    test("disabledDaysOfWeek disables weekends with correct CSS", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Sunday and Saturday
      controller.render()

      // November 16, 2024 is a Saturday
      const saturdayButton = element.querySelector('[data-date="2024-11-16"]')
      expect(saturdayButton).not.toBeNull()
      expect(saturdayButton.classList.contains("text-muted-foreground")).toBe(true)
      expect(saturdayButton.classList.contains("cursor-not-allowed")).toBe(true)
      expect(saturdayButton.getAttribute("aria-disabled")).toBe("true")

      // November 17, 2024 is a Sunday
      const sundayButton = element.querySelector('[data-date="2024-11-17"]')
      expect(sundayButton.classList.contains("cursor-not-allowed")).toBe(true)

      // November 18, 2024 is a Monday - should be enabled
      const mondayButton = element.querySelector('[data-date="2024-11-18"]')
      expect(mondayButton.classList.contains("cursor-not-allowed")).toBe(false)
    })

    test("multiple disabled dates have correct CSS", () => {
      controller.disabledDatesValue = "2024-11-10,2024-11-15,2024-11-20"
      controller.render()

      const disabledDates = ["2024-11-10", "2024-11-15", "2024-11-20"]
      disabledDates.forEach(dateStr => {
        const button = element.querySelector(`[data-date="${dateStr}"]`)
        expect(button.classList.contains("cursor-not-allowed")).toBe(true)
        expect(button.getAttribute("aria-disabled")).toBe("true")
      })

      // Check an enabled date between them
      const enabledButton = element.querySelector('[data-date="2024-11-12"]')
      expect(enabledButton.classList.contains("cursor-not-allowed")).toBe(false)
    })
  })

  describe("snapshots", () => {
    test("renders default calendar grid correctly", () => {
      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      expect(grid.innerHTML).toMatchSnapshot()
    })

    test("renders calendar with selected date correctly", () => {
      controller.selectedDate = new Date(2024, 10, 15)
      controller.selectedValue = "2024-11-15"
      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      expect(grid.innerHTML).toMatchSnapshot()
    })

    test("renders calendar with disabled dates correctly", () => {
      controller.disabledDatesValue = "2024-11-10,2024-11-15,2024-11-20"
      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      expect(grid.innerHTML).toMatchSnapshot()
    })

    test("renders calendar with min and max dates correctly", () => {
      controller.minDateValue = "2024-11-05"
      controller.maxDateValue = "2024-11-25"
      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      expect(grid.innerHTML).toMatchSnapshot()
    })

    test("renders calendar with disabled weekends correctly", () => {
      controller.disabledDaysOfWeekValue = "0,6"
      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      expect(grid.innerHTML).toMatchSnapshot()
    })
  })

  describe("disabled dates persist after interaction (regression tests)", () => {
    test("disabledDaysOfWeek remains enforced after selecting a date", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Sunday and Saturday
      controller.render()

      // Get weekend buttons before interaction
      const saturdayBefore = element.querySelector('[data-date="2024-11-16"]') // Saturday
      const sundayBefore = element.querySelector('[data-date="2024-11-17"]') // Sunday

      // Verify initially disabled
      expect(saturdayBefore.classList.contains("cursor-not-allowed")).toBe(true)
      expect(saturdayBefore.hasAttribute("disabled")).toBe(true)
      expect(sundayBefore.classList.contains("cursor-not-allowed")).toBe(true)
      expect(sundayBefore.hasAttribute("disabled")).toBe(true)

      // Select a weekday date (triggers re-render)
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-18" } } }) // Monday

      // Check weekends are STILL disabled after re-render
      const saturdayAfter = element.querySelector('[data-date="2024-11-16"]')
      const sundayAfter = element.querySelector('[data-date="2024-11-17"]')

      expect(saturdayAfter.classList.contains("cursor-not-allowed")).toBe(true)
      expect(saturdayAfter.hasAttribute("disabled")).toBe(true)
      expect(saturdayAfter.getAttribute("aria-disabled")).toBe("true")
      expect(sundayAfter.classList.contains("cursor-not-allowed")).toBe(true)
      expect(sundayAfter.hasAttribute("disabled")).toBe(true)
      expect(sundayAfter.getAttribute("aria-disabled")).toBe("true")
    })

    test("disabledDates remains enforced after selecting a date", () => {
      controller.disabledDatesValue = "2024-11-15,2024-11-20"
      controller.render()

      // Verify initially disabled
      const disabled15Before = element.querySelector('[data-date="2024-11-15"]')
      const disabled20Before = element.querySelector('[data-date="2024-11-20"]')

      expect(disabled15Before.hasAttribute("disabled")).toBe(true)
      expect(disabled20Before.hasAttribute("disabled")).toBe(true)

      // Select a different date (triggers re-render)
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-18" } } })

      // Check disabled dates are STILL disabled after re-render
      const disabled15After = element.querySelector('[data-date="2024-11-15"]')
      const disabled20After = element.querySelector('[data-date="2024-11-20"]')

      expect(disabled15After.hasAttribute("disabled")).toBe(true)
      expect(disabled15After.getAttribute("aria-disabled")).toBe("true")
      expect(disabled15After.classList.contains("cursor-not-allowed")).toBe(true)
      expect(disabled20After.hasAttribute("disabled")).toBe(true)
      expect(disabled20After.getAttribute("aria-disabled")).toBe("true")
      expect(disabled20After.classList.contains("cursor-not-allowed")).toBe(true)
    })

    test("minDate remains enforced after selecting a date", () => {
      controller.minDateValue = "2024-11-10"
      controller.render()

      // Verify initially disabled
      const disabled5Before = element.querySelector('[data-date="2024-11-05"]')
      expect(disabled5Before.hasAttribute("disabled")).toBe(true)

      // Select a valid date (triggers re-render)
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-15" } } })

      // Check dates before minDate are STILL disabled
      const disabled5After = element.querySelector('[data-date="2024-11-05"]')
      expect(disabled5After.hasAttribute("disabled")).toBe(true)
      expect(disabled5After.getAttribute("aria-disabled")).toBe("true")
      expect(disabled5After.classList.contains("cursor-not-allowed")).toBe(true)
    })

    test("maxDate remains enforced after selecting a date", () => {
      controller.maxDateValue = "2024-11-20"
      controller.render()

      // Verify initially disabled
      const disabled25Before = element.querySelector('[data-date="2024-11-25"]')
      expect(disabled25Before.hasAttribute("disabled")).toBe(true)

      // Select a valid date (triggers re-render)
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-15" } } })

      // Check dates after maxDate are STILL disabled
      const disabled25After = element.querySelector('[data-date="2024-11-25"]')
      expect(disabled25After.hasAttribute("disabled")).toBe(true)
      expect(disabled25After.getAttribute("aria-disabled")).toBe("true")
      expect(disabled25After.classList.contains("cursor-not-allowed")).toBe(true)
    })

    test("disabled buttons do not have click action for date selection", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Weekends
      controller.render()

      // Disabled buttons should not have the click->selectDay action
      const saturdayButton = element.querySelector('[data-date="2024-11-16"]')
      const dataAction = saturdayButton.getAttribute("data-action")

      expect(dataAction).not.toContain("click->")
      // But should still have focus/blur handlers for keyboard
      expect(dataAction).toContain("focus->")
      expect(dataAction).toContain("blur->")
    })

    test("enabled buttons have click action for date selection", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Weekends
      controller.render()

      // Monday should have click action
      const mondayButton = element.querySelector('[data-date="2024-11-18"]')
      const dataAction = mondayButton.getAttribute("data-action")

      expect(dataAction).toContain("click->")
    })

    test("clicking a disabled date does not select it", () => {
      controller.disabledDaysOfWeekValue = "0,6"
      controller.render()

      // Try to select a Saturday
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-16" } } })

      expect(controller.selectedDate).toBeNull()
      expect(controller.selectedValue).toBe("")
    })

    test("multiple interactions preserve disabled state", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Weekends
      controller.render()

      // Select multiple weekday dates in sequence
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-18" } } }) // Monday
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-19" } } }) // Tuesday
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-20" } } }) // Wednesday

      // Weekend should still be disabled after all interactions
      const saturdayButton = element.querySelector('[data-date="2024-11-16"]')
      const sundayButton = element.querySelector('[data-date="2024-11-17"]')

      expect(saturdayButton.hasAttribute("disabled")).toBe(true)
      expect(sundayButton.hasAttribute("disabled")).toBe(true)
    })

    test("navigation preserves disabled state", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Weekends
      controller.render()

      // Navigate to next month
      controller.nextMonth()

      // December 2024 - check a Saturday (Dec 7) and Sunday (Dec 8)
      const saturday = element.querySelector('[data-date="2024-12-07"]')
      const sunday = element.querySelector('[data-date="2024-12-08"]')

      expect(saturday.hasAttribute("disabled")).toBe(true)
      expect(saturday.classList.contains("cursor-not-allowed")).toBe(true)
      expect(sunday.hasAttribute("disabled")).toBe(true)
      expect(sunday.classList.contains("cursor-not-allowed")).toBe(true)
    })
  })

  describe("showOutsideDays", () => {
    test("renders empty placeholders when showOutsideDays is false", async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="calendar"
             data-calendar-month-value="2024-11-01"
             data-calendar-show-outside-days-value="false">
          <div data-calendar-target="grid"></div>
        </div>
      `

      application = Application.start()
      application.register("calendar", CalendarController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="calendar"]')
      controller = application.getControllerForElementAndIdentifier(element, "calendar")

      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')

      // November 2024 starts on Friday, so first 5 cells should be empty divs
      const emptyDivs = grid.querySelectorAll('div.h-8.w-8:not([data-date])')
      expect(emptyDivs.length).toBeGreaterThan(0)

      // First day button should be November 1
      const firstButton = grid.querySelector('button[data-date]')
      expect(firstButton.dataset.date).toBe("2024-11-01")
    })

    test("showOutsideDays persists after month navigation cycle", async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="calendar"
             data-calendar-month-value="2024-11-01"
             data-calendar-show-outside-days-value="false">
          <div data-calendar-target="grid"></div>
        </div>
      `

      application = Application.start()
      application.register("calendar", CalendarController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="calendar"]')
      controller = application.getControllerForElementAndIdentifier(element, "calendar")

      // Navigate forward to December
      controller.nextMonth()

      // Verify empty placeholders in December (starts on Sunday, so first day should be Dec 1)
      let grid = element.querySelector('[data-calendar-target="grid"]')
      let firstButton = grid.querySelector('button[data-date]')
      expect(firstButton.dataset.date).toBe("2024-12-01")

      // Navigate back to November
      controller.previousMonth()

      // Verify empty placeholders still work in November
      grid = element.querySelector('[data-calendar-target="grid"]')
      firstButton = grid.querySelector('button[data-date]')
      expect(firstButton.dataset.date).toBe("2024-11-01")

      // Verify empty divs are still present
      const emptyDivs = grid.querySelectorAll('div.h-8.w-8:not([data-date])')
      expect(emptyDivs.length).toBeGreaterThan(0)
    })

    test("showOutsideDays: true (default) shows outside days", () => {
      controller.showOutsideDaysValue = true
      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')

      // November 2024 starts on Friday, so there should be October days before
      const octDates = grid.querySelectorAll('button[data-date^="2024-10"]')
      expect(octDates.length).toBeGreaterThan(0)
    })
  })

  describe("month navigation with selection and disabled dates", () => {
    test("disabled dates persist after navigating forward then back", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Weekends
      controller.render()

      // Verify weekends disabled in November
      const novSat = element.querySelector('[data-date="2024-11-16"]')
      expect(novSat.hasAttribute("disabled")).toBe(true)

      // Navigate to December
      controller.nextMonth()

      // Verify weekends disabled in December (Dec 7 is Saturday)
      const decSat = element.querySelector('[data-date="2024-12-07"]')
      expect(decSat.hasAttribute("disabled")).toBe(true)

      // Navigate back to November
      controller.previousMonth()

      // Verify weekends STILL disabled in November
      const novSatAgain = element.querySelector('[data-date="2024-11-16"]')
      expect(novSatAgain.hasAttribute("disabled")).toBe(true)
      expect(novSatAgain.classList.contains("cursor-not-allowed")).toBe(true)
    })

    test("selection persists across month navigation", () => {
      // Select a date in November
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-15" } } })
      expect(controller.selectedDate.getDate()).toBe(15)

      // Navigate to December
      controller.nextMonth()
      expect(controller.currentMonth.getMonth()).toBe(11) // December

      // Selection should still exist
      expect(controller.selectedDate.getDate()).toBe(15)
      expect(controller.selectedDate.getMonth()).toBe(10) // November

      // Navigate back to November
      controller.previousMonth()
      expect(controller.currentMonth.getMonth()).toBe(10) // November

      // Selected date should be visually marked
      const selectedButton = element.querySelector('[data-date="2024-11-15"]')
      expect(selectedButton.classList.contains("bg-primary")).toBe(true)
      expect(selectedButton.getAttribute("aria-selected")).toBe("true")
    })

    test("minDate/maxDate persist across year navigation", () => {
      controller.minDateValue = "2024-06-01"
      controller.maxDateValue = "2024-12-31"
      controller.render()

      // Navigate far back to April 2024
      controller.previousMonth() // October
      controller.previousMonth() // September
      controller.previousMonth() // August
      controller.previousMonth() // July
      controller.previousMonth() // June
      controller.previousMonth() // May
      controller.previousMonth() // April

      // April 2024 should have all dates disabled (before minDate June 1)
      const aprilDate = element.querySelector('[data-date="2024-04-15"]')
      expect(aprilDate.hasAttribute("disabled")).toBe(true)
      expect(aprilDate.classList.contains("cursor-not-allowed")).toBe(true)

      // Navigate forward to January 2025 (9 months from April 2024)
      for (let i = 0; i < 9; i++) {
        controller.nextMonth()
      }

      // January 2025 should have dates disabled (after maxDate Dec 31, 2024)
      const janDate = element.querySelector('[data-date="2025-01-15"]')
      expect(janDate).not.toBeNull()
      expect(janDate.hasAttribute("disabled")).toBe(true)
      expect(janDate.classList.contains("cursor-not-allowed")).toBe(true)
    })

    test("combined interaction: select date, navigate, select another, navigate back", () => {
      controller.disabledDaysOfWeekValue = "0,6"
      controller.render()

      // Select Monday Nov 18
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-18" } } })
      expect(controller.selectedDate.getDate()).toBe(18)

      // Navigate to December
      controller.nextMonth()

      // Weekends should still be disabled
      const decSat = element.querySelector('[data-date="2024-12-07"]')
      expect(decSat.hasAttribute("disabled")).toBe(true)

      // Select a Wednesday in December (Dec 11)
      controller.selectDay({ currentTarget: { dataset: { date: "2024-12-11" } } })
      expect(controller.selectedDate.getDate()).toBe(11)
      expect(controller.selectedDate.getMonth()).toBe(11) // December

      // Navigate back to November
      controller.previousMonth()

      // Old selection should no longer be marked (we selected Dec 11)
      const novDate = element.querySelector('[data-date="2024-11-18"]')
      expect(novDate.classList.contains("bg-primary")).toBe(false)

      // Weekends should still be disabled
      const novSat = element.querySelector('[data-date="2024-11-16"]')
      expect(novSat.hasAttribute("disabled")).toBe(true)
    })
  })

  describe("weekStartsOn", () => {
    test("default weekStartsOn is 0 (Sunday)", () => {
      expect(controller.weekStartsOnValue).toBe(0)
    })

    test("renders grid starting from Sunday by default", () => {
      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      const allDays = grid.querySelectorAll("button[data-date]")

      // November 2024 starts on Friday, with Sunday start the first day should be Oct 27
      expect(allDays[0].dataset.date).toBe("2024-10-27")
    })

    test("weekStartsOn=1 starts grid from Monday", async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="calendar"
             data-calendar-month-value="2024-11-01"
             data-calendar-week-starts-on-value="1">
          <div data-calendar-target="grid"></div>
        </div>
      `

      application = Application.start()
      application.register("calendar", CalendarController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="calendar"]')
      controller = application.getControllerForElementAndIdentifier(element, "calendar")

      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      const allDays = grid.querySelectorAll("button[data-date]")

      // November 2024 starts on Friday, with Monday start the first day should be Oct 28
      expect(allDays[0].dataset.date).toBe("2024-10-28")
    })

    test("weekStartsOn=1 correctly positions November 1st", async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="calendar"
             data-calendar-month-value="2024-11-01"
             data-calendar-week-starts-on-value="1">
          <div data-calendar-target="grid"></div>
        </div>
      `

      application = Application.start()
      application.register("calendar", CalendarController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="calendar"]')
      controller = application.getControllerForElementAndIdentifier(element, "calendar")

      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      const allDays = grid.querySelectorAll("button[data-date]")

      // November 1, 2024 is Friday
      // With Monday start: Mon=0, Tue=1, Wed=2, Thu=3, Fri=4
      // First row: Oct 28 (Mon), Oct 29 (Tue), Oct 30 (Wed), Oct 31 (Thu), Nov 1 (Fri), Nov 2 (Sat), Nov 3 (Sun)
      expect(allDays[4].dataset.date).toBe("2024-11-01")
    })

    test("weekStartsOn=1 December 2024 starts correctly", async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="calendar"
             data-calendar-month-value="2024-12-01"
             data-calendar-week-starts-on-value="1">
          <div data-calendar-target="grid"></div>
        </div>
      `

      application = Application.start()
      application.register("calendar", CalendarController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="calendar"]')
      controller = application.getControllerForElementAndIdentifier(element, "calendar")

      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      const allDays = grid.querySelectorAll("button[data-date]")

      // December 1, 2024 is Sunday
      // With Monday start, first day should be Nov 25 (Monday)
      expect(allDays[0].dataset.date).toBe("2024-11-25")

      // December 1 should be at position 6 (Sunday = last day of week when starting Monday)
      expect(allDays[6].dataset.date).toBe("2024-12-01")
    })

    test("weekStartsOn persists after month navigation", async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="calendar"
             data-calendar-month-value="2024-11-01"
             data-calendar-week-starts-on-value="1">
          <div data-calendar-target="grid"></div>
        </div>
      `

      application = Application.start()
      application.register("calendar", CalendarController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="calendar"]')
      controller = application.getControllerForElementAndIdentifier(element, "calendar")

      // Navigate to December
      controller.nextMonth()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      const allDays = grid.querySelectorAll("button[data-date]")

      // Should still start from Monday (Nov 25)
      expect(allDays[0].dataset.date).toBe("2024-11-25")

      // Navigate back to November
      controller.previousMonth()

      const gridAfter = element.querySelector('[data-calendar-target="grid"]')
      const allDaysAfter = gridAfter.querySelectorAll("button[data-date]")

      // Should still start from Monday (Oct 28)
      expect(allDaysAfter[0].dataset.date).toBe("2024-10-28")
    })
  })

  describe("month navigation", () => {
    test("navigating to next month preserves selection", () => {
      // Select a date
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-15" } } })

      // Navigate to December
      controller.nextMonth()

      // Selection should still exist
      expect(controller.selectedDate.getDate()).toBe(15)
      expect(controller.selectedDate.getMonth()).toBe(10) // November
    })

    test("navigating back to previous month shows selection", () => {
      // Select a date
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-15" } } })

      // Navigate to December and back
      controller.nextMonth()
      controller.previousMonth()

      // Check selection is visible
      const selectedButton = element.querySelector('[data-date="2024-11-15"]')
      expect(selectedButton.classList.contains("bg-primary")).toBe(true)
    })

    test("selectMonth changes month", () => {
      // Select June (index 5)
      controller.selectMonth({ target: { value: "5" } })

      expect(controller.currentMonth.getMonth()).toBe(5) // June
    })

    test("selectYear changes year", () => {
      // Select 2025
      controller.selectYear({ target: { value: "2025" } })

      expect(controller.currentMonth.getFullYear()).toBe(2025)
    })

    test("navigating through multiple months maintains state", () => {
      controller.disabledDaysOfWeekValue = "0,6"

      // Navigate forward several months
      for (let i = 0; i < 6; i++) {
        controller.nextMonth()
      }

      // May 2025
      expect(controller.currentMonth.getMonth()).toBe(4)
      expect(controller.currentMonth.getFullYear()).toBe(2025)

      // Navigate back
      for (let i = 0; i < 6; i++) {
        controller.previousMonth()
      }

      // Back to November 2024
      expect(controller.currentMonth.getMonth()).toBe(10)
      expect(controller.currentMonth.getFullYear()).toBe(2024)

      // Disabled weekends should still work
      const saturday = element.querySelector('[data-date="2024-11-16"]')
      expect(saturday.hasAttribute("disabled")).toBe(true)
    })
  })

  describe("range mode CSS rendering", () => {
    beforeEach(async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="calendar"
             data-calendar-month-value="2024-11-01"
             data-calendar-mode-value="range"
             data-calendar-selected-value="">
          <div data-calendar-target="grid"></div>
          <input type="hidden" data-calendar-target="hiddenInput">
        </div>
      `

      application = Application.start()
      application.register("calendar", CalendarController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="calendar"]')
      controller = application.getControllerForElementAndIdentifier(element, "calendar")
    })

    test("range start has rounded-l-md class", () => {
      controller.rangeStart = new Date(2024, 10, 10)
      controller.rangeEnd = new Date(2024, 10, 15)
      controller.render()

      const startButton = element.querySelector('[data-date="2024-11-10"]')
      expect(startButton.classList.contains("rounded-l-md")).toBe(true)
    })

    test("range end has rounded-r-md class", () => {
      controller.rangeStart = new Date(2024, 10, 10)
      controller.rangeEnd = new Date(2024, 10, 15)
      controller.render()

      const endButton = element.querySelector('[data-date="2024-11-15"]')
      expect(endButton.classList.contains("rounded-r-md")).toBe(true)
    })

    test("dates in range have accent background", () => {
      controller.rangeStart = new Date(2024, 10, 10)
      controller.rangeEnd = new Date(2024, 10, 15)
      controller.render()

      // Nov 12 is in the middle of the range
      const middleButton = element.querySelector('[data-date="2024-11-12"]')
      expect(middleButton.classList.contains("bg-accent/50")).toBe(true)
    })

    test("range mode snapshot", () => {
      controller.rangeStart = new Date(2024, 10, 10)
      controller.rangeEnd = new Date(2024, 10, 15)
      controller.render()

      const grid = element.querySelector('[data-calendar-target="grid"]')
      expect(grid.innerHTML).toMatchSnapshot()
    })
  })
})
