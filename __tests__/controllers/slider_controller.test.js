import { Application } from "@hotwired/stimulus"
import SliderController from "../../app/assets/javascripts/shadcn/controllers/slider_controller.js"
import { setupController, cleanupController, click, nextFrame, keydown } from '../helpers/stimulus-test-helper.js'

describe("SliderController", () => {
  let application
  let element
  let controller

  afterEach(() => {
    cleanupController(application)
  })

  describe("basic rendering and initialization", () => {
    const basicHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="0"
           data-shadcn--slider-max-value="100"
           data-shadcn--slider-step-value="1"
           data-shadcn--slider-value-value="50"
           role="slider"
           aria-valuemin="0"
           aria-valuemax="100"
           aria-valuenow="50">
        <div data-shadcn--slider-target="track" style="width: 200px; height: 8px;">
          <div data-shadcn--slider-target="range" style="width: 50%;"></div>
        </div>
        <div data-shadcn--slider-target="thumb"
             tabindex="0"
             data-action="keydown->shadcn--slider#handleKeydown"
             style="left: calc(50% - 8px);"></div>
        <input type="hidden" data-shadcn--slider-target="input" name="volume">
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, basicHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with default values", () => {
      expect(controller.minValue).toBe(0)
      expect(controller.maxValue).toBe(100)
      expect(controller.stepValue).toBe(1)
      expect(controller.valueValue).toBe(50)
    })

    test("initializes with disabled false by default", () => {
      expect(controller.disabledValue).toBe(false)
    })

    test("calculates percentage correctly", () => {
      expect(controller.percentage).toBe(50)
    })

    test("updates hidden input value on init", () => {
      expect(controller.inputTarget.value).toBe("50")
    })
  })

  describe("percentage calculation", () => {
    const percentHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="0"
           data-shadcn--slider-max-value="100"
           data-shadcn--slider-value-value="25">
        <div data-shadcn--slider-target="track" style="width: 200px;"></div>
        <div data-shadcn--slider-target="range"></div>
        <div data-shadcn--slider-target="thumb"></div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, percentHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("calculates percentage at 25%", () => {
      expect(controller.percentage).toBe(25)
    })

    test("calculates percentage at 0%", async () => {
      controller.valueValue = 0
      await nextFrame()
      expect(controller.percentage).toBe(0)
    })

    test("calculates percentage at 100%", async () => {
      controller.valueValue = 100
      await nextFrame()
      expect(controller.percentage).toBe(100)
    })

    test("handles equal min and max gracefully", async () => {
      controller.minValue = 50
      controller.maxValue = 50
      await nextFrame()
      expect(controller.percentage).toBe(0)
    })
  })

  describe("custom range", () => {
    const customRangeHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="10"
           data-shadcn--slider-max-value="50"
           data-shadcn--slider-value-value="30">
        <div data-shadcn--slider-target="track" style="width: 200px;"></div>
        <div data-shadcn--slider-target="range"></div>
        <div data-shadcn--slider-target="thumb"></div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, customRangeHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("calculates percentage for custom range", () => {
      // 30 is halfway between 10 and 50
      expect(controller.percentage).toBe(50)
    })
  })

  describe("step snapping", () => {
    const stepHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="0"
           data-shadcn--slider-max-value="100"
           data-shadcn--slider-step-value="10"
           data-shadcn--slider-value-value="0">
        <div data-shadcn--slider-target="track" style="width: 200px;"></div>
        <div data-shadcn--slider-target="range"></div>
        <div data-shadcn--slider-target="thumb"></div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, stepHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("snaps to nearest step", () => {
      expect(controller.snapToStep(23)).toBe(20)
      expect(controller.snapToStep(27)).toBe(30)
      expect(controller.snapToStep(25)).toBe(30)
    })

    test("snaps to min when below range", () => {
      expect(controller.snapToStep(-5)).toBe(0)
    })

    test("snaps to max when above range", () => {
      expect(controller.snapToStep(105)).toBe(100)
    })
  })

  describe("decimal step snapping", () => {
    const decimalStepHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="0"
           data-shadcn--slider-max-value="1"
           data-shadcn--slider-step-value="0.1"
           data-shadcn--slider-value-value="0.5">
        <div data-shadcn--slider-target="track" style="width: 200px;"></div>
        <div data-shadcn--slider-target="range"></div>
        <div data-shadcn--slider-target="thumb"></div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, decimalStepHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles decimal values correctly", () => {
      expect(controller.valueValue).toBe(0.5)
      expect(controller.percentage).toBe(50)
    })

    test("snaps to decimal steps", () => {
      expect(controller.snapToStep(0.23)).toBeCloseTo(0.2, 5)
      expect(controller.snapToStep(0.27)).toBeCloseTo(0.3, 5)
    })
  })

  describe("keyboard navigation", () => {
    const keyboardHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="0"
           data-shadcn--slider-max-value="100"
           data-shadcn--slider-step-value="1"
           data-shadcn--slider-value-value="50">
        <div data-shadcn--slider-target="track" style="width: 200px;"></div>
        <div data-shadcn--slider-target="range"></div>
        <div data-shadcn--slider-target="thumb"
             tabindex="0"
             data-action="keydown->shadcn--slider#handleKeydown"></div>
        <input type="hidden" data-shadcn--slider-target="input">
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, keyboardHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("increases value with ArrowRight", () => {
      controller.handleKeydown({ key: "ArrowRight", preventDefault: jest.fn() })
      expect(controller.valueValue).toBe(51)
    })

    test("increases value with ArrowUp", () => {
      controller.handleKeydown({ key: "ArrowUp", preventDefault: jest.fn() })
      expect(controller.valueValue).toBe(51)
    })

    test("decreases value with ArrowLeft", () => {
      controller.handleKeydown({ key: "ArrowLeft", preventDefault: jest.fn() })
      expect(controller.valueValue).toBe(49)
    })

    test("decreases value with ArrowDown", () => {
      controller.handleKeydown({ key: "ArrowDown", preventDefault: jest.fn() })
      expect(controller.valueValue).toBe(49)
    })

    test("jumps by 10% with PageUp", () => {
      controller.handleKeydown({ key: "PageUp", preventDefault: jest.fn() })
      expect(controller.valueValue).toBe(60)
    })

    test("jumps by 10% with PageDown", () => {
      controller.handleKeydown({ key: "PageDown", preventDefault: jest.fn() })
      expect(controller.valueValue).toBe(40)
    })

    test("jumps to min with Home", () => {
      controller.handleKeydown({ key: "Home", preventDefault: jest.fn() })
      expect(controller.valueValue).toBe(0)
    })

    test("jumps to max with End", () => {
      controller.handleKeydown({ key: "End", preventDefault: jest.fn() })
      expect(controller.valueValue).toBe(100)
    })

    test("does not exceed max value", () => {
      controller.valueValue = 100
      controller.handleKeydown({ key: "ArrowRight", preventDefault: jest.fn() })
      expect(controller.valueValue).toBe(100)
    })

    test("does not go below min value", () => {
      controller.valueValue = 0
      controller.handleKeydown({ key: "ArrowLeft", preventDefault: jest.fn() })
      expect(controller.valueValue).toBe(0)
    })

    test("dispatches change event on keyboard navigation", () => {
      let eventDetail = null
      element.addEventListener("shadcn--slider:change", (e) => {
        eventDetail = e.detail
      })

      controller.handleKeydown({ key: "ArrowRight", preventDefault: jest.fn() })

      expect(eventDetail).not.toBeNull()
      expect(eventDetail.value).toBe(51)
    })

    test("ignores unrelated keys", () => {
      const preventDefault = jest.fn()
      controller.handleKeydown({ key: "Tab", preventDefault })
      expect(preventDefault).not.toHaveBeenCalled()
      expect(controller.valueValue).toBe(50)
    })
  })

  describe("disabled state", () => {
    const disabledHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="0"
           data-shadcn--slider-max-value="100"
           data-shadcn--slider-value-value="50"
           data-shadcn--slider-disabled-value="true">
        <div data-shadcn--slider-target="track" style="width: 200px;"></div>
        <div data-shadcn--slider-target="range"></div>
        <div data-shadcn--slider-target="thumb"></div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, disabledHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("ignores keyboard when disabled", () => {
      controller.handleKeydown({ key: "ArrowRight", preventDefault: jest.fn() })
      expect(controller.valueValue).toBe(50)
    })

    test("ignores drag when disabled", () => {
      const event = { preventDefault: jest.fn(), type: "mousedown" }
      controller.startDrag(event)
      expect(controller.isDragging).toBeFalsy()
    })
  })

  describe("visual updates", () => {
    const visualHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="0"
           data-shadcn--slider-max-value="100"
           data-shadcn--slider-value-value="50">
        <div data-shadcn--slider-target="track" style="width: 200px;"></div>
        <div data-shadcn--slider-target="range" style="width: 0%;"></div>
        <div data-shadcn--slider-target="thumb" style="left: 0;"></div>
        <input type="hidden" data-shadcn--slider-target="input">
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, visualHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("updates range width on value change", async () => {
      controller.valueValue = 75
      controller.updateVisuals()
      await nextFrame()

      expect(controller.rangeTarget.style.width).toBe("75%")
    })

    test("updates thumb position on value change", async () => {
      controller.valueValue = 75
      controller.updateVisuals()
      await nextFrame()

      expect(controller.thumbTarget.style.left).toBe("calc(75% - 8px)")
    })

    test("updates aria-valuenow on value change", async () => {
      controller.valueValue = 75
      controller.updateVisuals()
      await nextFrame()

      expect(element.getAttribute("aria-valuenow")).toBe("75")
    })

    test("updates hidden input on value change", async () => {
      controller.valueValue = 75
      controller.updateVisuals()
      await nextFrame()

      expect(controller.inputTarget.value).toBe("75")
    })
  })

  describe("output formatting", () => {
    const outputHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="0"
           data-shadcn--slider-max-value="100"
           data-shadcn--slider-value-value="50"
           data-shadcn--slider-output-format-value="{value}%">
        <div data-shadcn--slider-target="track" style="width: 200px;"></div>
        <div data-shadcn--slider-target="range"></div>
        <div data-shadcn--slider-target="thumb"></div>
        <span data-shadcn--slider-target="output"></span>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, outputHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("formats output with value", async () => {
      controller.updateVisuals()
      await nextFrame()

      expect(controller.outputTarget.textContent).toBe("50%")
    })

    test("updates output on value change", async () => {
      controller.valueValue = 75
      controller.updateVisuals()
      await nextFrame()

      expect(controller.outputTarget.textContent).toBe("75%")
    })
  })

  describe("output formatting with percent", () => {
    const percentOutputHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="0"
           data-shadcn--slider-max-value="200"
           data-shadcn--slider-value-value="100"
           data-shadcn--slider-output-format-value="Value: {value}, Progress: {percent}%">
        <div data-shadcn--slider-target="track" style="width: 200px;"></div>
        <div data-shadcn--slider-target="range"></div>
        <div data-shadcn--slider-target="thumb"></div>
        <span data-shadcn--slider-target="output"></span>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, percentOutputHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("formats output with both value and percent", async () => {
      controller.updateVisuals()
      await nextFrame()

      expect(controller.outputTarget.textContent).toBe("Value: 100, Progress: 50%")
    })
  })

  describe("drag functionality", () => {
    const dragHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="0"
           data-shadcn--slider-max-value="100"
           data-shadcn--slider-step-value="1"
           data-shadcn--slider-value-value="50">
        <div data-shadcn--slider-target="track" style="width: 200px; height: 8px;"></div>
        <div data-shadcn--slider-target="range"></div>
        <div data-shadcn--slider-target="thumb"
             data-action="mousedown->shadcn--slider#startDrag"></div>
        <input type="hidden" data-shadcn--slider-target="input">
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, dragHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller

      // Mock getBoundingClientRect for track
      controller.trackTarget.getBoundingClientRect = jest.fn().mockReturnValue({
        left: 0,
        right: 200,
        width: 200,
        top: 0,
        bottom: 8,
        height: 8
      })
    })

    test("starts drag on mousedown", () => {
      const event = {
        preventDefault: jest.fn(),
        type: "mousedown",
        clientX: 100
      }

      controller.startDrag(event)

      expect(controller.isDragging).toBe(true)
    })

    test("updates value during drag", () => {
      controller.isDragging = true

      const event = {
        type: "mousemove",
        clientX: 150
      }

      controller.handleDrag(event)

      expect(controller.valueValue).toBe(75)
    })

    test("clamps value to track bounds", () => {
      controller.isDragging = true

      // Beyond right edge
      controller.handleDrag({ type: "mousemove", clientX: 300 })
      expect(controller.valueValue).toBe(100)

      // Beyond left edge
      controller.handleDrag({ type: "mousemove", clientX: -50 })
      expect(controller.valueValue).toBe(0)
    })

    test("stops drag and removes listeners", () => {
      controller.isDragging = true
      controller.boundHandleDrag = jest.fn()
      controller.boundStopDrag = jest.fn()

      const removeEventListenerSpy = jest.spyOn(document, 'removeEventListener')

      controller.stopDrag()

      expect(controller.isDragging).toBe(false)
      expect(removeEventListenerSpy).toHaveBeenCalledWith("mousemove", controller.boundHandleDrag)
      expect(removeEventListenerSpy).toHaveBeenCalledWith("mouseup", controller.boundStopDrag)
    })
  })

  describe("touch events", () => {
    const touchHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-min-value="0"
           data-shadcn--slider-max-value="100"
           data-shadcn--slider-value-value="50">
        <div data-shadcn--slider-target="track" style="width: 200px;"></div>
        <div data-shadcn--slider-target="range"></div>
        <div data-shadcn--slider-target="thumb"></div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, touchHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller

      controller.trackTarget.getBoundingClientRect = jest.fn().mockReturnValue({
        left: 0,
        right: 200,
        width: 200,
        top: 0,
        bottom: 8,
        height: 8
      })
    })

    test("handles touch events", () => {
      controller.isDragging = true

      const event = {
        type: "touchmove",
        touches: [{ clientX: 100 }]
      }

      controller.handleDrag(event)

      expect(controller.valueValue).toBe(50)
    })
  })

  describe("native input range support (updateStyle)", () => {
    const nativeInputHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-value-value="50">
        <input type="range"
               min="0"
               max="100"
               value="50"
               data-action="input->shadcn--slider#updateStyle">
        <span data-shadcn--slider-target="output"></span>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, nativeInputHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("updates CSS custom property on input", () => {
      const input = element.querySelector('input[type="range"]')
      input.value = "75"

      const setPropertySpy = jest.spyOn(input.style, 'setProperty')

      controller.updateStyle({ target: input })

      expect(setPropertySpy).toHaveBeenCalledWith("--slider-fill", "75%")
    })

    test("dispatches change event on native input", () => {
      let eventDetail = null
      element.addEventListener("shadcn--slider:change", (e) => {
        eventDetail = e.detail
      })

      const input = element.querySelector('input[type="range"]')
      input.value = "75"
      controller.updateStyle({ target: input })

      expect(eventDetail).not.toBeNull()
      expect(eventDetail.value).toBe(75)
      expect(eventDetail.percentage).toBe(75)
    })
  })

  describe("ID-based output targeting (data-output-target)", () => {
    let outputDisplay

    beforeEach(async () => {
      const idOutputHTML = `
        <div data-controller="shadcn--slider"
             data-shadcn--slider-value-value="50">
          <input type="range"
                 min="0"
                 max="100"
                 value="50"
                 data-output-target="slider-value-display"
                 data-output-format="{value}%"
                 data-action="input->shadcn--slider#updateStyle">
        </div>
      `

      const setup = await setupController(SliderController, idOutputHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller

      // Create output element AFTER setupController (which clears body.innerHTML)
      outputDisplay = document.createElement('span')
      outputDisplay.id = "slider-value-display"
      outputDisplay.textContent = "50"
      document.body.appendChild(outputDisplay)
    })

    afterEach(() => {
      if (outputDisplay && outputDisplay.parentNode) {
        outputDisplay.parentNode.removeChild(outputDisplay)
      }
    })

    test("updates external element by ID on input", () => {
      const input = element.querySelector('input[type="range"]')

      input.value = "75"
      controller.updateStyle({ target: input })

      expect(outputDisplay.textContent).toBe("75%")
    })

    test("uses format string with {value} placeholder", () => {
      const input = element.querySelector('input[type="range"]')

      input.value = "30"
      controller.updateStyle({ target: input })

      expect(outputDisplay.textContent).toBe("30%")
    })

    test("supports {percent} placeholder in format string", () => {
      const input = element.querySelector('input[type="range"]')
      input.dataset.outputFormat = "{percent}% complete"

      input.value = "50"
      controller.updateStyle({ target: input })

      expect(outputDisplay.textContent).toBe("50% complete")
    })

    test("handles missing output element gracefully", () => {
      const input = element.querySelector('input[type="range"]')
      input.dataset.outputTarget = "non-existent-id"

      expect(() => {
        input.value = "75"
        controller.updateStyle({ target: input })
      }).not.toThrow()
    })

    test("defaults to {value} format when not specified", () => {
      const input = element.querySelector('input[type="range"]')
      delete input.dataset.outputFormat

      input.value = "42"
      controller.updateStyle({ target: input })

      expect(outputDisplay.textContent).toBe("42")
    })
  })

  describe("valueValueChanged callback", () => {
    const callbackHTML = `
      <div data-controller="shadcn--slider"
           data-shadcn--slider-value-value="50">
        <div data-shadcn--slider-target="track" style="width: 200px;"></div>
        <div data-shadcn--slider-target="range"></div>
        <div data-shadcn--slider-target="thumb"></div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SliderController, callbackHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("updates visuals when value changes programmatically", async () => {
      const updateVisualsSpy = jest.spyOn(controller, 'updateVisuals')

      controller.valueValue = 75
      await nextFrame()

      expect(updateVisualsSpy).toHaveBeenCalled()
    })
  })

  describe("two-way input binding (data-input-target)", () => {
    let linkedInput

    beforeEach(async () => {
      const twoWayHTML = `
        <div data-controller="shadcn--slider"
             data-shadcn--slider-value-value="50">
          <input type="range"
                 id="volume-slider"
                 min="0"
                 max="100"
                 step="1"
                 value="50"
                 data-input-target="volume-input"
                 data-action="input->shadcn--slider#updateStyle">
        </div>
      `

      const setup = await setupController(SliderController, twoWayHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller

      // Create linked input element AFTER setupController (which clears body.innerHTML)
      linkedInput = document.createElement('input')
      linkedInput.type = "number"
      linkedInput.id = "volume-input"
      linkedInput.value = "50"
      linkedInput.min = "0"
      linkedInput.max = "100"
      document.body.appendChild(linkedInput)

      // Re-run setup to bind the new input
      controller.setupTwoWayBindings()
    })

    afterEach(() => {
      if (linkedInput && linkedInput.parentNode) {
        linkedInput.parentNode.removeChild(linkedInput)
      }
    })

    test("syncs slider value to linked input (slider → input)", () => {
      const rangeInput = element.querySelector('input[type="range"]')

      rangeInput.value = "75"
      controller.updateStyle({ target: rangeInput })

      expect(linkedInput.value).toBe("75")
    })

    test("syncs linked input value to slider (input → slider)", () => {
      const rangeInput = element.querySelector('input[type="range"]')

      linkedInput.value = "25"
      linkedInput.dispatchEvent(new Event('input', { bubbles: true }))

      expect(rangeInput.value).toBe("25")
    })

    test("clamps linked input value to max", () => {
      const rangeInput = element.querySelector('input[type="range"]')

      linkedInput.value = "150"
      linkedInput.dispatchEvent(new Event('input', { bubbles: true }))

      expect(rangeInput.value).toBe("100")
      expect(linkedInput.value).toBe("100")
    })

    test("clamps linked input value to min", () => {
      const rangeInput = element.querySelector('input[type="range"]')

      linkedInput.value = "-10"
      linkedInput.dispatchEvent(new Event('input', { bubbles: true }))

      expect(rangeInput.value).toBe("0")
      expect(linkedInput.value).toBe("0")
    })

    test("snaps linked input value to step", () => {
      const rangeInput = element.querySelector('input[type="range"]')
      rangeInput.step = "10"

      linkedInput.value = "27"
      linkedInput.dispatchEvent(new Event('input', { bubbles: true }))

      expect(rangeInput.value).toBe("30")
      expect(linkedInput.value).toBe("30")
    })

    test("handles invalid linked input value", () => {
      const rangeInput = element.querySelector('input[type="range"]')

      linkedInput.value = "invalid"
      linkedInput.dispatchEvent(new Event('input', { bubbles: true }))

      expect(rangeInput.value).toBe("0")
      expect(linkedInput.value).toBe("0")
    })

    test("updates CSS fill when syncing from linked input", () => {
      const rangeInput = element.querySelector('input[type="range"]')
      const setPropertySpy = jest.spyOn(rangeInput.style, 'setProperty')

      linkedInput.value = "75"
      linkedInput.dispatchEvent(new Event('input', { bubbles: true }))

      expect(setPropertySpy).toHaveBeenCalledWith("--slider-fill", "75%")
    })

    test("dispatches change event when syncing from linked input", () => {
      let eventDetail = null
      element.addEventListener("shadcn--slider:change", (e) => {
        eventDetail = e.detail
      })

      linkedInput.value = "60"
      linkedInput.dispatchEvent(new Event('input', { bubbles: true }))

      expect(eventDetail).not.toBeNull()
      expect(eventDetail.value).toBe(60)
      expect(eventDetail.percentage).toBe(60)
    })

    test("handles missing linked input gracefully", () => {
      const rangeInput = element.querySelector('input[type="range"]')
      rangeInput.dataset.inputTarget = "non-existent-id"

      expect(() => {
        rangeInput.value = "75"
        controller.updateStyle({ target: rangeInput })
      }).not.toThrow()
    })

    test("cleans up event listeners on disconnect", () => {
      const removeEventListenerSpy = jest.spyOn(linkedInput, 'removeEventListener')

      controller.teardownTwoWayBindings()

      expect(removeEventListenerSpy).toHaveBeenCalledWith('input', expect.any(Function))
      expect(removeEventListenerSpy).toHaveBeenCalledWith('change', expect.any(Function))
    })
  })

  describe("two-way binding with output sync", () => {
    let linkedInput
    let outputDisplay

    beforeEach(async () => {
      const combinedHTML = `
        <div data-controller="shadcn--slider"
             data-shadcn--slider-value-value="50">
          <input type="range"
                 id="combined-slider"
                 min="0"
                 max="100"
                 value="50"
                 data-input-target="combined-input"
                 data-output-target="combined-output"
                 data-output-format="{value}%"
                 data-action="input->shadcn--slider#updateStyle">
        </div>
      `

      const setup = await setupController(SliderController, combinedHTML, 'shadcn--slider')
      application = setup.application
      element = setup.element
      controller = setup.controller

      // Create linked input and output elements
      linkedInput = document.createElement('input')
      linkedInput.type = "number"
      linkedInput.id = "combined-input"
      linkedInput.value = "50"
      document.body.appendChild(linkedInput)

      outputDisplay = document.createElement('span')
      outputDisplay.id = "combined-output"
      outputDisplay.textContent = "50%"
      document.body.appendChild(outputDisplay)

      controller.setupTwoWayBindings()
    })

    afterEach(() => {
      if (linkedInput && linkedInput.parentNode) {
        linkedInput.parentNode.removeChild(linkedInput)
      }
      if (outputDisplay && outputDisplay.parentNode) {
        outputDisplay.parentNode.removeChild(outputDisplay)
      }
    })

    test("updates both linked input and output when slider changes", () => {
      const rangeInput = element.querySelector('input[type="range"]')

      rangeInput.value = "80"
      controller.updateStyle({ target: rangeInput })

      expect(linkedInput.value).toBe("80")
      expect(outputDisplay.textContent).toBe("80%")
    })

    test("updates both slider and output when linked input changes", () => {
      const rangeInput = element.querySelector('input[type="range"]')

      linkedInput.value = "30"
      linkedInput.dispatchEvent(new Event('input', { bubbles: true }))

      expect(rangeInput.value).toBe("30")
      expect(outputDisplay.textContent).toBe("30%")
    })
  })
})
