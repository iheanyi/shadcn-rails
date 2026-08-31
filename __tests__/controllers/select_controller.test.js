import { Application } from "@hotwired/stimulus"
import SelectController from "../../app/assets/javascripts/shadcn/controllers/select_controller.ts"
import { setupController, cleanupController, click, nextFrame, keydown } from '../helpers/stimulus-test-helper.js'

describe("SelectController", () => {
  let application
  let element
  let controller

  afterEach(() => {
    cleanupController(application)
  })

  describe("basic rendering and initialization", () => {
    const basicHTML = `
      <div data-controller="shadcn--select"
           data-shadcn--select-value-value="">
        <button data-shadcn--select-target="trigger"
                role="combobox"
                aria-expanded="false"
                data-action="click->shadcn--select#toggle keydown->shadcn--select#handleKeydown">
          <span data-shadcn--select-target="display">Select...</span>
        </button>
        <input type="hidden" data-shadcn--select-target="input" name="fruit">
        <div data-shadcn--select-target="content"
             role="listbox"
             hidden
             data-state="closed">
          <div data-shadcn--select-target="item"
               data-value="apple"
               role="option"
               tabindex="-1"
               data-action="click->shadcn--select#select">Apple</div>
          <div data-shadcn--select-target="item"
               data-value="banana"
               role="option"
               tabindex="-1"
               data-action="click->shadcn--select#select">Banana</div>
          <div data-shadcn--select-target="item"
               data-value="cherry"
               role="option"
               tabindex="-1"
               data-action="click->shadcn--select#select">Cherry</div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SelectController, basicHTML, 'shadcn--select')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with closed state", () => {
      expect(controller.isOpen).toBe(false)
    })

    test("initializes with empty value", () => {
      expect(controller.valueValue).toBe("")
    })

    test("content is hidden by default", () => {
      expect(controller.contentTarget.hidden).toBe(true)
      expect(controller.contentTarget.dataset.state).toBe("closed")
    })

    test("trigger has correct aria-expanded", () => {
      expect(controller.triggerTarget.getAttribute("aria-expanded")).toBe("false")
    })
  })

  describe("opening and closing", () => {
    const basicHTML = `
      <div data-controller="shadcn--select">
        <button data-shadcn--select-target="trigger"
                role="combobox"
                aria-expanded="false"
                data-action="click->shadcn--select#toggle keydown->shadcn--select#handleKeydown">
          <span data-shadcn--select-target="display">Select...</span>
        </button>
        <div data-shadcn--select-target="content"
             role="listbox"
             hidden
             data-state="closed">
          <div data-shadcn--select-target="item"
               data-value="apple"
               tabindex="-1"
               data-action="click->shadcn--select#select">Apple</div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SelectController, basicHTML, 'shadcn--select')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("opens on toggle", () => {
      controller.toggle()

      expect(controller.isOpen).toBe(true)
      expect(controller.contentTarget.hidden).toBe(false)
      expect(controller.contentTarget.dataset.state).toBe("open")
      expect(controller.triggerTarget.getAttribute("aria-expanded")).toBe("true")
    })

    test("closes when already open", () => {
      controller.open()
      controller.toggle()

      expect(controller.isOpen).toBe(false)
      expect(controller.triggerTarget.getAttribute("aria-expanded")).toBe("false")
    })

    test("dispatches opened event on open", () => {
      let eventFired = false
      element.addEventListener("shadcn--select:opened", () => {
        eventFired = true
      })

      controller.open()
      expect(eventFired).toBe(true)
    })

    test("dispatches closed event on close", () => {
      let eventFired = false
      element.addEventListener("shadcn--select:closed", () => {
        eventFired = true
      })

      controller.open()
      controller.close()
      expect(eventFired).toBe(true)
    })

    test("opens with trigger click", async () => {
      click(controller.triggerTarget)
      await nextFrame()

      expect(controller.isOpen).toBe(true)
    })

    test("does not re-open if already open", () => {
      controller.open()
      const dispatchSpy = jest.spyOn(controller, 'dispatch')

      controller.open()

      // Should not dispatch opened event again
      expect(dispatchSpy).not.toHaveBeenCalledWith("opened")
    })
  })

  describe("item selection", () => {
    const selectionHTML = `
      <div data-controller="shadcn--select"
           data-shadcn--select-value-value="">
        <button data-shadcn--select-target="trigger"
                data-placeholder
                data-action="click->shadcn--select#toggle">
          <span data-shadcn--select-target="display">Select...</span>
        </button>
        <input type="hidden" data-shadcn--select-target="input" name="fruit">
        <div data-shadcn--select-target="content"
             hidden
             data-state="closed">
          <div data-shadcn--select-target="item"
               data-value="apple"
               tabindex="-1"
               data-action="click->shadcn--select#select">Apple</div>
          <div data-shadcn--select-target="item"
               data-value="banana"
               tabindex="-1"
               data-action="click->shadcn--select#select">Banana</div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SelectController, selectionHTML, 'shadcn--select')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("selects item when clicked", async () => {
      controller.open()
      const appleItem = controller.itemTargets[0]
      click(appleItem)
      await nextFrame()

      expect(controller.valueValue).toBe("apple")
    })

    test("updates display text on selection", async () => {
      controller.open()
      const appleItem = controller.itemTargets[0]
      click(appleItem)
      await nextFrame()

      expect(controller.displayTarget.textContent).toBe("Apple")
    })

    test("updates hidden input value on selection", async () => {
      controller.open()
      const bananaItem = controller.itemTargets[1]
      click(bananaItem)
      await nextFrame()

      expect(controller.inputTarget.value).toBe("banana")
    })

    test("removes placeholder state from trigger after selection", async () => {
      controller.open()
      const appleItem = controller.itemTargets[0]
      click(appleItem)
      await nextFrame()

      expect(controller.triggerTarget.hasAttribute("data-placeholder")).toBe(false)
    })

    test("restores placeholder state when value is cleared", () => {
      controller.triggerTarget.removeAttribute("data-placeholder")

      controller.selectByValue("")

      expect(controller.triggerTarget.hasAttribute("data-placeholder")).toBe(true)
    })

    test("closes dropdown after selection", async () => {
      controller.open()
      const appleItem = controller.itemTargets[0]
      click(appleItem)
      await nextFrame()

      expect(controller.isOpen).toBe(false)
    })

    test("dispatches change event on selection", async () => {
      let eventDetail = null
      element.addEventListener("shadcn--select:change", (e) => {
        eventDetail = e.detail
      })

      controller.open()
      const appleItem = controller.itemTargets[0]
      click(appleItem)
      await nextFrame()

      expect(eventDetail).not.toBeNull()
      expect(eventDetail.value).toBe("apple")
    })

    test("updates aria-selected on items", async () => {
      controller.open()
      const appleItem = controller.itemTargets[0]
      const bananaItem = controller.itemTargets[1]
      click(appleItem)
      await nextFrame()

      expect(appleItem.getAttribute("aria-selected")).toBe("true")
      expect(bananaItem.getAttribute("aria-selected")).toBe("false")
    })
  })

  describe("disabled items", () => {
    const disabledHTML = `
      <div data-controller="shadcn--select">
        <button data-shadcn--select-target="trigger">
          <span data-shadcn--select-target="display">Select...</span>
        </button>
        <input type="hidden" data-shadcn--select-target="input" name="fruit">
        <div data-shadcn--select-target="content">
          <div data-shadcn--select-target="item"
               data-value="apple"
               data-action="click->shadcn--select#select">Apple</div>
          <div data-shadcn--select-target="item"
               data-value="banana"
               data-disabled
               data-action="click->shadcn--select#select">Banana (Disabled)</div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SelectController, disabledHTML, 'shadcn--select')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("does not select disabled item", async () => {
      controller.open()
      const disabledItem = controller.itemTargets[1]
      click(disabledItem)
      await nextFrame()

      expect(controller.valueValue).toBe("")
    })

    test("enabledItems excludes disabled items", () => {
      const enabled = controller.enabledItems
      expect(enabled.length).toBe(1)
      expect(enabled[0].dataset.value).toBe("apple")
    })
  })

  describe("keyboard navigation", () => {
    const keyboardHTML = `
      <div data-controller="shadcn--select"
           data-action="keydown.escape->shadcn--select#close">
        <button data-shadcn--select-target="trigger"
                data-action="click->shadcn--select#toggle keydown->shadcn--select#handleKeydown">
          <span data-shadcn--select-target="display">Select...</span>
        </button>
        <input type="hidden" data-shadcn--select-target="input" name="fruit">
        <div data-shadcn--select-target="content"
             hidden
             data-state="closed">
          <div data-shadcn--select-target="item"
               data-value="apple"
               tabindex="-1"
               data-action="click->shadcn--select#select">Apple</div>
          <div data-shadcn--select-target="item"
               data-value="banana"
               tabindex="-1"
               data-action="click->shadcn--select#select">Banana</div>
          <div data-shadcn--select-target="item"
               data-value="cherry"
               tabindex="-1"
               data-action="click->shadcn--select#select">Cherry</div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SelectController, keyboardHTML, 'shadcn--select')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("opens on Enter key when closed", () => {
      controller.handleKeydown({ key: "Enter", preventDefault: jest.fn() })

      expect(controller.isOpen).toBe(true)
    })

    test("opens on Space key when closed", () => {
      controller.handleKeydown({ key: " ", preventDefault: jest.fn() })

      expect(controller.isOpen).toBe(true)
    })

    test("opens on ArrowDown key when closed", () => {
      controller.handleKeydown({ key: "ArrowDown", preventDefault: jest.fn() })

      expect(controller.isOpen).toBe(true)
    })

    test("closes on Escape key when open", () => {
      controller.open()
      controller.handleKeydown({ key: "Escape", preventDefault: jest.fn() })

      expect(controller.isOpen).toBe(false)
    })

    test("navigates down with ArrowDown", () => {
      controller.open()
      controller.focusedIndex = 0

      controller.handleKeydown({ key: "ArrowDown", preventDefault: jest.fn() })

      expect(controller.focusedIndex).toBe(1)
    })

    test("navigates up with ArrowUp", () => {
      controller.open()
      controller.focusedIndex = 1

      controller.handleKeydown({ key: "ArrowUp", preventDefault: jest.fn() })

      expect(controller.focusedIndex).toBe(0)
    })

    test("wraps to first item from last with ArrowDown", () => {
      controller.open()
      controller.focusedIndex = 2

      controller.handleKeydown({ key: "ArrowDown", preventDefault: jest.fn() })

      expect(controller.focusedIndex).toBe(0)
    })

    test("wraps to last item from first with ArrowUp", () => {
      controller.open()
      controller.focusedIndex = 0

      controller.handleKeydown({ key: "ArrowUp", preventDefault: jest.fn() })

      expect(controller.focusedIndex).toBe(2)
    })

    test("jumps to first item with Home", () => {
      controller.open()
      controller.focusedIndex = 2

      controller.handleKeydown({ key: "Home", preventDefault: jest.fn() })

      expect(controller.focusedIndex).toBe(0)
    })

    test("jumps to last item with End", () => {
      controller.open()
      controller.focusedIndex = 0

      controller.handleKeydown({ key: "End", preventDefault: jest.fn() })

      expect(controller.focusedIndex).toBe(2)
    })

    test("selects focused item on Enter", async () => {
      controller.open()
      controller.focusedIndex = 1

      controller.handleKeydown({ key: "Enter", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.valueValue).toBe("banana")
    })

    test("selects focused item on Space", async () => {
      controller.open()
      controller.focusedIndex = 0

      controller.handleKeydown({ key: " ", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.valueValue).toBe("apple")
    })
  })

  describe("initial value", () => {
    const initialValueHTML = `
      <div data-controller="shadcn--select"
           data-shadcn--select-value-value="banana">
        <button data-shadcn--select-target="trigger">
          <span data-shadcn--select-target="display">Select...</span>
        </button>
        <input type="hidden" data-shadcn--select-target="input" name="fruit">
        <div data-shadcn--select-target="content">
          <div data-shadcn--select-target="item"
               data-value="apple"
               data-action="click->shadcn--select#select">Apple</div>
          <div data-shadcn--select-target="item"
               data-value="banana"
               data-action="click->shadcn--select#select">Banana</div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SelectController, initialValueHTML, 'shadcn--select')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with pre-set value", () => {
      expect(controller.valueValue).toBe("banana")
    })

    test("sets display text from initial value", () => {
      expect(controller.displayTarget.textContent).toBe("Banana")
    })

    test("marks correct item as selected on init", () => {
      const bananaItem = controller.itemTargets[1]
      expect(bananaItem.getAttribute("aria-selected")).toBe("true")
    })

    test("focuses current value item when opening", async () => {
      const focusSpy = jest.spyOn(controller.itemTargets[1], 'focus')
      controller.open()
      await nextFrame()

      expect(focusSpy).toHaveBeenCalled()
    })
  })

  describe("click outside", () => {
    const clickOutsideHTML = `
      <div data-controller="shadcn--select">
        <button data-shadcn--select-target="trigger"
                data-action="click->shadcn--select#toggle">
          <span data-shadcn--select-target="display">Select...</span>
        </button>
        <div data-shadcn--select-target="content" hidden>
          <div data-shadcn--select-target="item" data-value="apple">Apple</div>
        </div>
      </div>
      <div id="outside">Outside Element</div>
    `

    beforeEach(async () => {
      const setup = await setupController(SelectController, clickOutsideHTML, 'shadcn--select')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("closes when clicking outside", async () => {
      controller.open()
      await nextFrame()

      const outsideElement = document.getElementById("outside")
      // Call clickOutside directly since stimulus-use doesn't trigger via DOM events in jsdom
      controller.clickOutside({ target: outsideElement })
      await nextFrame()

      expect(controller.isOpen).toBe(false)
    })

    test("does not close when clicking inside", async () => {
      controller.open()
      await nextFrame()

      // Clicking inside the controller element should not close via clickOutside
      // The clickOutside method from stimulus-use only fires for clicks outside the element
      // So we verify the select stays open after an internal click action
      click(controller.contentTarget)
      await nextFrame()

      expect(controller.isOpen).toBe(true)
    })
  })

  describe("trigger width synchronization", () => {
    const widthSyncHTML = `
      <div data-controller="shadcn--select">
        <button data-shadcn--select-target="trigger"
                style="width: 200px;"
                data-action="click->shadcn--select#toggle">
          <span data-shadcn--select-target="display">Select...</span>
        </button>
        <div data-shadcn--select-target="content" hidden>
          <div data-shadcn--select-target="item" data-value="apple">Apple</div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SelectController, widthSyncHTML, 'shadcn--select')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("uses Floating UI sameWidth for trigger width synchronization", async () => {
      controller.open()
      await nextFrame()

      // Floating UI with sameWidth option sets width directly on the content element
      // The mock calls the size middleware's apply function
      expect(controller.contentTarget.style.position).toBe("absolute")
    })
  })

  describe("check icon visibility", () => {
    const checkIconHTML = `
      <div data-controller="shadcn--select">
        <button data-shadcn--select-target="trigger">
          <span data-shadcn--select-target="display">Select...</span>
        </button>
        <input type="hidden" data-shadcn--select-target="input" name="fruit">
        <div data-shadcn--select-target="content">
          <div data-shadcn--select-target="item"
               data-value="apple"
               data-action="click->shadcn--select#select">
            Apple
            <span data-shadcn--select-target="checkIcon" style="opacity: 0;">✓</span>
          </div>
          <div data-shadcn--select-target="item"
               data-value="banana"
               data-action="click->shadcn--select#select">
            Banana
            <span data-shadcn--select-target="checkIcon" style="opacity: 0;">✓</span>
          </div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SelectController, checkIconHTML, 'shadcn--select')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("shows check icon for selected item", async () => {
      controller.open()
      const appleItem = controller.itemTargets[0]
      click(appleItem)
      await nextFrame()

      const checkIcon = appleItem.querySelector('[data-shadcn--select-target="checkIcon"]')
      expect(checkIcon.style.opacity).toBe("1")
    })

    test("hides check icon for non-selected items", async () => {
      controller.open()
      const appleItem = controller.itemTargets[0]
      click(appleItem)
      await nextFrame()

      const bananaItem = controller.itemTargets[1]
      const checkIcon = bananaItem.querySelector('[data-shadcn--select-target="checkIcon"]')
      expect(checkIcon.style.opacity).toBe("0")
    })
  })

  describe("programmatic value change", () => {
    const programmaticHTML = `
      <div data-controller="shadcn--select">
        <button data-shadcn--select-target="trigger">
          <span data-shadcn--select-target="display">Select...</span>
        </button>
        <input type="hidden" data-shadcn--select-target="input" name="fruit">
        <div data-shadcn--select-target="content">
          <div data-shadcn--select-target="item" data-value="apple">Apple</div>
          <div data-shadcn--select-target="item" data-value="banana">Banana</div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SelectController, programmaticHTML, 'shadcn--select')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("selectByValue updates value without dispatch when specified", () => {
      let eventFired = false
      element.addEventListener("shadcn--select:change", () => {
        eventFired = true
      })

      controller.selectByValue("apple", false)

      expect(controller.valueValue).toBe("apple")
      expect(eventFired).toBe(false)
    })

    test("selectByValue dispatches change when dispatch is true", () => {
      let eventDetail = null
      element.addEventListener("shadcn--select:change", (e) => {
        eventDetail = e.detail
      })

      controller.selectByValue("banana", true)

      expect(eventDetail).not.toBeNull()
      expect(eventDetail.value).toBe("banana")
    })
  })

  describe("disconnect cleanup", () => {
    const disconnectHTML = `
      <div data-controller="shadcn--select">
        <button data-shadcn--select-target="trigger">Select...</button>
        <div data-shadcn--select-target="content" hidden>
          <div data-shadcn--select-target="item" data-value="apple">Apple</div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(SelectController, disconnectHTML, 'shadcn--select')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("cleans up event listeners on disconnect", () => {
      controller.open()

      const closeSpy = jest.spyOn(controller, 'close')
      controller.disconnect()

      expect(closeSpy).toHaveBeenCalled()
    })
  })
})
