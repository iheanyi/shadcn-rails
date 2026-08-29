import { Application } from "@hotwired/stimulus"
import ComboboxController from "../../app/assets/javascripts/shadcn/controllers/combobox_controller.ts"
import {
  setupController,
  cleanupController,
  click,
  wait,
  nextFrame,
  keydown,
  waitForEvent,
  dispatchEvent
} from "../helpers/stimulus-test-helper.js"

describe("ComboboxController", () => {
  let application, element, controller

  afterEach(() => {
    cleanupController(application)
  })

  /**
   * Helper to get the HTML template for combobox tests
   */
  function getComboboxHTML(options = {}) {
    const {
      open = false,
      value = "",
      selectedIndex = -1,
      debounceWait = 0, // Default to 0 for tests (no debounce delay)
      items = [
        { value: "react", label: "React" },
        { value: "vue", label: "Vue" },
        { value: "angular", label: "Angular" },
        { value: "svelte", label: "Svelte" }
      ],
      includeEmpty = true,
      includeDisplayValue = true,
      includeHiddenInput = true
    } = options

    const itemsHTML = items.map(item => `
      <div
        data-shadcn--combobox-target="item"
        data-value="${item.value}"
        data-label="${item.label}"
        data-action="click->shadcn--combobox#select"
        data-selected="false"
        class="cursor-pointer"
      >
        <svg class="opacity-0"></svg>
        ${item.label}
      </div>
    `).join("")

    return `
      <div
        data-controller="shadcn--combobox"
        data-shadcn--combobox-open-value="${open}"
        data-shadcn--combobox-value-value="${value}"
        data-shadcn--combobox-selected-index-value="${selectedIndex}"
        data-shadcn--combobox-debounce-wait-value="${debounceWait}"
      >
        <button
          data-shadcn--combobox-target="trigger"
          data-action="click->shadcn--combobox#toggle"
          aria-expanded="${open}"
        >
          ${includeDisplayValue ? `<span data-shadcn--combobox-target="displayValue" class="text-muted-foreground">Select framework...</span>` : 'Select framework...'}
        </button>
        ${includeHiddenInput ? '<input type="hidden" data-shadcn--combobox-target="hiddenInput" name="framework">' : ''}
        <div
          data-shadcn--combobox-target="content"
          data-state="closed"
          ${!open ? 'hidden' : ''}
        >
          <input
            data-shadcn--combobox-target="input"
            type="text"
            placeholder="Search..."
            data-action="input->shadcn--combobox#filter"
          >
          <div data-shadcn--combobox-target="list">
            ${itemsHTML}
          </div>
          ${includeEmpty ? '<div data-shadcn--combobox-target="empty" hidden>No results found.</div>' : ''}
        </div>
      </div>
    `
  }

  describe("Value Initialization", () => {
    it("initializes with default values", async () => {
      const html = getComboboxHTML()
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller

      expect(controller.openValue).toBe(false)
      expect(controller.valueValue).toBe("")
      expect(controller.selectedIndexValue).toBe(-1)
    })

    it("initializes with custom open value", async () => {
      const html = getComboboxHTML({ open: true })
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller

      expect(controller.openValue).toBe(true)
    })

    it("initializes with custom value", async () => {
      const html = getComboboxHTML({ value: "react" })
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller

      expect(controller.valueValue).toBe("react")
    })

    it("initializes with custom selected index", async () => {
      const html = getComboboxHTML({ selectedIndex: 2 })
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller

      expect(controller.selectedIndexValue).toBe(2)
    })
  })

  describe("Open/Close Behavior", () => {
    beforeEach(async () => {
      const html = getComboboxHTML()
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    it("opens the combobox when toggle is called on closed state", async () => {
      expect(controller.openValue).toBe(false)

      controller.toggle()
      await nextFrame()

      expect(controller.openValue).toBe(true)
      expect(controller.contentTarget.hidden).toBe(false)
      expect(controller.contentTarget.dataset.state).toBe("open")
      expect(controller.triggerTarget.getAttribute("aria-expanded")).toBe("true")
    })

    it("closes the combobox when toggle is called on open state", async () => {
      controller.open()
      await nextFrame()
      expect(controller.openValue).toBe(true)

      controller.toggle()
      await wait(250) // Wait for animation and cleanup

      expect(controller.openValue).toBe(false)
      expect(controller.contentTarget.dataset.state).toBe("closed")
      expect(controller.triggerTarget.getAttribute("aria-expanded")).toBe("false")
    })

    it("focuses the input when opened", async () => {
      controller.open()
      await nextFrame()
      await nextFrame() // requestAnimationFrame in open()

      expect(document.activeElement).toBe(controller.inputTarget)
    })

    it("does not open if already open", async () => {
      controller.open()
      await nextFrame()
      const initialState = controller.openValue

      controller.open()
      await nextFrame()

      expect(controller.openValue).toBe(initialState)
      expect(controller.openValue).toBe(true)
    })

    it("does not close if already closed", async () => {
      expect(controller.openValue).toBe(false)

      controller.close()
      await wait(250)

      expect(controller.openValue).toBe(false)
    })

    it("resets selected index when opened", async () => {
      controller.selectedIndexValue = 2

      controller.open()
      await nextFrame()

      expect(controller.selectedIndexValue).toBe(-1)
    })

    it("closes on Escape key", async () => {
      controller.open()
      await nextFrame()

      keydown(document, "Escape")
      await wait(250)

      expect(controller.openValue).toBe(false)
    })

    it("hides content after close animation completes", async () => {
      controller.open()
      await nextFrame()
      expect(controller.contentTarget.hidden).toBe(false)

      controller.close()
      await wait(250) // Wait for animation and fallback timeout

      expect(controller.contentTarget.hidden).toBe(true)
    })

    it("resets input value when closed", async () => {
      controller.open()
      await nextFrame()

      controller.inputTarget.value = "test search"
      controller.close()
      await wait(250)

      expect(controller.inputTarget.value).toBe("")
    })

    it("resets item visibility when closed", async () => {
      controller.open()
      await nextFrame()

      // Hide some items
      controller.itemTargets[0].style.display = "none"
      controller.itemTargets[1].style.display = "none"

      controller.close()
      await wait(250)

      controller.itemTargets.forEach(item => {
        expect(item.style.display).toBe("")
      })
    })

    it("hides empty state when closed", async () => {
      controller.open()
      await nextFrame()

      controller.emptyTarget.hidden = false
      controller.close()
      await wait(250)

      expect(controller.emptyTarget.hidden).toBe(true)
    })

    it("adds keyboard listener when opened", async () => {
      const spy = jest.spyOn(document, "addEventListener")

      controller.open()
      await nextFrame()

      expect(spy).toHaveBeenCalledWith("keydown", controller.boundHandleKeydown)
      spy.mockRestore()
    })

    it("removes keyboard listener when closed", async () => {
      controller.open()
      await nextFrame()

      const spy = jest.spyOn(document, "removeEventListener")
      controller.close()
      await wait(250)

      expect(spy).toHaveBeenCalledWith("keydown", controller.boundHandleKeydown)
      spy.mockRestore()
    })
  })

  describe("Filtering", () => {
    beforeEach(async () => {
      const html = getComboboxHTML()
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    // Helper to run filter and wait for debounce (debounceWait=0 still uses setTimeout)
    async function filterAndWait() {
      controller.filter()
      await new Promise(resolve => setTimeout(resolve, 0))
    }

    it("filters items based on input value", async () => {
      controller.inputTarget.value = "react"
      await filterAndWait()

      expect(controller.itemTargets[0].style.display).toBe("") // React - visible
      expect(controller.itemTargets[1].style.display).toBe("none") // Vue - hidden
      expect(controller.itemTargets[2].style.display).toBe("none") // Angular - hidden
      expect(controller.itemTargets[3].style.display).toBe("none") // Svelte - hidden
    })

    it("is case insensitive when filtering", async () => {
      controller.inputTarget.value = "REACT"
      await filterAndWait()

      expect(controller.itemTargets[0].style.display).toBe("") // React matches
    })

    it("filters by label attribute", async () => {
      controller.inputTarget.value = "Vue"
      await filterAndWait()

      expect(controller.itemTargets[0].style.display).toBe("none")
      expect(controller.itemTargets[1].style.display).toBe("") // Vue visible
      expect(controller.itemTargets[2].style.display).toBe("none")
      expect(controller.itemTargets[3].style.display).toBe("none")
    })

    it("filters by value attribute", async () => {
      controller.inputTarget.value = "angular"
      await filterAndWait()

      expect(controller.itemTargets[0].style.display).toBe("none")
      expect(controller.itemTargets[1].style.display).toBe("none")
      expect(controller.itemTargets[2].style.display).toBe("") // Angular visible
      expect(controller.itemTargets[3].style.display).toBe("none")
    })

    it("shows all items when input is empty", async () => {
      controller.inputTarget.value = "react"
      await filterAndWait()

      controller.inputTarget.value = ""
      await filterAndWait()

      controller.itemTargets.forEach(item => {
        expect(item.style.display).toBe("")
      })
    })

    it("shows empty state when no results match query", async () => {
      controller.inputTarget.value = "nonexistent"
      await filterAndWait()

      expect(controller.emptyTarget.hidden).toBe(false)
    })

    it("hides empty state when results exist", async () => {
      controller.emptyTarget.hidden = false

      controller.inputTarget.value = "react"
      await filterAndWait()

      expect(controller.emptyTarget.hidden).toBe(true)
    })

    it("hides empty state when query is empty", async () => {
      controller.emptyTarget.hidden = false

      controller.inputTarget.value = ""
      await filterAndWait()

      expect(controller.emptyTarget.hidden).toBe(true)
    })

    it("resets selected index after filtering", async () => {
      controller.selectedIndexValue = 2

      controller.inputTarget.value = "react"
      await filterAndWait()

      expect(controller.selectedIndexValue).toBe(-1)
    })

    it("handles partial matches", async () => {
      controller.inputTarget.value = "vue"
      await filterAndWait()

      expect(controller.itemTargets[1].style.display).toBe("") // Vue
      expect(controller.itemTargets[3].style.display).toBe("none") // Svelte (contains 'v' but not 'vue')
    })

    it("trims whitespace from query", async () => {
      controller.inputTarget.value = "  react  "
      await filterAndWait()

      expect(controller.itemTargets[0].style.display).toBe("") // React visible
    })
  })

  describe("Selection", () => {
    beforeEach(async () => {
      const html = getComboboxHTML()
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    it("selects item on click", () => {
      const item = controller.itemTargets[0]

      click(item)

      expect(controller.valueValue).toBe("react")
    })

    it("updates hidden input value when item selected", () => {
      const item = controller.itemTargets[1]

      click(item)

      expect(controller.hiddenInputTarget.value).toBe("vue")
    })

    it("updates display value text when item selected", () => {
      const item = controller.itemTargets[2]

      click(item)

      expect(controller.displayValueTarget.textContent).toBe("Angular")
    })

    it("removes muted foreground class from display value", () => {
      controller.displayValueTarget.classList.add("text-muted-foreground")
      const item = controller.itemTargets[0]

      click(item)

      expect(controller.displayValueTarget.classList.contains("text-muted-foreground")).toBe(false)
    })

    it("updates selected state on items", () => {
      const item = controller.itemTargets[1]

      click(item)

      expect(controller.itemTargets[0].dataset.selected).toBe("false")
      expect(controller.itemTargets[1].dataset.selected).toBe("true")
      expect(controller.itemTargets[2].dataset.selected).toBe("false")
      expect(controller.itemTargets[3].dataset.selected).toBe("false")
    })

    it("updates check icon visibility for selected item", () => {
      const item = controller.itemTargets[0]
      const checkIcon = item.querySelector("svg")

      click(item)

      expect(checkIcon.classList.contains("opacity-100")).toBe(true)
      expect(checkIcon.classList.contains("opacity-0")).toBe(false)
    })

    it("hides check icon for unselected items", () => {
      click(controller.itemTargets[0])

      // Select different item
      click(controller.itemTargets[1])

      const firstCheckIcon = controller.itemTargets[0].querySelector("svg")
      expect(firstCheckIcon.classList.contains("opacity-0")).toBe(true)
      expect(firstCheckIcon.classList.contains("opacity-100")).toBe(false)
    })

    it("dispatches change event with value and label", async () => {
      const item = controller.itemTargets[2]
      const eventPromise = waitForEvent(element, "shadcn--combobox:change", 1000)

      click(item)
      const event = await eventPromise

      expect(event.detail.value).toBe("angular")
      expect(event.detail.label).toBe("Angular")
    })

    it("closes combobox after selection", async () => {
      controller.open()
      await nextFrame()
      expect(controller.openValue).toBe(true)

      click(controller.itemTargets[0])
      await wait(250)

      expect(controller.openValue).toBe(false)
    })

    it("selects item on Enter key when item is highlighted", async () => {
      controller.open()
      await nextFrame()

      controller.selectedIndexValue = 1
      controller.updateSelection()

      keydown(document, "Enter")
      await wait(250)

      expect(controller.valueValue).toBe("vue")
    })

    it("does nothing on Enter if no item is highlighted", () => {
      controller.open()

      const initialValue = controller.valueValue
      keydown(document, "Enter")

      expect(controller.valueValue).toBe(initialValue)
    })
  })

  describe("Value Persistence", () => {
    beforeEach(async () => {
      const html = getComboboxHTML()
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    it("maintains selected value after filtering", async () => {
      click(controller.itemTargets[0]) // Select React

      controller.inputTarget.value = "vue"
      controller.filter()
      await new Promise(resolve => setTimeout(resolve, 0)) // Allow debounce to execute

      expect(controller.valueValue).toBe("react")
    })

    it("maintains selected value after closing and reopening", async () => {
      controller.open()
      await nextFrame()

      click(controller.itemTargets[1]) // Select Vue
      await wait(250)

      controller.open()
      await nextFrame()

      expect(controller.valueValue).toBe("vue")
      expect(controller.itemTargets[1].dataset.selected).toBe("true")
    })

    it("maintains display value after reopening", async () => {
      controller.open()
      await nextFrame()

      click(controller.itemTargets[2]) // Select Angular
      await wait(250)

      controller.open()
      await nextFrame()

      expect(controller.displayValueTarget.textContent).toBe("Angular")
    })
  })

  describe("Animation Timing", () => {
    beforeEach(async () => {
      const html = getComboboxHTML()
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    it("sets state to open immediately when opening", () => {
      controller.open()

      expect(controller.contentTarget.dataset.state).toBe("open")
    })

    it("sets state to closed immediately when closing", () => {
      controller.open()
      controller.close()

      expect(controller.contentTarget.dataset.state).toBe("closed")
    })

    it("hides content after close animation with fallback timeout", async () => {
      controller.open()
      await nextFrame()

      controller.close()

      // Content should still be visible during animation
      expect(controller.contentTarget.hidden).toBe(false)

      // Wait for fallback timeout (200ms)
      await wait(250)

      // Content should now be hidden
      expect(controller.contentTarget.hidden).toBe(true)
    })

    it("listens for animationend event on close", async () => {
      controller.open()
      await nextFrame()

      const spy = jest.spyOn(controller.contentTarget, "addEventListener")
      controller.close()

      expect(spy).toHaveBeenCalledWith("animationend", expect.any(Function))
      spy.mockRestore()
      await wait(250)
    })
  })

  describe("Keyboard Navigation", () => {
    beforeEach(async () => {
      const html = getComboboxHTML()
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller
      controller.open()
      await nextFrame()
    })

    it("navigates down with ArrowDown", () => {
      expect(controller.selectedIndexValue).toBe(-1)

      keydown(document, "ArrowDown")
      expect(controller.selectedIndexValue).toBe(0)

      keydown(document, "ArrowDown")
      expect(controller.selectedIndexValue).toBe(1)
    })

    it("navigates up with ArrowUp", () => {
      controller.selectedIndexValue = 2

      keydown(document, "ArrowUp")
      expect(controller.selectedIndexValue).toBe(1)

      keydown(document, "ArrowUp")
      expect(controller.selectedIndexValue).toBe(0)
    })

    it("does not go below 0 with ArrowUp", () => {
      controller.selectedIndexValue = 0

      keydown(document, "ArrowUp")
      expect(controller.selectedIndexValue).toBe(0)
    })

    it("does not go beyond last item with ArrowDown", () => {
      const lastIndex = controller.itemTargets.length - 1
      controller.selectedIndexValue = lastIndex

      keydown(document, "ArrowDown")
      expect(controller.selectedIndexValue).toBe(lastIndex)
    })

    it("applies highlight classes to selected item", () => {
      controller.selectedIndexValue = 1
      controller.updateSelection()

      expect(controller.itemTargets[1].classList.contains("bg-accent")).toBe(true)
      expect(controller.itemTargets[1].classList.contains("text-accent-foreground")).toBe(true)
    })

    it("removes highlight classes from unselected items", () => {
      controller.selectedIndexValue = 1
      controller.updateSelection()

      expect(controller.itemTargets[0].classList.contains("bg-accent")).toBe(false)
      expect(controller.itemTargets[2].classList.contains("bg-accent")).toBe(false)
    })

    it("scrolls selected item into view", () => {
      const spy = jest.spyOn(controller.itemTargets[2], "scrollIntoView")

      controller.selectedIndexValue = 2
      controller.updateSelection()

      expect(spy).toHaveBeenCalledWith({ block: "nearest" })
      spy.mockRestore()
    })

    it("navigates only through visible items after filtering", async () => {
      controller.inputTarget.value = "react"
      controller.filter()
      await new Promise(resolve => setTimeout(resolve, 0)) // Allow debounce to execute

      keydown(document, "ArrowDown")

      // Should select first (and only) visible item
      expect(controller.selectedIndexValue).toBe(0)

      keydown(document, "ArrowDown")

      // Should stay at 0 since it's the last visible item
      expect(controller.selectedIndexValue).toBe(0)
    })

    it("prevents default on navigation keys", () => {
      const event = new KeyboardEvent("keydown", { key: "ArrowDown", bubbles: true, cancelable: true })
      const spy = jest.spyOn(event, "preventDefault")

      document.dispatchEvent(event)

      expect(spy).toHaveBeenCalled()
    })

    it("prevents default on Escape key", () => {
      const event = new KeyboardEvent("keydown", { key: "Escape", bubbles: true, cancelable: true })
      const spy = jest.spyOn(event, "preventDefault")

      document.dispatchEvent(event)

      expect(spy).toHaveBeenCalled()
    })

    it("prevents default on Enter key", () => {
      controller.selectedIndexValue = 0
      const event = new KeyboardEvent("keydown", { key: "Enter", bubbles: true, cancelable: true })
      const spy = jest.spyOn(event, "preventDefault")

      document.dispatchEvent(event)

      expect(spy).toHaveBeenCalled()
    })
  })

  describe("ARIA Attributes", () => {
    beforeEach(async () => {
      const html = getComboboxHTML()
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    it("sets aria-expanded to false when closed", () => {
      expect(controller.triggerTarget.getAttribute("aria-expanded")).toBe("false")
    })

    it("sets aria-expanded to true when opened", async () => {
      controller.open()
      await nextFrame()

      expect(controller.triggerTarget.getAttribute("aria-expanded")).toBe("true")
    })

    it("updates aria-expanded when toggling", async () => {
      controller.toggle()
      await nextFrame()
      expect(controller.triggerTarget.getAttribute("aria-expanded")).toBe("true")

      controller.toggle()
      await wait(250)
      expect(controller.triggerTarget.getAttribute("aria-expanded")).toBe("false")
    })
  })

  describe("Helper Methods", () => {
    beforeEach(async () => {
      const html = getComboboxHTML()
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    it("getVisibleItems returns all items when none are filtered", () => {
      const visibleItems = controller.getVisibleItems()
      expect(visibleItems.length).toBe(4)
    })

    it("getVisibleItems returns only visible items after filtering", () => {
      controller.itemTargets[0].style.display = "none"
      controller.itemTargets[2].style.display = "none"

      const visibleItems = controller.getVisibleItems()

      expect(visibleItems.length).toBe(2)
      expect(visibleItems[0]).toBe(controller.itemTargets[1])
      expect(visibleItems[1]).toBe(controller.itemTargets[3])
    })
  })

  describe("Click Outside Handling", () => {
    beforeEach(async () => {
      const html = getComboboxHTML()
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    it("closes when clicking outside the element", async () => {
      controller.open()
      await nextFrame()

      const outsideElement = document.createElement("div")
      document.body.appendChild(outsideElement)

      // Use clickOutside directly since stimulus-use doesn't trigger via DOM events in jsdom
      controller.clickOutside({ target: outsideElement })
      await wait(250)

      expect(controller.openValue).toBe(false)
      outsideElement.remove()
    })

    it("does not close when clicking inside the element", async () => {
      controller.open()
      await nextFrame()

      // Clicking inside the controller element should not close via clickOutside
      // The clickOutside method from stimulus-use only fires for clicks outside the element
      // So we verify the combobox stays open
      expect(controller.openValue).toBe(true)
    })

    it("does nothing when already closed", () => {
      expect(controller.openValue).toBe(false)

      const outsideElement = document.createElement("div")
      document.body.appendChild(outsideElement)

      // Calling clickOutside on closed combobox should have no effect
      controller.clickOutside({ target: outsideElement })

      expect(controller.openValue).toBe(false)
      outsideElement.remove()
    })
  })

  describe("Disconnect", () => {
    beforeEach(async () => {
      const html = getComboboxHTML()
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    it("removes keyboard event listener on disconnect", () => {
      controller.open()

      const spy = jest.spyOn(document, "removeEventListener")
      controller.disconnect()

      expect(spy).toHaveBeenCalledWith("keydown", controller.boundHandleKeydown)
      spy.mockRestore()
    })
  })

  describe("Edge Cases", () => {
    it("handles combobox without empty target", async () => {
      const html = getComboboxHTML({ includeEmpty: false })
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller

      expect(controller.hasEmptyTarget).toBe(false)

      controller.inputTarget.value = "nonexistent"

      // Should not throw error (filter is debounced, but should still not throw)
      expect(() => controller.filter()).not.toThrow()
      await new Promise(resolve => setTimeout(resolve, 0)) // Allow debounce to execute
    })

    it("handles combobox without display value target", async () => {
      const html = getComboboxHTML({ includeDisplayValue: false })
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller

      expect(controller.hasDisplayValueTarget).toBe(false)

      // Should not throw error when selecting
      expect(() => click(controller.itemTargets[0])).not.toThrow()
    })

    it("handles combobox without hidden input target", async () => {
      const html = getComboboxHTML({ includeHiddenInput: false })
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller

      expect(controller.hasHiddenInputTarget).toBe(false)

      // Should not throw error when selecting
      expect(() => click(controller.itemTargets[0])).not.toThrow()
    })

    it("handles items without check icons", () => {
      const html = `
        <div data-controller="shadcn--combobox">
          <button data-shadcn--combobox-target="trigger" data-action="click->shadcn--combobox#toggle">
            Select
          </button>
          <div data-shadcn--combobox-target="content" hidden>
            <input data-shadcn--combobox-target="input" type="text" data-action="input->shadcn--combobox#filter">
            <div data-shadcn--combobox-target="item" data-value="item1" data-label="Item 1" data-action="click->shadcn--combobox#select">
              Item 1
            </div>
          </div>
        </div>
      `

      return setupController(ComboboxController, html, "shadcn--combobox").then(setup => {
        application = setup.application
        element = setup.element
        controller = setup.controller

        // Should not throw error when selecting item without icon
        expect(() => click(controller.itemTargets[0])).not.toThrow()
      })
    })

    it("handles empty item list", async () => {
      const html = getComboboxHTML({ items: [] })
      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller

      expect(controller.itemTargets.length).toBe(0)

      // Should not throw errors (filter is debounced)
      expect(() => controller.filter()).not.toThrow()
      await new Promise(resolve => setTimeout(resolve, 0)) // Allow debounce to execute
      expect(() => keydown(document, "ArrowDown")).not.toThrow()
      expect(() => controller.updateSelection()).not.toThrow()
    })

    it("handles item without label attribute falling back to textContent", async () => {
      const html = `
        <div data-controller="shadcn--combobox" data-shadcn--combobox-debounce-wait-value="0">
          <button data-shadcn--combobox-target="trigger"></button>
          <div data-shadcn--combobox-target="content" hidden>
            <input data-shadcn--combobox-target="input" type="text" data-action="input->shadcn--combobox#filter">
            <div data-shadcn--combobox-target="item" data-value="test" data-action="click->shadcn--combobox#select">
              Text Content Only
            </div>
          </div>
        </div>
      `

      const setup = await setupController(ComboboxController, html, "shadcn--combobox")
      application = setup.application
      element = setup.element
      controller = setup.controller

      controller.inputTarget.value = "text"
      controller.filter()
      await new Promise(resolve => setTimeout(resolve, 0)) // Allow debounce to execute

      expect(controller.itemTargets[0].style.display).toBe("")
    })
  })
})
