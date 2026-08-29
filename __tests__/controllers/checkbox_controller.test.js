import { Application } from "@hotwired/stimulus"
import CheckboxController from "../../app/assets/javascripts/shadcn/controllers/checkbox_controller.ts"
import { setupController, cleanupController, click, nextFrame, keydown } from '../helpers/stimulus-test-helper.js'

describe("CheckboxController", () => {
  let application
  let element
  let controller

  afterEach(() => {
    cleanupController(application)
  })

  describe("basic rendering and initialization", () => {
    const basicHTML = `
      <button data-controller="shadcn--checkbox"
              data-shadcn--checkbox-checked-value="false"
              data-shadcn--checkbox-name-value="agree"
              type="button"
              role="checkbox"
              aria-checked="false"
              data-action="click->shadcn--checkbox#toggle">
        <svg style="opacity: 0;">✓</svg>
      </button>
    `

    beforeEach(async () => {
      const setup = await setupController(CheckboxController, basicHTML, 'shadcn--checkbox')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with unchecked state", () => {
      expect(controller.checkedValue).toBe(false)
    })

    test("sets data-state unchecked on element", () => {
      expect(element.dataset.state).toBe("unchecked")
    })

    test("sets aria-checked false on element", () => {
      expect(element.getAttribute("aria-checked")).toBe("false")
    })

    test("hides checkmark icon initially", () => {
      const svg = element.querySelector("svg")
      expect(svg.style.opacity).toBe("0")
    })

    test("initializes with name value", () => {
      expect(controller.nameValue).toBe("agree")
    })
  })

  describe("toggle functionality", () => {
    const toggleHTML = `
      <div>
        <button data-controller="shadcn--checkbox"
                data-shadcn--checkbox-checked-value="false"
                data-shadcn--checkbox-name-value="terms"
                type="button"
                role="checkbox"
                data-action="click->shadcn--checkbox#toggle">
          <svg style="opacity: 0;">✓</svg>
        </button>
        <input type="hidden" name="terms" value="0">
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(CheckboxController, toggleHTML, 'shadcn--checkbox')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("toggles from unchecked to checked", async () => {
      controller.toggle()
      await nextFrame()

      expect(controller.checkedValue).toBe(true)
    })

    test("toggles from checked to unchecked", async () => {
      controller.checkedValue = true
      controller.toggle()
      await nextFrame()

      expect(controller.checkedValue).toBe(false)
    })

    test("updates data-state on toggle", async () => {
      controller.toggle()
      await nextFrame()

      expect(element.dataset.state).toBe("checked")
    })

    test("updates aria-checked on toggle", async () => {
      controller.toggle()
      await nextFrame()

      expect(element.getAttribute("aria-checked")).toBe("true")
    })

    test("shows checkmark icon when checked", async () => {
      controller.toggle()
      await nextFrame()

      const svg = element.querySelector("svg")
      expect(svg.style.opacity).toBe("1")
    })

    test("hides checkmark icon when unchecked", async () => {
      controller.checkedValue = true
      controller.updateState()
      controller.toggle()
      await nextFrame()

      const svg = element.querySelector("svg")
      expect(svg.style.opacity).toBe("0")
    })

    test("dispatches change event on toggle", async () => {
      let eventDetail = null
      element.addEventListener("shadcn--checkbox:change", (e) => {
        eventDetail = e.detail
      })

      controller.toggle()
      await nextFrame()

      expect(eventDetail).not.toBeNull()
      expect(eventDetail.checked).toBe(true)
    })

    test("dispatches change event with false when unchecking", async () => {
      controller.checkedValue = true
      let eventDetail = null
      element.addEventListener("shadcn--checkbox:change", (e) => {
        eventDetail = e.detail
      })

      controller.toggle()
      await nextFrame()

      expect(eventDetail.checked).toBe(false)
    })
  })

  describe("hidden input synchronization", () => {
    const inputSyncHTML = `
      <div>
        <button data-controller="shadcn--checkbox"
                data-shadcn--checkbox-checked-value="false"
                data-shadcn--checkbox-name-value="subscribe"
                type="button"
                data-action="click->shadcn--checkbox#toggle">
          <svg style="opacity: 0;">✓</svg>
        </button>
        <input type="hidden" name="subscribe" value="0">
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(CheckboxController, inputSyncHTML, 'shadcn--checkbox')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("updates hidden input to 1 when checked", async () => {
      controller.toggle()
      await nextFrame()

      const input = element.parentElement.querySelector('input[name="subscribe"]')
      expect(input.value).toBe("1")
    })

    test("updates hidden input to 0 when unchecked", async () => {
      controller.checkedValue = true
      controller.updateHiddenInput()

      controller.toggle()
      await nextFrame()

      const input = element.parentElement.querySelector('input[name="subscribe"]')
      expect(input.value).toBe("0")
    })
  })

  describe("initial checked state", () => {
    const checkedHTML = `
      <div>
        <button data-controller="shadcn--checkbox"
                data-shadcn--checkbox-checked-value="true"
                data-shadcn--checkbox-name-value="remember"
                type="button"
                role="checkbox"
                aria-checked="true"
                data-action="click->shadcn--checkbox#toggle">
          <svg style="opacity: 1;">✓</svg>
        </button>
        <input type="hidden" name="remember" value="1">
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(CheckboxController, checkedHTML, 'shadcn--checkbox')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with checked state", () => {
      expect(controller.checkedValue).toBe(true)
    })

    test("sets data-state checked on init", () => {
      expect(element.dataset.state).toBe("checked")
    })

    test("sets aria-checked true on init", () => {
      expect(element.getAttribute("aria-checked")).toBe("true")
    })

    test("shows checkmark on init", () => {
      const svg = element.querySelector("svg")
      expect(svg.style.opacity).toBe("1")
    })
  })

  describe("programmatic value change", () => {
    const programmaticHTML = `
      <button data-controller="shadcn--checkbox"
              data-shadcn--checkbox-checked-value="false"
              type="button">
        <svg style="opacity: 0;">✓</svg>
      </button>
    `

    beforeEach(async () => {
      const setup = await setupController(CheckboxController, programmaticHTML, 'shadcn--checkbox')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("updates UI when checkedValue changes", async () => {
      controller.checkedValue = true
      await nextFrame()

      expect(element.dataset.state).toBe("checked")
      expect(element.getAttribute("aria-checked")).toBe("true")
    })

    test("checkedValueChanged callback updates state", async () => {
      const updateStateSpy = jest.spyOn(controller, 'updateState')

      controller.checkedValue = true
      await nextFrame()

      expect(updateStateSpy).toHaveBeenCalled()
    })
  })

  describe("without name value", () => {
    const noNameHTML = `
      <div>
        <button data-controller="shadcn--checkbox"
                data-shadcn--checkbox-checked-value="false"
                type="button"
                data-action="click->shadcn--checkbox#toggle">
          <svg style="opacity: 0;">✓</svg>
        </button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(CheckboxController, noNameHTML, 'shadcn--checkbox')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("works without name value", async () => {
      expect(() => {
        controller.toggle()
      }).not.toThrow()

      expect(controller.checkedValue).toBe(true)
    })

    test("does not try to update non-existent hidden input", () => {
      expect(() => {
        controller.updateHiddenInput()
      }).not.toThrow()
    })
  })

  describe("without SVG icon", () => {
    const noIconHTML = `
      <button data-controller="shadcn--checkbox"
              data-shadcn--checkbox-checked-value="false"
              type="button"
              data-action="click->shadcn--checkbox#toggle">
        Check
      </button>
    `

    beforeEach(async () => {
      const setup = await setupController(CheckboxController, noIconHTML, 'shadcn--checkbox')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("works without SVG icon", async () => {
      expect(() => {
        controller.toggle()
      }).not.toThrow()

      expect(controller.checkedValue).toBe(true)
    })

    test("updateState does not throw without SVG", () => {
      expect(() => {
        controller.updateState()
      }).not.toThrow()
    })
  })

  describe("multiple toggles", () => {
    const multipleHTML = `
      <button data-controller="shadcn--checkbox"
              data-shadcn--checkbox-checked-value="false"
              type="button"
              data-action="click->shadcn--checkbox#toggle">
        <svg style="opacity: 0;">✓</svg>
      </button>
    `

    beforeEach(async () => {
      const setup = await setupController(CheckboxController, multipleHTML, 'shadcn--checkbox')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles multiple rapid toggles", async () => {
      controller.toggle() // true
      controller.toggle() // false
      controller.toggle() // true
      await nextFrame()

      expect(controller.checkedValue).toBe(true)
    })

    test("emits change event for each toggle", async () => {
      let changeCount = 0
      element.addEventListener("shadcn--checkbox:change", () => {
        changeCount++
      })

      controller.toggle()
      controller.toggle()
      controller.toggle()
      await nextFrame()

      expect(changeCount).toBe(3)
    })

    test("final state is correct after even number of toggles", async () => {
      controller.toggle()
      controller.toggle()
      controller.toggle()
      controller.toggle()
      await nextFrame()

      expect(controller.checkedValue).toBe(false)
    })
  })

  describe("click handler", () => {
    const clickHTML = `
      <button data-controller="shadcn--checkbox"
              data-shadcn--checkbox-checked-value="false"
              type="button"
              data-action="click->shadcn--checkbox#toggle">
        <svg style="opacity: 0;">✓</svg>
      </button>
    `

    beforeEach(async () => {
      const setup = await setupController(CheckboxController, clickHTML, 'shadcn--checkbox')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("toggles on click", async () => {
      click(element)
      await nextFrame()

      expect(controller.checkedValue).toBe(true)
    })

    test("toggles again on second click", async () => {
      click(element)
      await nextFrame()
      click(element)
      await nextFrame()

      expect(controller.checkedValue).toBe(false)
    })
  })

  describe("edge cases", () => {
    const edgeCaseHTML = `
      <div>
        <button data-controller="shadcn--checkbox"
                data-shadcn--checkbox-checked-value="false"
                data-shadcn--checkbox-name-value="test"
                type="button"
                data-action="click->shadcn--checkbox#toggle">
          <svg style="opacity: 0;">✓</svg>
        </button>
        <input type="hidden" name="other" value="0">
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(CheckboxController, edgeCaseHTML, 'shadcn--checkbox')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("does not update input with different name", async () => {
      controller.toggle()
      await nextFrame()

      const otherInput = element.parentElement.querySelector('input[name="other"]')
      expect(otherInput.value).toBe("0")
    })

    test("gracefully handles missing input with matching name", async () => {
      expect(() => {
        controller.toggle()
      }).not.toThrow()
    })
  })
})
