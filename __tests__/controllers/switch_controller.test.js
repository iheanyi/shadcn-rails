import { Application } from "@hotwired/stimulus"
import SwitchController from "../../app/assets/javascripts/shadcn/controllers/switch_controller.ts"
import { setupController, cleanupController, click, nextFrame, keydown } from '../helpers/stimulus-test-helper.js'

describe("SwitchController", () => {
  let application
  let element
  let controller

  afterEach(() => {
    cleanupController(application)
  })

  describe("basic rendering and initialization", () => {
    const basicHTML = `
      <div data-controller="shadcn--switch"
           data-shadcn--switch-checked-value="false">
        <button data-shadcn--switch-target="button"
                type="button"
                role="switch"
                aria-checked="false"
                data-action="click->shadcn--switch#toggle keydown->shadcn--switch#handleKeydown">
          <span data-shadcn--switch-target="thumb"></span>
        </button>
        <input type="checkbox"
               data-shadcn--switch-target="input"
               name="notifications"
               hidden>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SwitchController, basicHTML, 'shadcn--switch')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with unchecked state", () => {
      expect(controller.checkedValue).toBe(false)
    })

    test("sets data-state on element", () => {
      expect(element.dataset.state).toBe("unchecked")
    })

    test("sets data-state on button", () => {
      expect(controller.buttonTarget.dataset.state).toBe("unchecked")
    })

    test("sets aria-checked on button", () => {
      expect(controller.buttonTarget.getAttribute("aria-checked")).toBe("false")
    })

    test("sets data-state on thumb", () => {
      expect(controller.thumbTarget.dataset.state).toBe("unchecked")
    })
  })

  describe("toggle functionality", () => {
    const toggleHTML = `
      <div data-controller="shadcn--switch"
           data-shadcn--switch-checked-value="false">
        <button data-shadcn--switch-target="button"
                type="button"
                role="switch"
                data-action="click->shadcn--switch#toggle">
          <span data-shadcn--switch-target="thumb"></span>
        </button>
        <input type="checkbox"
               data-shadcn--switch-target="input"
               name="enabled"
               hidden>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SwitchController, toggleHTML, 'shadcn--switch')
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

    test("updates data-state on toggle to checked", async () => {
      controller.toggle()
      await nextFrame()

      expect(element.dataset.state).toBe("checked")
      expect(controller.buttonTarget.dataset.state).toBe("checked")
      expect(controller.thumbTarget.dataset.state).toBe("checked")
    })

    test("updates aria-checked on toggle", async () => {
      controller.toggle()
      await nextFrame()

      expect(controller.buttonTarget.getAttribute("aria-checked")).toBe("true")
    })

    test("dispatches change event on toggle", async () => {
      let eventDetail = null
      element.addEventListener("shadcn--switch:change", (e) => {
        eventDetail = e.detail
      })

      controller.toggle()
      await nextFrame()

      expect(eventDetail).not.toBeNull()
      expect(eventDetail.checked).toBe(true)
    })

    test("dispatches change event with false when toggling off", async () => {
      controller.checkedValue = true
      let eventDetail = null
      element.addEventListener("shadcn--switch:change", (e) => {
        eventDetail = e.detail
      })

      controller.toggle()
      await nextFrame()

      expect(eventDetail.checked).toBe(false)
    })
  })

  describe("hidden input synchronization", () => {
    const inputSyncHTML = `
      <div data-controller="shadcn--switch"
           data-shadcn--switch-checked-value="false">
        <button data-shadcn--switch-target="button"
                data-action="click->shadcn--switch#toggle">
          <span data-shadcn--switch-target="thumb"></span>
        </button>
        <input type="checkbox"
               data-shadcn--switch-target="input"
               name="feature_flag"
               hidden>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SwitchController, inputSyncHTML, 'shadcn--switch')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("syncs hidden input checked state", async () => {
      controller.toggle()
      await nextFrame()

      expect(controller.inputTarget.checked).toBe(true)
    })

    test("unchecks hidden input when toggled off", async () => {
      controller.checkedValue = true
      controller.syncInput()
      expect(controller.inputTarget.checked).toBe(true)

      controller.toggle()
      await nextFrame()

      expect(controller.inputTarget.checked).toBe(false)
    })

    test("dispatches native change event on input", async () => {
      let nativeChangeEvent = false
      controller.inputTarget.addEventListener("change", () => {
        nativeChangeEvent = true
      })

      controller.toggle()
      await nextFrame()

      expect(nativeChangeEvent).toBe(true)
    })
  })

  describe("keyboard navigation", () => {
    const keyboardHTML = `
      <div data-controller="shadcn--switch"
           data-shadcn--switch-checked-value="false">
        <button data-shadcn--switch-target="button"
                data-action="click->shadcn--switch#toggle keydown->shadcn--switch#handleKeydown">
          <span data-shadcn--switch-target="thumb"></span>
        </button>
        <input type="checkbox" data-shadcn--switch-target="input" hidden>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SwitchController, keyboardHTML, 'shadcn--switch')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("toggles on Space key", async () => {
      controller.handleKeydown({ key: " ", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.checkedValue).toBe(true)
    })

    test("toggles on Enter key", async () => {
      controller.handleKeydown({ key: "Enter", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.checkedValue).toBe(true)
    })

    test("prevents default on Space", () => {
      const preventDefault = jest.fn()
      controller.handleKeydown({ key: " ", preventDefault })

      expect(preventDefault).toHaveBeenCalled()
    })

    test("prevents default on Enter", () => {
      const preventDefault = jest.fn()
      controller.handleKeydown({ key: "Enter", preventDefault })

      expect(preventDefault).toHaveBeenCalled()
    })

    test("ignores other keys", () => {
      const preventDefault = jest.fn()
      controller.handleKeydown({ key: "Tab", preventDefault })

      expect(preventDefault).not.toHaveBeenCalled()
      expect(controller.checkedValue).toBe(false)
    })
  })

  describe("disabled state", () => {
    const disabledHTML = `
      <div data-controller="shadcn--switch"
           data-shadcn--switch-checked-value="false">
        <button data-shadcn--switch-target="button"
                disabled
                data-action="click->shadcn--switch#toggle">
          <span data-shadcn--switch-target="thumb"></span>
        </button>
        <input type="checkbox" data-shadcn--switch-target="input" hidden>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SwitchController, disabledHTML, 'shadcn--switch')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("does not toggle when disabled", async () => {
      controller.toggle()
      await nextFrame()

      expect(controller.checkedValue).toBe(false)
    })
  })

  describe("initial checked state", () => {
    const checkedHTML = `
      <div data-controller="shadcn--switch"
           data-shadcn--switch-checked-value="true">
        <button data-shadcn--switch-target="button"
                role="switch"
                aria-checked="true"
                data-action="click->shadcn--switch#toggle">
          <span data-shadcn--switch-target="thumb"></span>
        </button>
        <input type="checkbox" data-shadcn--switch-target="input" checked hidden>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SwitchController, checkedHTML, 'shadcn--switch')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with checked state", () => {
      expect(controller.checkedValue).toBe(true)
    })

    test("sets checked data-state on init", () => {
      expect(element.dataset.state).toBe("checked")
    })

    test("sets aria-checked true on init", () => {
      expect(controller.buttonTarget.getAttribute("aria-checked")).toBe("true")
    })
  })

  describe("programmatic value change", () => {
    const programmaticHTML = `
      <div data-controller="shadcn--switch"
           data-shadcn--switch-checked-value="false">
        <button data-shadcn--switch-target="button">
          <span data-shadcn--switch-target="thumb"></span>
        </button>
        <input type="checkbox" data-shadcn--switch-target="input" hidden>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SwitchController, programmaticHTML, 'shadcn--switch')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("updates UI when checkedValue changes", async () => {
      controller.checkedValue = true
      await nextFrame()

      expect(element.dataset.state).toBe("checked")
      expect(controller.buttonTarget.getAttribute("aria-checked")).toBe("true")
    })

    test("syncs input when checkedValue changes", async () => {
      controller.checkedValue = true
      await nextFrame()

      expect(controller.inputTarget.checked).toBe(true)
    })
  })

  describe("multiple toggles", () => {
    const multipleToggleHTML = `
      <div data-controller="shadcn--switch"
           data-shadcn--switch-checked-value="false">
        <button data-shadcn--switch-target="button"
                data-action="click->shadcn--switch#toggle">
          <span data-shadcn--switch-target="thumb"></span>
        </button>
        <input type="checkbox" data-shadcn--switch-target="input" hidden>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SwitchController, multipleToggleHTML, 'shadcn--switch')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles rapid toggles correctly", async () => {
      controller.toggle() // true
      controller.toggle() // false
      controller.toggle() // true
      await nextFrame()

      expect(controller.checkedValue).toBe(true)
    })

    test("maintains state consistency through multiple toggles", async () => {
      let changeCount = 0
      element.addEventListener("shadcn--switch:change", () => {
        changeCount++
      })

      controller.toggle()
      controller.toggle()
      controller.toggle()
      controller.toggle()
      await nextFrame()

      expect(changeCount).toBe(4)
      expect(controller.checkedValue).toBe(false)
    })
  })

  describe("without optional targets", () => {
    const minimalHTML = `
      <div data-controller="shadcn--switch"
           data-shadcn--switch-checked-value="false">
        <button data-shadcn--switch-target="button"
                data-action="click->shadcn--switch#toggle">Toggle</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SwitchController, minimalHTML, 'shadcn--switch')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("works without thumb target", async () => {
      expect(() => {
        controller.toggle()
      }).not.toThrow()

      expect(controller.checkedValue).toBe(true)
    })

    test("works without input target", async () => {
      expect(() => {
        controller.toggle()
      }).not.toThrow()

      expect(controller.checkedValue).toBe(true)
    })
  })
})
