import { Application } from "@hotwired/stimulus"
import RadioGroupController from "../../app/assets/javascripts/shadcn/controllers/radio_group_controller.ts"
import { setupController, cleanupController, click, nextFrame, keydown } from '../helpers/stimulus-test-helper.js'

describe("RadioGroupController", () => {
  let application
  let element
  let controller

  afterEach(() => {
    cleanupController(application)
  })

  describe("basic rendering and initialization", () => {
    const basicHTML = `
      <div data-controller="shadcn--radio-group"
           data-shadcn--radio-group-name-value="size"
           data-shadcn--radio-group-value-value=""
           role="radiogroup">
        <button data-shadcn--radio-group-target="item"
                data-value="small"
                role="radio"
                type="button"
                data-action="click->shadcn--radio-group#select keydown->shadcn--radio-group#handleKeydown">
          Small
          <span data-shadcn--radio-group-target="indicator" class="opacity-0"></span>
        </button>
        <button data-shadcn--radio-group-target="item"
                data-value="medium"
                role="radio"
                type="button"
                data-action="click->shadcn--radio-group#select keydown->shadcn--radio-group#handleKeydown">
          Medium
          <span data-shadcn--radio-group-target="indicator" class="opacity-0"></span>
        </button>
        <button data-shadcn--radio-group-target="item"
                data-value="large"
                role="radio"
                type="button"
                data-action="click->shadcn--radio-group#select keydown->shadcn--radio-group#handleKeydown">
          Large
          <span data-shadcn--radio-group-target="indicator" class="opacity-0"></span>
        </button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(RadioGroupController, basicHTML, 'shadcn--radio-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with empty value", () => {
      expect(controller.valueValue).toBe("")
    })

    test("initializes with name value", () => {
      expect(controller.nameValue).toBe("size")
    })

    test("initializes all items with aria-checked false", () => {
      controller.itemTargets.forEach(item => {
        expect(item.getAttribute("aria-checked")).toBe("false")
      })
    })

    test("initializes all items with data-state unchecked", () => {
      controller.itemTargets.forEach(item => {
        expect(item.dataset.state).toBe("unchecked")
      })
    })

    test("first enabled item is focusable when no value selected", () => {
      const firstItem = controller.itemTargets[0]
      expect(firstItem.getAttribute("tabindex")).toBe("0")
    })

    test("other items are not focusable initially", () => {
      const secondItem = controller.itemTargets[1]
      const thirdItem = controller.itemTargets[2]
      expect(secondItem.getAttribute("tabindex")).toBe("-1")
      expect(thirdItem.getAttribute("tabindex")).toBe("-1")
    })
  })

  describe("selection", () => {
    const selectionHTML = `
      <div data-controller="shadcn--radio-group"
           data-shadcn--radio-group-name-value="option"
           data-shadcn--radio-group-value-value="">
        <button data-shadcn--radio-group-target="item"
                data-value="one"
                role="radio"
                data-action="click->shadcn--radio-group#select">
          One
          <span data-shadcn--radio-group-target="indicator" class="opacity-0"></span>
        </button>
        <button data-shadcn--radio-group-target="item"
                data-value="two"
                role="radio"
                data-action="click->shadcn--radio-group#select">
          Two
          <span data-shadcn--radio-group-target="indicator" class="opacity-0"></span>
        </button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(RadioGroupController, selectionHTML, 'shadcn--radio-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("selects item when clicked", async () => {
      const firstItem = controller.itemTargets[0]
      click(firstItem)
      await nextFrame()

      expect(controller.valueValue).toBe("one")
    })

    test("updates aria-checked on selected item", async () => {
      const firstItem = controller.itemTargets[0]
      click(firstItem)
      await nextFrame()

      expect(firstItem.getAttribute("aria-checked")).toBe("true")
    })

    test("updates data-state on selected item", async () => {
      const firstItem = controller.itemTargets[0]
      click(firstItem)
      await nextFrame()

      expect(firstItem.dataset.state).toBe("checked")
    })

    test("makes selected item focusable", async () => {
      const secondItem = controller.itemTargets[1]
      click(secondItem)
      await nextFrame()

      expect(secondItem.getAttribute("tabindex")).toBe("0")
    })

    test("makes non-selected items non-focusable", async () => {
      const firstItem = controller.itemTargets[0]
      const secondItem = controller.itemTargets[1]
      click(secondItem)
      await nextFrame()

      expect(firstItem.getAttribute("tabindex")).toBe("-1")
    })

    test("deselects previous selection when new item selected", async () => {
      const firstItem = controller.itemTargets[0]
      const secondItem = controller.itemTargets[1]

      click(firstItem)
      await nextFrame()
      expect(firstItem.getAttribute("aria-checked")).toBe("true")

      click(secondItem)
      await nextFrame()
      expect(firstItem.getAttribute("aria-checked")).toBe("false")
      expect(secondItem.getAttribute("aria-checked")).toBe("true")
    })

    test("dispatches change event on selection", async () => {
      let eventDetail = null
      element.addEventListener("shadcn--radio-group:change", (e) => {
        eventDetail = e.detail
      })

      const firstItem = controller.itemTargets[0]
      click(firstItem)
      await nextFrame()

      expect(eventDetail).not.toBeNull()
      expect(eventDetail.value).toBe("one")
      expect(eventDetail.name).toBe("option")
    })

    test("dispatches native input event on selection", async () => {
      let inputEventFired = false
      element.addEventListener("input", () => {
        inputEventFired = true
      })

      const firstItem = controller.itemTargets[0]
      click(firstItem)
      await nextFrame()

      expect(inputEventFired).toBe(true)
    })
  })

  describe("indicator visibility", () => {
    const indicatorHTML = `
      <div data-controller="shadcn--radio-group"
           data-shadcn--radio-group-value-value="">
        <button data-shadcn--radio-group-target="item"
                data-value="a"
                data-action="click->shadcn--radio-group#select">
          A
          <span data-shadcn--radio-group-target="indicator" class="opacity-0"></span>
        </button>
        <button data-shadcn--radio-group-target="item"
                data-value="b"
                data-action="click->shadcn--radio-group#select">
          B
          <span data-shadcn--radio-group-target="indicator" class="opacity-0"></span>
        </button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(RadioGroupController, indicatorHTML, 'shadcn--radio-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("shows indicator for selected item", async () => {
      const firstItem = controller.itemTargets[0]
      click(firstItem)
      await nextFrame()

      const indicator = firstItem.querySelector('[data-shadcn--radio-group-target="indicator"]')
      expect(indicator.classList.contains("opacity-0")).toBe(false)
    })

    test("hides indicator for non-selected items", async () => {
      const firstItem = controller.itemTargets[0]
      const secondItem = controller.itemTargets[1]
      click(firstItem)
      await nextFrame()

      const indicator = secondItem.querySelector('[data-shadcn--radio-group-target="indicator"]')
      expect(indicator.classList.contains("opacity-0")).toBe(true)
    })
  })

  describe("keyboard navigation", () => {
    const keyboardHTML = `
      <div data-controller="shadcn--radio-group"
           data-shadcn--radio-group-value-value="">
        <button data-shadcn--radio-group-target="item"
                data-value="first"
                data-action="click->shadcn--radio-group#select keydown->shadcn--radio-group#handleKeydown">
          First
        </button>
        <button data-shadcn--radio-group-target="item"
                data-value="second"
                data-action="click->shadcn--radio-group#select keydown->shadcn--radio-group#handleKeydown">
          Second
        </button>
        <button data-shadcn--radio-group-target="item"
                data-value="third"
                data-action="click->shadcn--radio-group#select keydown->shadcn--radio-group#handleKeydown">
          Third
        </button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(RadioGroupController, keyboardHTML, 'shadcn--radio-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("navigates forward with ArrowDown", async () => {
      const firstItem = controller.itemTargets[0]
      const secondItem = controller.itemTargets[1]
      const focusSpy = jest.spyOn(secondItem, 'focus')

      controller.handleKeydown({
        key: "ArrowDown",
        preventDefault: jest.fn(),
        currentTarget: firstItem
      })
      await nextFrame()

      expect(focusSpy).toHaveBeenCalled()
      expect(controller.valueValue).toBe("second")
    })

    test("navigates forward with ArrowRight", async () => {
      const firstItem = controller.itemTargets[0]
      const secondItem = controller.itemTargets[1]
      const focusSpy = jest.spyOn(secondItem, 'focus')

      controller.handleKeydown({
        key: "ArrowRight",
        preventDefault: jest.fn(),
        currentTarget: firstItem
      })
      await nextFrame()

      expect(focusSpy).toHaveBeenCalled()
    })

    test("navigates backward with ArrowUp", async () => {
      const firstItem = controller.itemTargets[0]
      const secondItem = controller.itemTargets[1]
      const focusSpy = jest.spyOn(firstItem, 'focus')

      controller.handleKeydown({
        key: "ArrowUp",
        preventDefault: jest.fn(),
        currentTarget: secondItem
      })
      await nextFrame()

      expect(focusSpy).toHaveBeenCalled()
      expect(controller.valueValue).toBe("first")
    })

    test("navigates backward with ArrowLeft", async () => {
      const firstItem = controller.itemTargets[0]
      const secondItem = controller.itemTargets[1]
      const focusSpy = jest.spyOn(firstItem, 'focus')

      controller.handleKeydown({
        key: "ArrowLeft",
        preventDefault: jest.fn(),
        currentTarget: secondItem
      })
      await nextFrame()

      expect(focusSpy).toHaveBeenCalled()
    })

    test("wraps from last to first with ArrowDown", async () => {
      const firstItem = controller.itemTargets[0]
      const thirdItem = controller.itemTargets[2]
      const focusSpy = jest.spyOn(firstItem, 'focus')

      controller.handleKeydown({
        key: "ArrowDown",
        preventDefault: jest.fn(),
        currentTarget: thirdItem
      })
      await nextFrame()

      expect(focusSpy).toHaveBeenCalled()
    })

    test("wraps from first to last with ArrowUp", async () => {
      const firstItem = controller.itemTargets[0]
      const thirdItem = controller.itemTargets[2]
      const focusSpy = jest.spyOn(thirdItem, 'focus')

      controller.handleKeydown({
        key: "ArrowUp",
        preventDefault: jest.fn(),
        currentTarget: firstItem
      })
      await nextFrame()

      expect(focusSpy).toHaveBeenCalled()
    })

    test("selects current item with Space", async () => {
      const secondItem = controller.itemTargets[1]

      controller.handleKeydown({
        key: " ",
        preventDefault: jest.fn(),
        currentTarget: secondItem
      })
      await nextFrame()

      expect(controller.valueValue).toBe("second")
    })

    test("selects current item with Enter", async () => {
      const secondItem = controller.itemTargets[1]

      controller.handleKeydown({
        key: "Enter",
        preventDefault: jest.fn(),
        currentTarget: secondItem
      })
      await nextFrame()

      expect(controller.valueValue).toBe("second")
    })

    test("dispatches change event on keyboard navigation", async () => {
      let eventDetail = null
      element.addEventListener("shadcn--radio-group:change", (e) => {
        eventDetail = e.detail
      })

      const firstItem = controller.itemTargets[0]
      controller.handleKeydown({
        key: "ArrowDown",
        preventDefault: jest.fn(),
        currentTarget: firstItem
      })
      await nextFrame()

      expect(eventDetail).not.toBeNull()
      expect(eventDetail.value).toBe("second")
    })
  })

  describe("disabled items", () => {
    const disabledHTML = `
      <div data-controller="shadcn--radio-group"
           data-shadcn--radio-group-value-value="">
        <button data-shadcn--radio-group-target="item"
                data-value="enabled"
                data-action="click->shadcn--radio-group#select keydown->shadcn--radio-group#handleKeydown">
          Enabled
        </button>
        <button data-shadcn--radio-group-target="item"
                data-value="disabled"
                disabled
                data-action="click->shadcn--radio-group#select keydown->shadcn--radio-group#handleKeydown">
          Disabled
        </button>
        <button data-shadcn--radio-group-target="item"
                data-value="also-enabled"
                data-action="click->shadcn--radio-group#select keydown->shadcn--radio-group#handleKeydown">
          Also Enabled
        </button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(RadioGroupController, disabledHTML, 'shadcn--radio-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("does not select disabled item on click", async () => {
      const disabledItem = controller.itemTargets[1]
      click(disabledItem)
      await nextFrame()

      expect(controller.valueValue).toBe("")
    })

    test("enabledItems excludes disabled items", () => {
      const enabled = controller.enabledItems
      expect(enabled.length).toBe(2)
      expect(enabled.map(item => item.dataset.value)).toEqual(["enabled", "also-enabled"])
    })

    test("keyboard navigation skips disabled items", async () => {
      const firstItem = controller.itemTargets[0]
      const thirdItem = controller.itemTargets[2]
      const focusSpy = jest.spyOn(thirdItem, 'focus')

      controller.handleKeydown({
        key: "ArrowDown",
        preventDefault: jest.fn(),
        currentTarget: firstItem
      })
      await nextFrame()

      expect(focusSpy).toHaveBeenCalled()
      expect(controller.valueValue).toBe("also-enabled")
    })
  })

  describe("initial value", () => {
    const initialValueHTML = `
      <div data-controller="shadcn--radio-group"
           data-shadcn--radio-group-value-value="medium">
        <button data-shadcn--radio-group-target="item"
                data-value="small">Small</button>
        <button data-shadcn--radio-group-target="item"
                data-value="medium">Medium</button>
        <button data-shadcn--radio-group-target="item"
                data-value="large">Large</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(RadioGroupController, initialValueHTML, 'shadcn--radio-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with pre-set value", () => {
      expect(controller.valueValue).toBe("medium")
    })

    test("marks correct item as checked on init", () => {
      const mediumItem = controller.itemTargets[1]
      expect(mediumItem.getAttribute("aria-checked")).toBe("true")
      expect(mediumItem.dataset.state).toBe("checked")
    })

    test("selected item is focusable on init", () => {
      const mediumItem = controller.itemTargets[1]
      expect(mediumItem.getAttribute("tabindex")).toBe("0")
    })

    test("non-selected items are not focusable on init", () => {
      const smallItem = controller.itemTargets[0]
      const largeItem = controller.itemTargets[2]
      expect(smallItem.getAttribute("tabindex")).toBe("-1")
      expect(largeItem.getAttribute("tabindex")).toBe("-1")
    })
  })

  describe("programmatic value change", () => {
    const programmaticHTML = `
      <div data-controller="shadcn--radio-group"
           data-shadcn--radio-group-value-value="">
        <button data-shadcn--radio-group-target="item" data-value="x">X</button>
        <button data-shadcn--radio-group-target="item" data-value="y">Y</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(RadioGroupController, programmaticHTML, 'shadcn--radio-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("updates selection when valueValue changes", async () => {
      controller.valueValue = "y"
      await nextFrame()

      const yItem = controller.itemTargets[1]
      expect(yItem.getAttribute("aria-checked")).toBe("true")
    })

    test("valueValueChanged callback updates UI", async () => {
      controller.valueValue = "x"
      await nextFrame()

      const xItem = controller.itemTargets[0]
      const yItem = controller.itemTargets[1]
      expect(xItem.getAttribute("aria-checked")).toBe("true")
      expect(yItem.getAttribute("aria-checked")).toBe("false")
    })
  })

  describe("edge cases", () => {
    const edgeCaseHTML = `
      <div data-controller="shadcn--radio-group"
           data-shadcn--radio-group-value-value="">
        <button data-shadcn--radio-group-target="item"
                data-value="only"
                data-action="click->shadcn--radio-group#select keydown->shadcn--radio-group#handleKeydown">Only Option</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(RadioGroupController, edgeCaseHTML, 'shadcn--radio-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles single item gracefully", async () => {
      const onlyItem = controller.itemTargets[0]
      click(onlyItem)
      await nextFrame()

      expect(controller.valueValue).toBe("only")
    })

    test("keyboard navigation with single item stays on that item", async () => {
      const onlyItem = controller.itemTargets[0]
      const focusSpy = jest.spyOn(onlyItem, 'focus')

      controller.handleKeydown({
        key: "ArrowDown",
        preventDefault: jest.fn(),
        currentTarget: onlyItem
      })
      await nextFrame()

      expect(focusSpy).toHaveBeenCalled()
    })
  })

  describe("non-matching key handling", () => {
    const keyHandlingHTML = `
      <div data-controller="shadcn--radio-group"
           data-shadcn--radio-group-value-value="">
        <button data-shadcn--radio-group-target="item"
                data-value="a"
                data-action="keydown->shadcn--radio-group#handleKeydown">A</button>
        <button data-shadcn--radio-group-target="item"
                data-value="b"
                data-action="keydown->shadcn--radio-group#handleKeydown">B</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(RadioGroupController, keyHandlingHTML, 'shadcn--radio-group')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("ignores non-navigation keys", async () => {
      const firstItem = controller.itemTargets[0]
      const preventDefault = jest.fn()

      controller.handleKeydown({
        key: "Tab",
        preventDefault,
        currentTarget: firstItem
      })
      await nextFrame()

      expect(preventDefault).not.toHaveBeenCalled()
      expect(controller.valueValue).toBe("")
    })

    test("ignores letter keys", async () => {
      const firstItem = controller.itemTargets[0]
      const preventDefault = jest.fn()

      controller.handleKeydown({
        key: "a",
        preventDefault,
        currentTarget: firstItem
      })
      await nextFrame()

      expect(preventDefault).not.toHaveBeenCalled()
    })
  })
})
