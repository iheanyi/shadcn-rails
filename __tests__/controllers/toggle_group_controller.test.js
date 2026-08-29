import { Application } from "@hotwired/stimulus"
import ToggleGroupController from "../../app/assets/javascripts/shadcn/controllers/toggle_group_controller.ts"
import { setupController, cleanupController, click, wait, nextFrame, keydown, waitForEvent } from '../helpers/stimulus-test-helper.js'

describe("ToggleGroupController", () => {
  let application
  let element
  let controller

  afterEach(() => {
    cleanupController(application)
  })

  describe("single mode", () => {
    const singleModeHTML = `
      <div data-controller="shadcn--toggle-group"
           data-shadcn--toggle-group-type-value="single">
        <button data-shadcn--toggle-group-target="item"
                data-value="bold"
                data-action="click->shadcn--toggle-group#toggle">Bold</button>
        <button data-shadcn--toggle-group-target="item"
                data-value="italic"
                data-action="click->shadcn--toggle-group#toggle">Italic</button>
        <button data-shadcn--toggle-group-target="item"
                data-value="underline"
                data-action="click->shadcn--toggle-group#toggle">Underline</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ToggleGroupController, singleModeHTML, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with type 'single' by default", () => {
      expect(controller.typeValue).toBe("single")
    })

    test("initializes with empty value", () => {
      expect(controller.valueValue).toBe("")
    })

    test("initializes all items with data-state='off'", () => {
      controller.itemTargets.forEach(item => {
        expect(item.getAttribute("data-state")).toBe("off")
        expect(item.getAttribute("aria-pressed")).toBe("false")
      })
    })

    test("selects an item when clicked", async () => {
      const boldButton = controller.itemTargets[0]
      click(boldButton)
      await nextFrame()

      expect(controller.valueValue).toBe("bold")
      expect(boldButton.getAttribute("data-state")).toBe("on")
      expect(boldButton.getAttribute("aria-pressed")).toBe("true")
    })

    test("deselects other items when selecting new item", async () => {
      const boldButton = controller.itemTargets[0]
      const italicButton = controller.itemTargets[1]

      // Select bold
      click(boldButton)
      await nextFrame()
      expect(controller.valueValue).toBe("bold")
      expect(boldButton.getAttribute("data-state")).toBe("on")

      // Select italic - bold should be deselected
      click(italicButton)
      await nextFrame()
      expect(controller.valueValue).toBe("italic")
      expect(italicButton.getAttribute("data-state")).toBe("on")
      expect(boldButton.getAttribute("data-state")).toBe("off")
      expect(boldButton.getAttribute("aria-pressed")).toBe("false")
    })

    test("toggles off when clicking selected item", async () => {
      const boldButton = controller.itemTargets[0]

      // Select bold
      click(boldButton)
      await nextFrame()
      expect(controller.valueValue).toBe("bold")
      expect(boldButton.getAttribute("data-state")).toBe("on")

      // Click again to deselect
      click(boldButton)
      await nextFrame()
      expect(controller.valueValue).toBe("")
      expect(boldButton.getAttribute("data-state")).toBe("off")
      expect(boldButton.getAttribute("aria-pressed")).toBe("false")
    })

    test("dispatches change event when selection changes", async () => {
      const boldButton = controller.itemTargets[0]
      let eventDetail = null

      element.addEventListener("shadcn--toggle-group:change", (e) => {
        eventDetail = e.detail
      })

      click(boldButton)
      await nextFrame()

      expect(eventDetail).not.toBeNull()
      expect(eventDetail.value).toEqual(["bold"])
    })

    test("dispatches change event on deselection", async () => {
      const boldButton = controller.itemTargets[0]
      let changeCount = 0
      let lastEventDetail = null

      element.addEventListener("shadcn--toggle-group:change", (e) => {
        changeCount++
        lastEventDetail = e.detail
      })

      // Select
      click(boldButton)
      await nextFrame()
      expect(changeCount).toBe(1)
      expect(lastEventDetail.value).toEqual(["bold"])

      // Deselect
      click(boldButton)
      await nextFrame()
      expect(changeCount).toBe(2)
      expect(lastEventDetail.value).toEqual([])
    })

    test("only one item can be selected at a time", async () => {
      const boldButton = controller.itemTargets[0]
      const italicButton = controller.itemTargets[1]
      const underlineButton = controller.itemTargets[2]

      click(boldButton)
      await nextFrame()
      expect(controller.getValues()).toEqual(["bold"])

      click(italicButton)
      await nextFrame()
      expect(controller.getValues()).toEqual(["italic"])

      click(underlineButton)
      await nextFrame()
      expect(controller.getValues()).toEqual(["underline"])

      // Verify only underline is on
      expect(boldButton.getAttribute("data-state")).toBe("off")
      expect(italicButton.getAttribute("data-state")).toBe("off")
      expect(underlineButton.getAttribute("data-state")).toBe("on")
    })
  })

  describe("multiple mode", () => {
    const multipleModeHTML = `
      <div data-controller="shadcn--toggle-group"
           data-shadcn--toggle-group-type-value="multiple">
        <button data-shadcn--toggle-group-target="item"
                data-value="bold"
                data-action="click->shadcn--toggle-group#toggle">Bold</button>
        <button data-shadcn--toggle-group-target="item"
                data-value="italic"
                data-action="click->shadcn--toggle-group#toggle">Italic</button>
        <button data-shadcn--toggle-group-target="item"
                data-value="underline"
                data-action="click->shadcn--toggle-group#toggle">Underline</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ToggleGroupController, multipleModeHTML, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with type 'multiple'", () => {
      expect(controller.typeValue).toBe("multiple")
    })

    test("can select multiple items", async () => {
      const boldButton = controller.itemTargets[0]
      const italicButton = controller.itemTargets[1]

      click(boldButton)
      await nextFrame()
      expect(controller.valueValue).toBe("bold")
      expect(boldButton.getAttribute("data-state")).toBe("on")

      click(italicButton)
      await nextFrame()
      expect(controller.valueValue).toBe("bold,italic")
      expect(boldButton.getAttribute("data-state")).toBe("on")
      expect(italicButton.getAttribute("data-state")).toBe("on")
    })

    test("can select all items", async () => {
      const boldButton = controller.itemTargets[0]
      const italicButton = controller.itemTargets[1]
      const underlineButton = controller.itemTargets[2]

      click(boldButton)
      await nextFrame()
      click(italicButton)
      await nextFrame()
      click(underlineButton)
      await nextFrame()

      expect(controller.valueValue).toBe("bold,italic,underline")
      expect(controller.getValues()).toEqual(["bold", "italic", "underline"])

      // All should be on
      controller.itemTargets.forEach(item => {
        expect(item.getAttribute("data-state")).toBe("on")
        expect(item.getAttribute("aria-pressed")).toBe("true")
      })
    })

    test("can deselect individual items", async () => {
      const boldButton = controller.itemTargets[0]
      const italicButton = controller.itemTargets[1]

      // Select both
      click(boldButton)
      await nextFrame()
      click(italicButton)
      await nextFrame()
      expect(controller.valueValue).toBe("bold,italic")

      // Deselect bold
      click(boldButton)
      await nextFrame()
      expect(controller.valueValue).toBe("italic")
      expect(boldButton.getAttribute("data-state")).toBe("off")
      expect(italicButton.getAttribute("data-state")).toBe("on")
    })

    test("maintains order when toggling items", async () => {
      const boldButton = controller.itemTargets[0]
      const italicButton = controller.itemTargets[1]
      const underlineButton = controller.itemTargets[2]

      // Select in specific order: italic, bold, underline
      click(italicButton)
      await nextFrame()
      click(boldButton)
      await nextFrame()
      click(underlineButton)
      await nextFrame()

      // Should maintain selection order
      expect(controller.valueValue).toBe("italic,bold,underline")
    })

    test("removes item from middle of selection", async () => {
      const boldButton = controller.itemTargets[0]
      const italicButton = controller.itemTargets[1]
      const underlineButton = controller.itemTargets[2]

      // Select all three
      click(boldButton)
      await nextFrame()
      click(italicButton)
      await nextFrame()
      click(underlineButton)
      await nextFrame()
      expect(controller.valueValue).toBe("bold,italic,underline")

      // Deselect middle item
      click(italicButton)
      await nextFrame()
      expect(controller.valueValue).toBe("bold,underline")
    })

    test("handles deselecting all items", async () => {
      const boldButton = controller.itemTargets[0]
      const italicButton = controller.itemTargets[1]

      // Select two items
      click(boldButton)
      await nextFrame()
      click(italicButton)
      await nextFrame()
      expect(controller.valueValue).toBe("bold,italic")

      // Deselect both
      click(boldButton)
      await nextFrame()
      click(italicButton)
      await nextFrame()

      expect(controller.valueValue).toBe("")
      expect(controller.getValues()).toEqual([])
      controller.itemTargets.forEach(item => {
        expect(item.getAttribute("data-state")).toBe("off")
      })
    })

    test("dispatches change event with array of selected values", async () => {
      const boldButton = controller.itemTargets[0]
      const italicButton = controller.itemTargets[1]
      let eventDetail = null

      element.addEventListener("shadcn--toggle-group:change", (e) => {
        eventDetail = e.detail
      })

      click(boldButton)
      await nextFrame()
      expect(eventDetail.value).toEqual(["bold"])

      click(italicButton)
      await nextFrame()
      expect(eventDetail.value).toEqual(["bold", "italic"])
    })

    test("comma-separated values are parsed correctly", async () => {
      // Manually set value
      controller.valueValue = "bold,italic,underline"
      await nextFrame()

      expect(controller.getValues()).toEqual(["bold", "italic", "underline"])

      // All items should be marked as on
      controller.itemTargets.forEach(item => {
        expect(item.getAttribute("data-state")).toBe("on")
      })
    })
  })

  describe("value initialization", () => {
    test("initializes with pre-selected value in single mode", async () => {
      const html = `
        <div data-controller="shadcn--toggle-group"
             data-shadcn--toggle-group-type-value="single"
             data-shadcn--toggle-group-value-value="italic">
          <button data-shadcn--toggle-group-target="item" data-value="bold">Bold</button>
          <button data-shadcn--toggle-group-target="item" data-value="italic">Italic</button>
        </div>
      `

      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller

      expect(controller.valueValue).toBe("italic")
      const italicButton = controller.itemTargets[1]
      expect(italicButton.getAttribute("data-state")).toBe("on")
      expect(italicButton.getAttribute("aria-pressed")).toBe("true")
    })

    test("initializes with pre-selected values in multiple mode", async () => {
      const html = `
        <div data-controller="shadcn--toggle-group"
             data-shadcn--toggle-group-type-value="multiple"
             data-shadcn--toggle-group-value-value="bold,underline">
          <button data-shadcn--toggle-group-target="item" data-value="bold">Bold</button>
          <button data-shadcn--toggle-group-target="item" data-value="italic">Italic</button>
          <button data-shadcn--toggle-group-target="item" data-value="underline">Underline</button>
        </div>
      `

      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller

      expect(controller.valueValue).toBe("bold,underline")
      expect(controller.getValues()).toEqual(["bold", "underline"])

      const boldButton = controller.itemTargets[0]
      const italicButton = controller.itemTargets[1]
      const underlineButton = controller.itemTargets[2]

      expect(boldButton.getAttribute("data-state")).toBe("on")
      expect(italicButton.getAttribute("data-state")).toBe("off")
      expect(underlineButton.getAttribute("data-state")).toBe("on")
    })
  })

  describe("hidden input synchronization", () => {
    test("updates hidden input value in single mode", async () => {
      const html = `
        <div data-controller="shadcn--toggle-group"
             data-shadcn--toggle-group-type-value="single">
          <button data-shadcn--toggle-group-target="item" data-value="bold"
                  data-action="click->shadcn--toggle-group#toggle">Bold</button>
          <input type="hidden" data-shadcn--toggle-group-target="input" name="format">
        </div>
      `

      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller

      const input = element.querySelector('input[type="hidden"]')
      expect(input.value).toBe("")

      const boldButton = controller.itemTargets[0]
      click(boldButton)
      await nextFrame()

      expect(input.value).toBe("bold")
    })

    test("updates hidden input value in multiple mode", async () => {
      const html = `
        <div data-controller="shadcn--toggle-group"
             data-shadcn--toggle-group-type-value="multiple">
          <button data-shadcn--toggle-group-target="item" data-value="bold"
                  data-action="click->shadcn--toggle-group#toggle">Bold</button>
          <button data-shadcn--toggle-group-target="item" data-value="italic"
                  data-action="click->shadcn--toggle-group#toggle">Italic</button>
          <input type="hidden" data-shadcn--toggle-group-target="input" name="formats">
        </div>
      `

      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller

      const input = element.querySelector('input[type="hidden"]')
      const boldButton = controller.itemTargets[0]
      const italicButton = controller.itemTargets[1]

      click(boldButton)
      await nextFrame()
      expect(input.value).toBe("bold")

      click(italicButton)
      await nextFrame()
      expect(input.value).toBe("bold,italic")
    })

    test("initializes hidden input with pre-selected value", async () => {
      const html = `
        <div data-controller="shadcn--toggle-group"
             data-shadcn--toggle-group-type-value="single"
             data-shadcn--toggle-group-value-value="bold">
          <button data-shadcn--toggle-group-target="item" data-value="bold">Bold</button>
          <input type="hidden" data-shadcn--toggle-group-target="input">
        </div>
      `

      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller

      const input = element.querySelector('input[type="hidden"]')
      expect(input.value).toBe("bold")
    })
  })

  describe("valueValueChanged callback", () => {
    const html = `
      <div data-controller="shadcn--toggle-group"
           data-shadcn--toggle-group-type-value="single">
        <button data-shadcn--toggle-group-target="item" data-value="bold">Bold</button>
        <button data-shadcn--toggle-group-target="item" data-value="italic">Italic</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("updates item states when value changes programmatically", async () => {
      controller.valueValue = "bold"
      await nextFrame()

      const boldButton = controller.itemTargets[0]
      expect(boldButton.getAttribute("data-state")).toBe("on")
      expect(boldButton.getAttribute("aria-pressed")).toBe("true")
    })

    test("updates states when value changes from external source", async () => {
      // Simulate external value change
      controller.valueValue = "italic"
      await nextFrame()

      const italicButton = controller.itemTargets[1]
      expect(italicButton.getAttribute("data-state")).toBe("on")

      const boldButton = controller.itemTargets[0]
      expect(boldButton.getAttribute("data-state")).toBe("off")
    })
  })

  describe("edge cases and error handling", () => {
    const html = `
      <div data-controller="shadcn--toggle-group"
           data-shadcn--toggle-group-type-value="single">
        <button data-shadcn--toggle-group-target="item" data-value="bold">Bold</button>
        <button data-shadcn--toggle-group-target="item" data-value="italic">Italic</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles empty value gracefully", async () => {
      controller.valueValue = ""
      await nextFrame()

      expect(controller.getValues()).toEqual([])
      controller.itemTargets.forEach(item => {
        expect(item.getAttribute("data-state")).toBe("off")
      })
    })

    test("handles value with only commas", async () => {
      controller.valueValue = ",,,"
      await nextFrame()

      // Should filter out empty strings
      expect(controller.getValues()).toEqual([])
    })

    test("handles value with trailing comma", async () => {
      controller.valueValue = "bold,"
      await nextFrame()

      expect(controller.getValues()).toEqual(["bold"])
      const boldButton = controller.itemTargets[0]
      expect(boldButton.getAttribute("data-state")).toBe("on")
    })

    test("handles value with leading comma", async () => {
      controller.valueValue = ",bold"
      await nextFrame()

      expect(controller.getValues()).toEqual(["bold"])
      const boldButton = controller.itemTargets[0]
      expect(boldButton.getAttribute("data-state")).toBe("on")
    })

    test("handles non-existent value gracefully", async () => {
      controller.valueValue = "strikethrough"
      await nextFrame()

      // Should not error, just no items will be marked as on
      controller.itemTargets.forEach(item => {
        expect(item.getAttribute("data-state")).toBe("off")
      })
    })

    test("handles multiple commas between values", async () => {
      controller.typeValue = "multiple"
      controller.valueValue = "bold,,,italic"
      await nextFrame()

      expect(controller.getValues()).toEqual(["bold", "italic"])
    })
  })

  describe("connect lifecycle", () => {
    test("updates states on connect", async () => {
      const html = `
        <div data-controller="shadcn--toggle-group"
             data-shadcn--toggle-group-type-value="single"
             data-shadcn--toggle-group-value-value="bold">
          <button data-shadcn--toggle-group-target="item" data-value="bold">Bold</button>
          <button data-shadcn--toggle-group-target="item" data-value="italic">Italic</button>
        </div>
      `

      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller

      // After connect, states should be updated
      const boldButton = controller.itemTargets[0]
      expect(boldButton.getAttribute("data-state")).toBe("on")
      expect(boldButton.getAttribute("aria-pressed")).toBe("true")
    })

    test("initializes all aria-pressed attributes on connect", async () => {
      const html = `
        <div data-controller="shadcn--toggle-group">
          <button data-shadcn--toggle-group-target="item" data-value="a">A</button>
          <button data-shadcn--toggle-group-target="item" data-value="b">B</button>
          <button data-shadcn--toggle-group-target="item" data-value="c">C</button>
        </div>
      `

      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller

      controller.itemTargets.forEach(item => {
        expect(item.hasAttribute("aria-pressed")).toBe(true)
        expect(item.hasAttribute("data-state")).toBe(true)
      })
    })
  })

  describe("type safety and filtering", () => {
    const html = `
      <div data-controller="shadcn--toggle-group"
           data-shadcn--toggle-group-type-value="multiple">
        <button data-shadcn--toggle-group-target="item" data-value="a">A</button>
        <button data-shadcn--toggle-group-target="item" data-value="b">B</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("getValues filters out empty strings", () => {
      controller.valueValue = "a,,b,,"
      expect(controller.getValues()).toEqual(["a", "b"])
    })

    test("getValues handles whitespace-only values", () => {
      controller.valueValue = "a, ,b"
      // Note: This will include the space as a value
      // If trimming is desired, the controller would need to implement it
      const values = controller.getValues()
      expect(values.length).toBe(3)
      expect(values).toEqual(["a", " ", "b"])
    })
  })

  describe("rapid toggling", () => {
    const html = `
      <div data-controller="shadcn--toggle-group"
           data-shadcn--toggle-group-type-value="single">
        <button data-shadcn--toggle-group-target="item" data-value="a"
                data-action="click->shadcn--toggle-group#toggle">A</button>
        <button data-shadcn--toggle-group-target="item" data-value="b"
                data-action="click->shadcn--toggle-group#toggle">B</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles rapid clicks correctly", async () => {
      const buttonA = controller.itemTargets[0]
      const buttonB = controller.itemTargets[1]

      // Rapid fire clicks
      click(buttonA)
      click(buttonB)
      click(buttonA)
      await nextFrame()

      // Final state should be 'a'
      expect(controller.valueValue).toBe("a")
      expect(buttonA.getAttribute("data-state")).toBe("on")
      expect(buttonB.getAttribute("data-state")).toBe("off")
    })

    test("handles rapid toggle on/off in single mode", async () => {
      const buttonA = controller.itemTargets[0]

      click(buttonA) // on
      click(buttonA) // off
      click(buttonA) // on
      click(buttonA) // off
      await nextFrame()

      expect(controller.valueValue).toBe("")
      expect(buttonA.getAttribute("data-state")).toBe("off")
    })

    test("handles rapid multiple selections in multiple mode", async () => {
      controller.typeValue = "multiple"
      const buttonA = controller.itemTargets[0]
      const buttonB = controller.itemTargets[1]

      click(buttonA)
      click(buttonB)
      click(buttonA) // deselect
      click(buttonA) // reselect
      await nextFrame()

      expect(controller.valueValue).toBe("b,a")
    })
  })

  describe("event detail validation", () => {
    const html = `
      <div data-controller="shadcn--toggle-group"
           data-shadcn--toggle-group-type-value="multiple">
        <button data-shadcn--toggle-group-target="item" data-value="x"
                data-action="click->shadcn--toggle-group#toggle">X</button>
        <button data-shadcn--toggle-group-target="item" data-value="y"
                data-action="click->shadcn--toggle-group#toggle">Y</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("change event detail contains array of values", async () => {
      let receivedDetail = null
      element.addEventListener("shadcn--toggle-group:change", (e) => {
        receivedDetail = e.detail
      })

      const buttonX = controller.itemTargets[0]
      click(buttonX)
      await nextFrame()

      expect(receivedDetail).toBeTruthy()
      expect(receivedDetail.value).toBeInstanceOf(Array)
      expect(receivedDetail.value).toEqual(["x"])
    })

    test("change event bubbles", async () => {
      let eventCaught = false
      document.body.addEventListener("shadcn--toggle-group:change", () => {
        eventCaught = true
      })

      const buttonX = controller.itemTargets[0]
      click(buttonX)
      await nextFrame()

      expect(eventCaught).toBe(true)
    })
  })

  describe("type switching (edge case)", () => {
    const html = `
      <div data-controller="shadcn--toggle-group"
           data-shadcn--toggle-group-type-value="single"
           data-shadcn--toggle-group-value-value="a,b">
        <button data-shadcn--toggle-group-target="item" data-value="a">A</button>
        <button data-shadcn--toggle-group-target="item" data-value="b">B</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles multiple values in single mode gracefully", async () => {
      // Even though we're in single mode with multiple values, it should parse them
      const values = controller.getValues()
      expect(values).toEqual(["a", "b"])

      // Both should be marked as on (edge case behavior)
      const buttonA = controller.itemTargets[0]
      const buttonB = controller.itemTargets[1]
      expect(buttonA.getAttribute("data-state")).toBe("on")
      expect(buttonB.getAttribute("data-state")).toBe("on")
    })

    test("clicking selected item in single mode with multiple values clears all", async () => {
      // Start with multiple values selected (edge case - shouldn't happen in normal use)
      controller.valueValue = "a,b"
      await nextFrame()

      // Manually call toggle like a click would
      const buttonA = controller.itemTargets[0]
      controller.toggle({ currentTarget: buttonA })
      await nextFrame()

      // Since currentValues ["a", "b"] includes "a", it sets to empty string
      expect(controller.valueValue).toBe("")
    })
  })

  describe("item without data-value attribute", () => {
    const html = `
      <div data-controller="shadcn--toggle-group"
           data-shadcn--toggle-group-type-value="single">
        <button data-shadcn--toggle-group-target="item" data-value="a"
                data-action="click->shadcn--toggle-group#toggle">A</button>
        <button data-shadcn--toggle-group-target="item"
                data-action="click->shadcn--toggle-group#toggle">No Value</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ToggleGroupController, html, 'shadcn--toggle-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles item without data-value gracefully", async () => {
      const noValueButton = controller.itemTargets[1]

      // Should not error when clicking
      expect(() => {
        click(noValueButton)
      }).not.toThrow()
    })

    test("treats undefined value as empty string or undefined", async () => {
      const noValueButton = controller.itemTargets[1]
      click(noValueButton)
      await nextFrame()

      // Behavior depends on implementation - typically would add undefined
      // The filter(Boolean) in the controller would filter it out
      const values = controller.getValues()
      // undefined gets converted to string "undefined" or filtered
      expect(values.length).toBeLessThanOrEqual(1)
    })
  })
})
