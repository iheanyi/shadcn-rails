import { Application } from "@hotwired/stimulus"
import DatePickerController from "../../app/assets/javascripts/shadcn/controllers/date_picker_controller.ts"

describe("DatePickerController", () => {
  let application
  let element
  let controller

  const datePickerHTML = `
    <div data-controller="date-picker"
         data-date-picker-open-value="false"
         data-date-picker-month-value="2024-11-01"
         data-date-picker-selected-value=""
         data-date-picker-format-value="medium"
         data-date-picker-placeholder-value="Pick a date">
      <button data-date-picker-target="trigger" type="button">
        <span data-date-picker-target="displayValue" class="text-muted-foreground">Pick a date</span>
      </button>
      <div data-date-picker-target="content" style="display: none;">
        <div data-date-picker-target="monthYear"></div>
        <div data-date-picker-target="grid"></div>
      </div>
      <input type="hidden" data-date-picker-target="hiddenInput">
    </div>
  `

  beforeEach(async () => {
    application = Application.start()
    application.register("date-picker", DatePickerController)
    document.body.innerHTML = datePickerHTML

    await new Promise(resolve => requestAnimationFrame(resolve))

    element = document.querySelector('[data-controller="date-picker"]')
    controller = application.getControllerForElementAndIdentifier(element, "date-picker")
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
  })

  describe("formatDateString", () => {
    test("formats date as YYYY-MM-DD", () => {
      const date = new Date(2024, 10, 26)
      expect(controller.formatDateString(date)).toBe("2024-11-26")
    })

    test("pads single digit months and days", () => {
      const date = new Date(2024, 0, 5)
      expect(controller.formatDateString(date)).toBe("2024-01-05")
    })

    test("returns empty string for null", () => {
      expect(controller.formatDateString(null)).toBe("")
    })
  })

  describe("formatDate", () => {
    test("formats with medium style by default", () => {
      const date = new Date(2024, 10, 26)
      const formatted = controller.formatDate(date)
      // "November 26, 2024"
      expect(formatted).toContain("November")
      expect(formatted).toContain("26")
      expect(formatted).toContain("2024")
    })

    test("formats with short style", () => {
      controller.formatValue = "short"
      const date = new Date(2024, 10, 26)
      const formatted = controller.formatDate(date)
      // "11/26/2024"
      expect(formatted).toBe("11/26/2024")
    })

    test("formats with long style", () => {
      controller.formatValue = "long"
      const date = new Date(2024, 10, 26)
      const formatted = controller.formatDate(date)
      // "Tuesday, November 26, 2024"
      expect(formatted).toContain("Tuesday")
      expect(formatted).toContain("November")
      expect(formatted).toContain("26")
      expect(formatted).toContain("2024")
    })

    test("formats with iso style", () => {
      controller.formatValue = "iso"
      const date = new Date(2024, 10, 26)
      const formatted = controller.formatDate(date)
      expect(formatted).toBe("2024-11-26")
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

  describe("toggle", () => {
    test("opens when closed", () => {
      expect(controller.openValue).toBe(false)
      controller.toggle()
      expect(controller.openValue).toBe(true)
    })

    test("closes when open", () => {
      controller.openValue = true
      controller.toggle()
      expect(controller.openValue).toBe(false)
    })
  })

  describe("open", () => {
    test("sets openValue to true", () => {
      controller.open()
      expect(controller.openValue).toBe(true)
    })
  })

  describe("close", () => {
    test("sets openValue to false", () => {
      controller.openValue = true
      controller.close()
      expect(controller.openValue).toBe(false)
    })
  })

  describe("openValueChanged", () => {
    test("shows content when open", () => {
      controller.openValue = true
      controller.openValueChanged()

      const content = element.querySelector('[data-date-picker-target="content"]')
      expect(content.style.display).toBe("block")
    })

    test("hides content when closed", () => {
      controller.openValue = false
      controller.openValueChanged()

      const content = element.querySelector('[data-date-picker-target="content"]')
      expect(content.style.display).toBe("none")
    })

    test("sets aria-expanded on trigger", () => {
      controller.openValue = true
      controller.openValueChanged()

      const trigger = element.querySelector('[data-date-picker-target="trigger"]')
      expect(trigger.getAttribute("aria-expanded")).toBe("true")

      controller.openValue = false
      controller.openValueChanged()
      expect(trigger.getAttribute("aria-expanded")).toBe("false")
    })
  })

  describe("previousMonth", () => {
    test("moves to the previous month", () => {
      controller.previousMonth()
      expect(controller.currentMonth.getMonth()).toBe(9) // October
    })
  })

  describe("nextMonth", () => {
    test("moves to the next month", () => {
      controller.nextMonth()
      expect(controller.currentMonth.getMonth()).toBe(11) // December
    })
  })

  describe("selectDay", () => {
    test("selects the clicked date", () => {
      const mockEvent = {
        currentTarget: {
          dataset: { date: "2024-11-15" }
        }
      }

      controller.selectDay(mockEvent)

      expect(controller.selectedDate).not.toBeNull()
      expect(controller.selectedDate.getDate()).toBe(15)
      expect(controller.selectedDate.getMonth()).toBe(10)
      expect(controller.selectedDate.getFullYear()).toBe(2024)
    })

    test("updates the hidden input value", () => {
      const mockEvent = {
        currentTarget: {
          dataset: { date: "2024-11-20" }
        }
      }

      controller.selectDay(mockEvent)

      const hiddenInput = element.querySelector('[data-date-picker-target="hiddenInput"]')
      expect(hiddenInput.value).toBe("2024-11-20")
    })

    test("updates the display value", () => {
      const mockEvent = {
        currentTarget: {
          dataset: { date: "2024-11-15" }
        }
      }

      controller.selectDay(mockEvent)

      const displayValue = element.querySelector('[data-date-picker-target="displayValue"]')
      expect(displayValue.textContent).toContain("November")
      expect(displayValue.textContent).toContain("15")
      expect(displayValue.classList.contains("text-muted-foreground")).toBe(false)
    })

    test("closes the popover after selection", () => {
      controller.openValue = true

      const mockEvent = {
        currentTarget: {
          dataset: { date: "2024-11-15" }
        }
      }

      controller.selectDay(mockEvent)

      expect(controller.openValue).toBe(false)
    })

    test("dispatches select event with date details", () => {
      let eventDetail = null
      element.addEventListener("date-picker:select", (e) => {
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

      const monthYearDisplay = element.querySelector('[data-date-picker-target="monthYear"]')
      expect(monthYearDisplay.textContent).toBe("November 2024")
    })

    test("renders day buttons in grid", () => {
      controller.render()

      const grid = element.querySelector('[data-date-picker-target="grid"]')
      const dayButtons = grid.querySelectorAll('button[data-date]')
      expect(dayButtons.length).toBeGreaterThanOrEqual(28)
      expect(dayButtons.length).toBeLessThanOrEqual(42)
    })
  })

  describe("closeOnClickOutside", () => {
    test("closes when clicking outside the component", () => {
      controller.openValue = true

      // Create an outside element
      const outsideElement = document.createElement("div")
      document.body.appendChild(outsideElement)

      const event = {
        target: outsideElement
      }

      controller.closeOnClickOutside(event)

      expect(controller.openValue).toBe(false)
    })

    test("does not close when clicking inside the component", () => {
      controller.openValue = true

      const event = {
        target: element.querySelector('[data-date-picker-target="content"]')
      }

      controller.closeOnClickOutside(event)

      expect(controller.openValue).toBe(true)
    })

    test("does nothing when already closed", () => {
      controller.openValue = false

      const outsideElement = document.createElement("div")
      document.body.appendChild(outsideElement)

      const event = {
        target: outsideElement
      }

      // Should not throw or change anything
      controller.closeOnClickOutside(event)

      expect(controller.openValue).toBe(false)
    })
  })

  describe("timezone handling", () => {
    test("selecting a date preserves the correct day regardless of timezone", () => {
      const mockEvent = {
        currentTarget: {
          dataset: { date: "2024-11-15" }
        }
      }

      controller.selectDay(mockEvent)

      expect(controller.selectedDate.getDate()).toBe(15)
      expect(controller.selectedDate.getMonth()).toBe(10)
      expect(controller.selectedValue).toBe("2024-11-15")
    })

    test("initializing with a selected value preserves the correct day", async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="date-picker"
             data-date-picker-month-value="2024-11-01"
             data-date-picker-selected-value="2024-11-26">
          <div data-date-picker-target="grid"></div>
        </div>
      `

      application = Application.start()
      application.register("date-picker", DatePickerController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      const newElement = document.querySelector('[data-controller="date-picker"]')
      const newController = application.getControllerForElementAndIdentifier(newElement, "date-picker")

      expect(newController.selectedDate.getDate()).toBe(26)
      expect(newController.selectedDate.getMonth()).toBe(10)
    })

    test("parseLocalDate avoids UTC timezone shift for DST dates", () => {
      const dstDates = [
        "2024-03-10", // DST start (US)
        "2024-11-03", // DST end (US)
      ]

      dstDates.forEach(dateStr => {
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

      expect(controller.currentMonth.getMonth()).toBe(5)
      expect(controller.currentMonth.getFullYear()).toBe(2024)
    })
  })

  describe("selectedValueChanged", () => {
    test("updates selectedDate when value changes", () => {
      controller.selectedValue = "2024-07-20"
      controller.selectedValueChanged()

      expect(controller.selectedDate.getDate()).toBe(20)
      expect(controller.selectedDate.getMonth()).toBe(6)
    })
  })

  describe("MONTHS constant", () => {
    test("contains all 12 months in order", () => {
      expect(DatePickerController.MONTHS).toEqual([
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
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

  describe("disabled dates in DatePicker", () => {
    test("clicking a disabled date does not select it", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Weekends

      // Try to select a Saturday
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-16" } } })

      expect(controller.selectedDate).toBeNull()
    })

    test("disabled dates have correct CSS after render", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Weekends
      controller.render()

      const grid = element.querySelector('[data-date-picker-target="grid"]')
      const saturdayButton = grid.querySelector('[data-date="2024-11-16"]')

      expect(saturdayButton.classList.contains("cursor-not-allowed")).toBe(true)
      expect(saturdayButton.hasAttribute("disabled")).toBe(true)
      expect(saturdayButton.getAttribute("aria-disabled")).toBe("true")
    })

    test("disabled dates persist after selecting a date", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Weekends
      controller.render()

      // Select a weekday
      controller.selectDay({ currentTarget: { dataset: { date: "2024-11-18" } } })

      // Weekends should still be disabled
      const grid = element.querySelector('[data-date-picker-target="grid"]')
      const saturdayButton = grid.querySelector('[data-date="2024-11-16"]')

      expect(saturdayButton.hasAttribute("disabled")).toBe(true)
      expect(saturdayButton.classList.contains("cursor-not-allowed")).toBe(true)
    })
  })

  describe("showOutsideDays in DatePicker", () => {
    test("renders empty placeholders when showOutsideDays is false", async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="date-picker"
             data-date-picker-month-value="2024-11-01"
             data-date-picker-show-outside-days-value="false">
          <div data-date-picker-target="grid"></div>
        </div>
      `

      application = Application.start()
      application.register("date-picker", DatePickerController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="date-picker"]')
      controller = application.getControllerForElementAndIdentifier(element, "date-picker")

      controller.render()

      const grid = element.querySelector('[data-date-picker-target="grid"]')

      // First button should be November 1 (October days replaced with empty divs)
      const firstButton = grid.querySelector('button[data-date]')
      expect(firstButton.dataset.date).toBe("2024-11-01")

      // Empty divs should exist for October days
      const emptyDivs = grid.querySelectorAll('div.h-8.w-8:not([data-date])')
      expect(emptyDivs.length).toBeGreaterThan(0)
    })

    test("showOutsideDays persists after month navigation", async () => {
      application.stop()
      document.body.innerHTML = ""

      document.body.innerHTML = `
        <div data-controller="date-picker"
             data-date-picker-month-value="2024-11-01"
             data-date-picker-show-outside-days-value="false">
          <div data-date-picker-target="grid"></div>
        </div>
      `

      application = Application.start()
      application.register("date-picker", DatePickerController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="date-picker"]')
      controller = application.getControllerForElementAndIdentifier(element, "date-picker")

      // Navigate to December
      controller.nextMonth()

      // First button should be December 1
      let grid = element.querySelector('[data-date-picker-target="grid"]')
      let firstButton = grid.querySelector('button[data-date]')
      expect(firstButton.dataset.date).toBe("2024-12-01")

      // Navigate back
      controller.previousMonth()

      // First button should still be November 1
      grid = element.querySelector('[data-date-picker-target="grid"]')
      firstButton = grid.querySelector('button[data-date]')
      expect(firstButton.dataset.date).toBe("2024-11-01")
    })
  })

  describe("month navigation with disabled dates", () => {
    test("disabled days of week persist across month navigation", () => {
      controller.disabledDaysOfWeekValue = "0,6" // Weekends
      controller.render()

      // Navigate to December
      controller.nextMonth()

      // December 7 is a Saturday
      const grid = element.querySelector('[data-date-picker-target="grid"]')
      const decSat = grid.querySelector('[data-date="2024-12-07"]')
      expect(decSat.hasAttribute("disabled")).toBe(true)

      // Navigate back to November
      controller.previousMonth()

      // November 16 is still Saturday and should be disabled
      const novSat = element.querySelector('[data-date="2024-11-16"]')
      expect(novSat.hasAttribute("disabled")).toBe(true)
    })

    test("minDate/maxDate constraints persist across navigation", () => {
      controller.minDateValue = "2024-11-10"
      controller.maxDateValue = "2024-12-20"
      controller.render()

      // November 5 should be disabled (before minDate)
      let date5 = element.querySelector('[data-date="2024-11-05"]')
      expect(date5.hasAttribute("disabled")).toBe(true)

      // Navigate to December
      controller.nextMonth()

      // December 25 should be disabled (after maxDate)
      const date25 = element.querySelector('[data-date="2024-12-25"]')
      expect(date25.hasAttribute("disabled")).toBe(true)

      // Navigate back to November
      controller.previousMonth()

      // November 5 should still be disabled
      date5 = element.querySelector('[data-date="2024-11-05"]')
      expect(date5.hasAttribute("disabled")).toBe(true)
    })
  })
})
