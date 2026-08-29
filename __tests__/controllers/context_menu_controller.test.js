import { Application } from "@hotwired/stimulus"
import ContextMenuController from "../../app/assets/javascripts/shadcn/controllers/context_menu_controller.ts"
import { setupController, cleanupController, click, nextFrame, wait } from '../helpers/stimulus-test-helper.js'

describe("ContextMenuController", () => {
  let application
  let element
  let controller

  afterEach(() => {
    cleanupController(application)
  })

  describe("basic rendering and initialization", () => {
    const basicHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger"
             data-action="contextmenu->shadcn--context-menu#show">
          Right click here
        </div>
        <div data-shadcn--context-menu-target="content" hidden>
          <button data-shadcn--context-menu-target="item"
                  data-action="click->shadcn--context-menu#selectItem">Item 1</button>
          <button data-shadcn--context-menu-target="item"
                  data-action="click->shadcn--context-menu#selectItem">Item 2</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, basicHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with closed state", () => {
      expect(controller.openValue).toBe(false)
    })

    test("initializes focusedIndex to -1", () => {
      expect(controller.focusedIndex).toBe(-1)
    })

    test("content is hidden initially", () => {
      expect(controller.contentTarget.hidden).toBe(true)
    })

    test("has trigger target", () => {
      expect(controller.hasTriggerTarget).toBe(true)
    })

    test("has content target", () => {
      expect(controller.hasContentTarget).toBe(true)
    })

    test("has item targets", () => {
      expect(controller.itemTargets.length).toBe(2)
    })
  })

  describe("show functionality", () => {
    const showHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger"
             data-action="contextmenu->shadcn--context-menu#show">
          Right click here
        </div>
        <div data-shadcn--context-menu-target="content" hidden style="position: fixed;">
          <button data-shadcn--context-menu-target="item"
                  data-action="click->shadcn--context-menu#selectItem">Item 1</button>
          <button data-shadcn--context-menu-target="item"
                  data-action="click->shadcn--context-menu#selectItem">Item 2</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, showHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("sets openValue to true", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      expect(controller.openValue).toBe(true)
    })

    test("prevents default on event", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)

      expect(event.preventDefault).toHaveBeenCalled()
    })

    test("stores mouse position", async () => {
      const event = { preventDefault: jest.fn(), clientX: 150, clientY: 200 }
      controller.show(event)

      expect(controller.mouseX).toBe(150)
      expect(controller.mouseY).toBe(200)
    })

    test("shows content", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      expect(controller.contentTarget.hidden).toBe(false)
    })

    test("sets content data-state to open", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      expect(controller.contentTarget.dataset.state).toBe("open")
    })

    test("dispatches opened event", async () => {
      let eventFired = false
      element.addEventListener("shadcn--context-menu:opened", () => {
        eventFired = true
      })

      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      expect(eventFired).toBe(true)
    })

    test("focuses first item on show", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      expect(controller.focusedIndex).toBe(0)
    })
  })

  describe("hide functionality", () => {
    const hideHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger">Trigger</div>
        <div data-shadcn--context-menu-target="content" hidden style="position: fixed;">
          <button data-shadcn--context-menu-target="item">Item 1</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, hideHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("sets openValue to false", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      controller.hide()
      await nextFrame()

      expect(controller.openValue).toBe(false)
    })

    test("sets content data-state to closed", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      controller.hide()
      await nextFrame()

      expect(controller.contentTarget.dataset.state).toBe("closed")
    })

    test("dispatches closed event", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      let eventFired = false
      element.addEventListener("shadcn--context-menu:closed", () => {
        eventFired = true
      })

      controller.hide()
      await nextFrame()

      expect(eventFired).toBe(true)
    })

    test("resets focusedIndex to -1", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      controller.hide()
      await nextFrame()

      expect(controller.focusedIndex).toBe(-1)
    })

    test("does nothing if already closed", async () => {
      let eventFired = false
      element.addEventListener("shadcn--context-menu:closed", () => {
        eventFired = true
      })

      controller.hide()
      await nextFrame()

      expect(eventFired).toBe(false)
    })

    test("close() is an alias for hide()", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      controller.close()
      await nextFrame()

      expect(controller.openValue).toBe(false)
    })
  })

  describe("item selection", () => {
    const selectHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger">Trigger</div>
        <div data-shadcn--context-menu-target="content" hidden style="position: fixed;">
          <button data-shadcn--context-menu-target="item"
                  data-action="click->shadcn--context-menu#selectItem">Item 1</button>
          <button data-shadcn--context-menu-target="item"
                  data-action="click->shadcn--context-menu#selectItem"
                  data-disabled>Disabled Item</button>
          <button data-shadcn--context-menu-target="item"
                  data-action="click->shadcn--context-menu#selectItem">Item 3</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, selectHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("dispatches select event with item", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      let selectedItem = null
      element.addEventListener("shadcn--context-menu:select", (e) => {
        selectedItem = e.detail.item
      })

      const item = controller.itemTargets[0]
      controller.selectItem({ currentTarget: item })
      await nextFrame()

      expect(selectedItem).toBe(item)
    })

    test("closes menu after selection", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      const item = controller.itemTargets[0]
      controller.selectItem({ currentTarget: item })
      await nextFrame()

      expect(controller.openValue).toBe(false)
    })

    test("does not select disabled items", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      let selectFired = false
      element.addEventListener("shadcn--context-menu:select", () => {
        selectFired = true
      })

      const disabledItem = controller.itemTargets[1]
      controller.selectItem({ currentTarget: disabledItem })
      await nextFrame()

      expect(selectFired).toBe(false)
    })

    test("enabled items getter filters disabled items", () => {
      const enabledItems = controller.enabledItems
      expect(enabledItems.length).toBe(2)
    })
  })

  describe("keyboard navigation", () => {
    const keyboardHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger">Trigger</div>
        <div data-shadcn--context-menu-target="content" hidden style="position: fixed;">
          <button data-shadcn--context-menu-target="item">Item 1</button>
          <button data-shadcn--context-menu-target="item" data-disabled>Disabled</button>
          <button data-shadcn--context-menu-target="item">Item 3</button>
          <button data-shadcn--context-menu-target="item">Item 4</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, keyboardHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller

      // Open the menu first
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()
    })

    test("ArrowDown moves to next item", async () => {
      // Already at first item (index 0) from show()
      controller.handleKeydown({ key: "ArrowDown", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.focusedIndex).toBe(1)
    })

    test("ArrowDown wraps to first item", async () => {
      // Move to last enabled item
      controller.focusedIndex = 2 // Last enabled item (index 2 in enabledItems)
      controller.handleKeydown({ key: "ArrowDown", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.focusedIndex).toBe(0)
    })

    test("ArrowUp moves to previous item", async () => {
      controller.focusedIndex = 1
      controller.handleKeydown({ key: "ArrowUp", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.focusedIndex).toBe(0)
    })

    test("ArrowUp wraps to last item from first", async () => {
      controller.focusedIndex = 0
      controller.handleKeydown({ key: "ArrowUp", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.focusedIndex).toBe(2) // Last enabled item
    })

    test("Home moves to first item", async () => {
      controller.focusedIndex = 2
      controller.handleKeydown({ key: "Home", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.focusedIndex).toBe(0)
    })

    test("End moves to last item", async () => {
      controller.focusedIndex = 0
      controller.handleKeydown({ key: "End", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.focusedIndex).toBe(2) // Last enabled item
    })

    test("Escape closes the menu", async () => {
      controller.handleKeydown({ key: "Escape", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openValue).toBe(false)
    })

    test("Enter triggers click on focused item", async () => {
      const enabledItems = controller.enabledItems
      const clickSpy = jest.spyOn(enabledItems[0], 'click')

      controller.focusedIndex = 0
      controller.handleKeydown({ key: "Enter", preventDefault: jest.fn() })
      await nextFrame()

      expect(clickSpy).toHaveBeenCalled()
    })

    test("Space triggers click on focused item", async () => {
      const enabledItems = controller.enabledItems
      const clickSpy = jest.spyOn(enabledItems[0], 'click')

      controller.focusedIndex = 0
      controller.handleKeydown({ key: " ", preventDefault: jest.fn() })
      await nextFrame()

      expect(clickSpy).toHaveBeenCalled()
    })

    test("prevents default on navigation keys", () => {
      const preventDefault = jest.fn()

      controller.handleKeydown({ key: "ArrowDown", preventDefault })
      expect(preventDefault).toHaveBeenCalled()

      preventDefault.mockClear()
      controller.handleKeydown({ key: "ArrowUp", preventDefault })
      expect(preventDefault).toHaveBeenCalled()

      preventDefault.mockClear()
      controller.handleKeydown({ key: "Home", preventDefault })
      expect(preventDefault).toHaveBeenCalled()

      preventDefault.mockClear()
      controller.handleKeydown({ key: "End", preventDefault })
      expect(preventDefault).toHaveBeenCalled()
    })
  })

  describe("click outside handling", () => {
    const clickOutsideHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger">Trigger</div>
        <div data-shadcn--context-menu-target="content" hidden style="position: fixed;">
          <button data-shadcn--context-menu-target="item">Item 1</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, clickOutsideHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("closes on click outside", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      // Simulate click outside
      const outsideElement = document.createElement("div")
      document.body.appendChild(outsideElement)
      controller.clickOutside({ target: outsideElement })
      await nextFrame()

      expect(controller.openValue).toBe(false)

      document.body.removeChild(outsideElement)
    })

    test("does not close on click inside content", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      // Simulate click inside content
      controller.clickOutside({ target: controller.contentTarget })
      await nextFrame()

      expect(controller.openValue).toBe(true)
    })
  })

  describe("positioning", () => {
    const positionHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger">Trigger</div>
        <div data-shadcn--context-menu-target="content" hidden
             style="position: fixed; width: 200px; height: 150px;">
          <button data-shadcn--context-menu-target="item">Item 1</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, positionHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("positions content at mouse location via Floating UI", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 150 }
      controller.show(event)
      await nextFrame()

      const content = controller.contentTarget
      // Floating UI positionAtPoint sets fixed positioning with computed coordinates
      expect(content.style.position).toBe("fixed")
      expect(content.style.left).toMatch(/^\d+px$/)
      expect(content.style.top).toMatch(/^\d+px$/)
    })

    test("positions content with minimum offset from edges", async () => {
      const event = { preventDefault: jest.fn(), clientX: 5, clientY: 5 }
      controller.show(event)
      await nextFrame()

      const content = controller.contentTarget
      // Should be at least 8px from edge
      expect(parseInt(content.style.left)).toBeGreaterThanOrEqual(8)
      expect(parseInt(content.style.top)).toBeGreaterThanOrEqual(8)
    })
  })

  describe("disconnect cleanup", () => {
    const disconnectHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger">Trigger</div>
        <div data-shadcn--context-menu-target="content" hidden style="position: fixed;">
          <button data-shadcn--context-menu-target="item">Item 1</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, disconnectHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("hides menu on disconnect", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      controller.disconnect()
      await nextFrame()

      expect(controller.openValue).toBe(false)
    })
  })

  describe("without items", () => {
    const noItemsHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger">Trigger</div>
        <div data-shadcn--context-menu-target="content" hidden style="position: fixed;">
          <p>No items here</p>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, noItemsHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles empty items gracefully", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }

      expect(() => {
        controller.show(event)
      }).not.toThrow()

      expect(controller.openValue).toBe(true)
    })

    test("navigation does nothing with no items", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      expect(() => {
        controller.focusNextItem()
        controller.focusPreviousItem()
        controller.focusFirstItem()
        controller.focusLastItem()
      }).not.toThrow()
    })
  })

  describe("show without event", () => {
    const noEventHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger">Trigger</div>
        <div data-shadcn--context-menu-target="content" hidden style="position: fixed;">
          <button data-shadcn--context-menu-target="item">Item 1</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, noEventHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles show called without event", async () => {
      expect(() => {
        controller.show()
      }).not.toThrow()

      expect(controller.openValue).toBe(true)
      expect(controller.mouseX).toBe(0)
      expect(controller.mouseY).toBe(0)
    })
  })

  describe("scroll lock behavior", () => {
    const scrollLockHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger">Trigger</div>
        <div data-shadcn--context-menu-target="content" hidden style="position: fixed;">
          <button data-shadcn--context-menu-target="item">Item 1</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, scrollLockHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
      // Reset body overflow before each test
      document.body.style.overflow = ""
    })

    afterEach(() => {
      // Clean up body overflow after each test
      document.body.style.overflow = ""
    })

    test("locks body scroll when menu opens", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      expect(document.body.style.overflow).toBe("hidden")
    })

    test("stores original overflow value", async () => {
      document.body.style.overflow = "auto"

      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      expect(controller.originalOverflow).toBe("auto")
    })

    test("restores original overflow after hide animation", async () => {
      document.body.style.overflow = "auto"

      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      controller.hide()
      // Wait for animation timeout (100ms + buffer)
      await wait(150)

      expect(document.body.style.overflow).toBe("auto")
    })

    test("does not lock scroll if already locked", async () => {
      document.body.style.overflow = "hidden"

      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      // originalOverflow should be null because it was already hidden
      expect(controller.originalOverflow).toBe(null)
    })
  })

  describe("double right-click handling", () => {
    const doubleClickHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger">Trigger</div>
        <div data-shadcn--context-menu-target="content" hidden style="position: fixed;">
          <button data-shadcn--context-menu-target="item">Item 1</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, doubleClickHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
      document.body.style.overflow = ""
    })

    afterEach(() => {
      document.body.style.overflow = ""
      if (controller.hideTimeoutId) {
        clearTimeout(controller.hideTimeoutId)
      }
    })

    test("calling show() while menu is already open repositions instead of closing", async () => {
      // First right-click to open menu
      const event1 = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event1)
      await nextFrame()

      expect(controller.openValue).toBe(true)
      expect(controller.mouseX).toBe(100)
      expect(controller.mouseY).toBe(100)

      // Second right-click at different position while menu is open
      // This simulates what happens when the contextmenu event is triggered again
      const event2 = { preventDefault: jest.fn(), clientX: 250, clientY: 300 }
      controller.show(event2)
      await nextFrame()

      // Menu should still be open at the NEW position
      expect(controller.openValue).toBe(true)
      expect(controller.mouseX).toBe(250)
      expect(controller.mouseY).toBe(300)
      expect(controller.contentTarget.hidden).toBe(false)
      expect(controller.contentTarget.dataset.state).toBe("open")
    })

    test("handleContextMenu should NOT close menu when contextmenu event triggers on trigger element", async () => {
      // Open the menu first
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()
      await nextFrame() // Extra frame to ensure event listeners are attached

      expect(controller.openValue).toBe(true)

      // Simulate a contextmenu event on the trigger element
      // This is what happens when the user right-clicks again on the trigger
      // In the refactored code, contextmenu events are handled by handleContextMenu, not handleClickOutside
      controller.handleContextMenu({ type: "contextmenu", target: controller.triggerTarget })
      await nextFrame()

      // Menu should still be open because it was a contextmenu event on the trigger
      expect(controller.openValue).toBe(true)
    })

    test("clickOutside SHOULD close menu when regular click triggers on trigger element", async () => {
      // Open the menu first
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()
      await nextFrame() // Extra frame to ensure event listeners are attached

      expect(controller.openValue).toBe(true)

      // Simulate a regular click event on the trigger element
      controller.clickOutside({ type: "click", target: controller.triggerTarget })
      await nextFrame()

      // Menu should close because it was a regular click (not a contextmenu event)
      expect(controller.openValue).toBe(false)
    })

    test("cancels pending hide timeout when showing again", async () => {
      const event1 = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event1)
      await nextFrame()

      // Start hiding (this sets hideTimeoutId)
      controller.hide()
      await nextFrame()

      expect(controller.hideTimeoutId).not.toBe(null)

      // Immediately show again (should cancel the pending hide)
      const event2 = { preventDefault: jest.fn(), clientX: 200, clientY: 200 }
      controller.show(event2)
      await nextFrame()

      // The menu should be open at the new position
      expect(controller.openValue).toBe(true)
      expect(controller.mouseX).toBe(200)
      expect(controller.mouseY).toBe(200)
      expect(controller.contentTarget.hidden).toBe(false)
    })

    test("menu stays open after rapid open/close/open", async () => {
      // First open
      const event1 = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event1)
      await nextFrame()

      // Quickly close
      controller.hide()
      await nextFrame()

      // Immediately open again
      const event2 = { preventDefault: jest.fn(), clientX: 150, clientY: 150 }
      controller.show(event2)
      await nextFrame()

      // Wait longer than the animation timeout
      await wait(150)

      // Menu should still be open
      expect(controller.openValue).toBe(true)
      expect(controller.contentTarget.hidden).toBe(false)
    })

    test("hideTimeoutId is cleared after timeout completes", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      controller.hide()

      // Wait for timeout to complete
      await wait(150)

      expect(controller.hideTimeoutId).toBe(null)
    })
  })

  describe("animation delay on close", () => {
    const animationHTML = `
      <div data-controller="shadcn--context-menu"
           data-shadcn--context-menu-open-value="false">
        <div data-shadcn--context-menu-target="trigger">Trigger</div>
        <div data-shadcn--context-menu-target="content" hidden style="position: fixed;">
          <button data-shadcn--context-menu-target="item">Item 1</button>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ContextMenuController, animationHTML, 'shadcn--context-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    afterEach(() => {
      if (controller.hideTimeoutId) {
        clearTimeout(controller.hideTimeoutId)
      }
    })

    test("sets data-state to closed immediately", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      controller.hide()
      await nextFrame()

      // data-state should be set to closed immediately for CSS animation
      expect(controller.contentTarget.dataset.state).toBe("closed")
    })

    test("content remains visible during animation", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      controller.hide()
      await nextFrame()

      // Content should still be visible immediately after hide() is called
      // (hidden is set after the 100ms timeout)
      expect(controller.contentTarget.hidden).toBe(false)
    })

    test("content is hidden after animation completes", async () => {
      const event = { preventDefault: jest.fn(), clientX: 100, clientY: 100 }
      controller.show(event)
      await nextFrame()

      controller.hide()

      // Wait for animation to complete (100ms + buffer)
      await wait(150)

      expect(controller.contentTarget.hidden).toBe(true)
    })
  })
})
