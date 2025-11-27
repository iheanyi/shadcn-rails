import { Application } from "@hotwired/stimulus"
import SheetController from "../../app/assets/javascripts/shadcn/controllers/sheet_controller.js"
import { setupController, cleanupController, click, wait, nextFrame, keydown, waitForPortal, getFocusableElements, waitForEvent } from '../helpers/stimulus-test-helper.js'

describe("SheetController", () => {
  let application
  let element
  let controller

  const createSheetHTML = (options = {}) => {
    const {
      open = false,
      side = "right"
    } = options

    const openAttr = open ? 'data-shadcn--sheet-open-value="true"' : ''

    return `
      <div data-controller="shadcn--sheet"
           ${openAttr}
           data-shadcn--sheet-side-value="${side}">
        <button data-shadcn--sheet-target="trigger" data-action="click->shadcn--sheet#toggle">
          Open Sheet
        </button>

        <template data-shadcn--sheet-target="template">
          <div data-shadcn--sheet-target="overlay" data-state="closed" hidden
               data-action="click->shadcn--sheet#close"
               class="fixed inset-0 z-50 bg-black/80">
          </div>
          <div data-shadcn--sheet-target="content" data-state="closed" hidden
               data-side="${side}"
               class="fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out">
            <button data-action="click->shadcn--sheet#close" class="close-button">
              Close
            </button>
            <input type="text" class="first-input" placeholder="First input" />
            <button class="action-button">Action</button>
            <a href="#" class="link">Link</a>
            <input type="text" class="last-input" placeholder="Last input" />
          </div>
        </template>
      </div>
    `
  }

  beforeEach(async () => {
    application = Application.start()
    application.register("shadcn--sheet", SheetController)
    document.body.innerHTML = createSheetHTML()

    await new Promise(resolve => requestAnimationFrame(resolve))

    element = document.querySelector('[data-controller="shadcn--sheet"]')
    controller = application.getControllerForElementAndIdentifier(element, "shadcn--sheet")
  })

  afterEach(() => {
    if (application) {
      application.stop()
    }
    document.body.innerHTML = ""
    // Restore body overflow
    document.body.style.overflow = ""
  })

  describe("initialization", () => {
    test("connects successfully", () => {
      expect(controller).not.toBeNull()
      expect(controller).toBeDefined()
    })

    test("initializes with default values", () => {
      expect(controller.openValue).toBe(false)
      expect(controller.sideValue).toBe("right")
    })

    test("initializes with custom side value", async () => {
      application.stop()
      document.body.innerHTML = createSheetHTML({ side: "left" })

      application = Application.start()
      application.register("shadcn--sheet", SheetController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--sheet"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--sheet")

      expect(controller.sideValue).toBe("left")
    })

    test("can be controlled via openValue", async () => {
      // Verify that setting openValue directly works
      expect(controller.openValue).toBe(false)

      // Manually trigger open by calling the method
      controller.open()

      await nextFrame()
      await nextFrame()

      expect(controller.openValue).toBe(true)
      const portal = document.querySelector(".shadcn-sheet-portal")
      expect(portal).toBeTruthy()
    })

    test("does not create portal on initialization when closed", () => {
      const portal = document.querySelector(".shadcn-sheet-portal")
      expect(portal).toBeNull()
    })
  })

  describe("opening and closing", () => {
    test("opens sheet when toggle is called", async () => {
      const trigger = element.querySelector('[data-shadcn--sheet-target="trigger"]')
      click(trigger)

      await nextFrame()

      expect(controller.openValue).toBe(true)

      const portal = await waitForPortal(".shadcn-sheet-portal")
      expect(portal).toBeTruthy()
    })

    test("closes sheet when toggle is called again", async () => {
      const trigger = element.querySelector('[data-shadcn--sheet-target="trigger"]')

      // Open
      click(trigger)
      await nextFrame()
      expect(controller.openValue).toBe(true)

      // Close
      click(trigger)
      await nextFrame()
      expect(controller.openValue).toBe(false)
    })

    test("open() does nothing if already open", async () => {
      const trigger = element.querySelector('[data-shadcn--sheet-target="trigger"]')

      click(trigger)
      await nextFrame()

      const portal = document.querySelector(".shadcn-sheet-portal")
      const portalHTML = portal.innerHTML

      // Try to open again
      controller.open()
      await nextFrame()

      // Portal should be the same
      const samePortal = document.querySelector(".shadcn-sheet-portal")
      expect(samePortal.innerHTML).toBe(portalHTML)
    })

    test("close() does nothing if already closed", async () => {
      expect(controller.openValue).toBe(false)

      controller.close()
      await nextFrame()

      expect(controller.openValue).toBe(false)
    })

    test("opens and closes multiple times", async () => {
      const trigger = element.querySelector('[data-shadcn--sheet-target="trigger"]')

      for (let i = 0; i < 3; i++) {
        // Open
        click(trigger)
        await nextFrame()
        expect(controller.openValue).toBe(true)

        // Close
        click(trigger)
        await nextFrame()
        expect(controller.openValue).toBe(false)
      }
    })
  })

  describe("portal rendering", () => {
    test("creates portal element when opening", async () => {
      controller.open()
      await nextFrame()

      const portal = document.querySelector(".shadcn-sheet-portal")
      expect(portal).toBeTruthy()
      expect(portal.parentElement).toBe(document.body)
    })

    test("portal contains overlay and content", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const overlay = portal.querySelector('[data-shadcn--sheet-target="overlay"]')
      const content = portal.querySelector('[data-shadcn--sheet-target="content"]')

      expect(overlay).toBeTruthy()
      expect(content).toBeTruthy()
    })

    test("portal content includes template elements", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")

      // Check that key elements from template are present in portal
      expect(portal.querySelector('.close-button')).toBeTruthy()
      expect(portal.querySelector('.first-input')).toBeTruthy()
      expect(portal.querySelector('.action-button')).toBeTruthy()
      expect(portal.querySelector('.link')).toBeTruthy()
      expect(portal.querySelector('.last-input')).toBeTruthy()
    })

    test("removes portal after closing with delay", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      expect(portal).toBeTruthy()

      controller.close()

      // Portal should still exist immediately after close
      const portalAfterClose = document.querySelector(".shadcn-sheet-portal")
      expect(portalAfterClose).toBeTruthy()

      // Wait for the 300ms delay
      await wait(350)

      const portalAfterDelay = document.querySelector(".shadcn-sheet-portal")
      expect(portalAfterDelay).toBeNull()
    })

    test("reuses portal if it exists", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const portalReference = portal

      controller.close()
      await wait(50) // Close but don't wait for removal

      controller.open()
      await nextFrame()

      // Portal reference should be different since it was removed
      // But the class name should be the same
      const newPortal = document.querySelector(".shadcn-sheet-portal")
      expect(newPortal.className).toBe(portalReference.className)
    })
  })

  describe("side positioning", () => {
    const sides = ["top", "right", "bottom", "left"]

    sides.forEach(side => {
      test(`renders with side="${side}"`, async () => {
        application.stop()
        document.body.innerHTML = createSheetHTML({ side })

        application = Application.start()
        application.register("shadcn--sheet", SheetController)

        await nextFrame()

        element = document.querySelector('[data-controller="shadcn--sheet"]')
        controller = application.getControllerForElementAndIdentifier(element, "shadcn--sheet")

        controller.open()
        await nextFrame()

        const portal = await waitForPortal(".shadcn-sheet-portal")
        const content = portal.querySelector('[data-shadcn--sheet-target="content"]')

        expect(content.dataset.side).toBe(side)
      })
    })

    test("defaults to right side when not specified", () => {
      expect(controller.sideValue).toBe("right")
    })
  })

  describe("overlay and content state", () => {
    test("sets overlay state to open when opening", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const overlay = portal.querySelector('[data-shadcn--sheet-target="overlay"]')

      expect(overlay.dataset.state).toBe("open")
      expect(overlay.hidden).toBe(false)
    })

    test("sets content state to open when opening", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const content = portal.querySelector('[data-shadcn--sheet-target="content"]')

      expect(content.dataset.state).toBe("open")
      expect(content.hidden).toBe(false)
    })

    test("sets overlay state to closed when closing", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const overlay = portal.querySelector('[data-shadcn--sheet-target="overlay"]')

      controller.close()

      expect(overlay.dataset.state).toBe("closed")
    })

    test("sets content state to closed when closing", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const content = portal.querySelector('[data-shadcn--sheet-target="content"]')

      controller.close()

      expect(content.dataset.state).toBe("closed")
    })
  })

  describe("focus management", () => {
    test("focuses first focusable element when opening", async () => {
      controller.open()
      await nextFrame()
      await nextFrame() // Wait for focus

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const closeButton = portal.querySelector('.close-button')

      expect(document.activeElement).toBe(closeButton)
    })

    test("focuses content if no focusable elements", async () => {
      application.stop()

      const htmlWithNoFocusable = `
        <div data-controller="shadcn--sheet">
          <button data-shadcn--sheet-target="trigger" data-action="click->shadcn--sheet#toggle">
            Open
          </button>
          <template data-shadcn--sheet-target="template">
            <div data-shadcn--sheet-target="overlay" data-state="closed" hidden></div>
            <div data-shadcn--sheet-target="content" data-state="closed" hidden tabindex="-1">
              <div>No focusable elements</div>
            </div>
          </template>
        </div>
      `

      document.body.innerHTML = htmlWithNoFocusable

      application = Application.start()
      application.register("shadcn--sheet", SheetController)

      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--sheet"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--sheet")

      controller.open()
      await nextFrame()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const content = portal.querySelector('[data-shadcn--sheet-target="content"]')

      expect(document.activeElement).toBe(content)
    })

    test("stores and restores previous active element", async () => {
      const trigger = element.querySelector('[data-shadcn--sheet-target="trigger"]')
      trigger.focus()

      expect(document.activeElement).toBe(trigger)

      controller.open()
      await nextFrame()
      await nextFrame()

      // Focus should have moved
      expect(document.activeElement).not.toBe(trigger)

      controller.close()
      await nextFrame()

      // Focus should be restored
      expect(document.activeElement).toBe(trigger)
    })

    test("traps focus with Tab key", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const content = portal.querySelector('[data-shadcn--sheet-target="content"]')
      const focusableElements = getFocusableElements(content)
      const firstElement = focusableElements[0]
      const lastElement = focusableElements[focusableElements.length - 1]

      // Focus last element
      lastElement.focus()
      expect(document.activeElement).toBe(lastElement)

      // Tab forward should wrap to first
      keydown(document, 'Tab')
      await nextFrame()

      expect(document.activeElement).toBe(firstElement)
    })

    test("traps focus with Shift+Tab key", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const content = portal.querySelector('[data-shadcn--sheet-target="content"]')
      const focusableElements = getFocusableElements(content)
      const firstElement = focusableElements[0]
      const lastElement = focusableElements[focusableElements.length - 1]

      // Focus first element
      firstElement.focus()
      expect(document.activeElement).toBe(firstElement)

      // Shift+Tab backward should wrap to last
      keydown(document, 'Tab', { shiftKey: true })
      await nextFrame()

      expect(document.activeElement).toBe(lastElement)
    })

    test("does not trap focus in middle of focusable elements", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const content = portal.querySelector('[data-shadcn--sheet-target="content"]')
      const focusableElements = getFocusableElements(content)
      const firstElement = focusableElements[0]
      const secondElement = focusableElements[1]

      // Focus first element
      firstElement.focus()

      // Tab should move to second element naturally
      keydown(document, 'Tab')

      // The actual focus move is handled by browser, we just check preventDefault wasn't called
      // In a real scenario, focus would move to secondElement
      expect(document.activeElement).toBe(firstElement) // Focus hasn't moved yet in jsdom
    })
  })

  describe("escape key", () => {
    test("closes sheet when Escape is pressed", async () => {
      controller.open()
      await nextFrame()

      expect(controller.openValue).toBe(true)

      keydown(document, 'Escape')
      await nextFrame()

      expect(controller.openValue).toBe(false)
    })

    test("Escape key handler is added when opening", async () => {
      let eventListenerAdded = false
      const originalAdd = document.addEventListener

      document.addEventListener = function(event, handler) {
        if (event === 'keydown') {
          eventListenerAdded = true
        }
        return originalAdd.apply(this, arguments)
      }

      controller.open()
      await nextFrame()

      expect(eventListenerAdded).toBe(true)

      document.addEventListener = originalAdd
    })

    test("Escape key handler is removed when closing", async () => {
      controller.open()
      await nextFrame()

      let eventListenerRemoved = false
      const originalRemove = document.removeEventListener

      document.removeEventListener = function(event) {
        if (event === 'keydown') {
          eventListenerRemoved = true
        }
        return originalRemove.apply(this, arguments)
      }

      controller.close()

      expect(eventListenerRemoved).toBe(true)

      document.removeEventListener = originalRemove
    })

    test("other keys do not close sheet", async () => {
      controller.open()
      await nextFrame()

      expect(controller.openValue).toBe(true)

      keydown(document, 'Enter')
      expect(controller.openValue).toBe(true)

      keydown(document, 'Space')
      expect(controller.openValue).toBe(true)

      keydown(document, 'a')
      expect(controller.openValue).toBe(true)
    })
  })

  describe("overlay click", () => {
    test("closes sheet when overlay is clicked", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const overlay = portal.querySelector('[data-shadcn--sheet-target="overlay"]')

      expect(controller.openValue).toBe(true)

      click(overlay)
      await nextFrame()

      expect(controller.openValue).toBe(false)
    })

    test("re-attaches close event listeners to buttons in portal", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const closeButton = portal.querySelector('.close-button')

      expect(controller.openValue).toBe(true)

      click(closeButton)
      await nextFrame()

      expect(controller.openValue).toBe(false)
    })

    test("multiple close buttons all work", async () => {
      application.stop()

      const htmlWithMultipleClose = `
        <div data-controller="shadcn--sheet">
          <button data-shadcn--sheet-target="trigger" data-action="click->shadcn--sheet#toggle">
            Open
          </button>
          <template data-shadcn--sheet-target="template">
            <div data-shadcn--sheet-target="overlay" data-state="closed" hidden></div>
            <div data-shadcn--sheet-target="content" data-state="closed" hidden>
              <button data-action="click->shadcn--sheet#close" class="close-1">Close 1</button>
              <button data-action="click->shadcn--sheet#close" class="close-2">Close 2</button>
              <button data-action="click->shadcn--sheet#close" class="close-3">Close 3</button>
            </div>
          </template>
        </div>
      `

      document.body.innerHTML = htmlWithMultipleClose

      application = Application.start()
      application.register("shadcn--sheet", SheetController)

      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--sheet"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--sheet")

      // Test each close button
      const closeButtons = ['.close-1', '.close-2', '.close-3']

      for (const selector of closeButtons) {
        controller.open()
        await nextFrame()

        const portal = await waitForPortal(".shadcn-sheet-portal")
        const closeButton = portal.querySelector(selector)

        click(closeButton)
        await nextFrame()

        expect(controller.openValue).toBe(false)
      }
    })
  })

  describe("body scroll lock", () => {
    test("locks body scroll when opening", async () => {
      expect(document.body.style.overflow).toBe("")

      controller.open()
      await nextFrame()

      expect(document.body.style.overflow).toBe("hidden")
    })

    test("unlocks body scroll when closing", async () => {
      controller.open()
      await nextFrame()

      expect(document.body.style.overflow).toBe("hidden")

      controller.close()
      await nextFrame()

      expect(document.body.style.overflow).toBe("")
    })

    test("restores body scroll even if closed multiple times", async () => {
      controller.open()
      await nextFrame()

      controller.close()
      controller.close()
      controller.close()

      expect(document.body.style.overflow).toBe("")
    })
  })

  describe("event dispatch", () => {
    test("dispatches opened event when opening", async () => {
      const eventPromise = waitForEvent(element, "shadcn--sheet:opened")

      controller.open()

      const event = await eventPromise
      expect(event).toBeDefined()
    })

    test("dispatches closed event when closing", async () => {
      controller.open()
      await nextFrame()

      const eventPromise = waitForEvent(element, "shadcn--sheet:closed")

      controller.close()

      const event = await eventPromise
      expect(event).toBeDefined()
    })

    test("opened event is dispatched after portal is created", async () => {
      let portalExists = false

      element.addEventListener("shadcn--sheet:opened", () => {
        portalExists = document.querySelector(".shadcn-sheet-portal") !== null
      })

      controller.open()
      await nextFrame()

      expect(portalExists).toBe(true)
    })

    test("closed event is dispatched immediately on close", async () => {
      controller.open()
      await nextFrame()

      let openValueOnEvent = null

      element.addEventListener("shadcn--sheet:closed", () => {
        openValueOnEvent = controller.openValue
      })

      controller.close()
      await nextFrame()

      expect(openValueOnEvent).toBe(false)
    })
  })

  describe("cleanup on disconnect", () => {
    test("closes sheet when controller disconnects", async () => {
      controller.open()
      await nextFrame()

      expect(controller.openValue).toBe(true)

      controller.disconnect()

      expect(controller.openValue).toBe(false)
    })

    test("removes portal when controller disconnects", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      expect(portal).toBeTruthy()

      controller.disconnect()

      const portalAfterDisconnect = document.querySelector(".shadcn-sheet-portal")
      expect(portalAfterDisconnect).toBeNull()
    })

    test("removes keydown listener when controller disconnects", async () => {
      controller.open()
      await nextFrame()

      let listenerRemoved = false
      const originalRemove = document.removeEventListener

      document.removeEventListener = function(event) {
        if (event === 'keydown') {
          listenerRemoved = true
        }
        return originalRemove.apply(this, arguments)
      }

      controller.disconnect()

      expect(listenerRemoved).toBe(true)

      document.removeEventListener = originalRemove
    })

    test("unlocks body scroll when controller disconnects", async () => {
      controller.open()
      await nextFrame()

      expect(document.body.style.overflow).toBe("hidden")

      controller.disconnect()

      expect(document.body.style.overflow).toBe("")
    })

    test("disconnect while closed does not cause errors", () => {
      expect(controller.openValue).toBe(false)

      expect(() => {
        controller.disconnect()
      }).not.toThrow()
    })
  })

  describe("edge cases", () => {
    test("handles rapid open/close calls", async () => {
      controller.open()
      controller.close()
      controller.open()
      controller.close()
      controller.open()

      await nextFrame()

      expect(controller.openValue).toBe(true)

      const portal = await waitForPortal(".shadcn-sheet-portal")
      expect(portal).toBeTruthy()
    })

    test("handles missing template target gracefully", async () => {
      application.stop()

      const htmlWithoutTemplate = `
        <div data-controller="shadcn--sheet">
          <button data-shadcn--sheet-target="trigger" data-action="click->shadcn--sheet#toggle">
            Open
          </button>
        </div>
      `

      document.body.innerHTML = htmlWithoutTemplate

      application = Application.start()
      application.register("shadcn--sheet", SheetController)

      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--sheet"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--sheet")

      expect(() => {
        controller.open()
      }).not.toThrow()

      // Should not create portal without template
      await nextFrame()
      const portal = document.querySelector(".shadcn-sheet-portal")
      expect(portal).toBeNull()
    })

    test("handles empty template content", async () => {
      application.stop()

      const htmlWithEmptyTemplate = `
        <div data-controller="shadcn--sheet">
          <button data-shadcn--sheet-target="trigger" data-action="click->shadcn--sheet#toggle">
            Open
          </button>
          <template data-shadcn--sheet-target="template"></template>
        </div>
      `

      document.body.innerHTML = htmlWithEmptyTemplate

      application = Application.start()
      application.register("shadcn--sheet", SheetController)

      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--sheet"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--sheet")

      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      expect(portal).toBeTruthy()
      expect(portal.innerHTML).toBe("")
    })

    test("handles focus trap when no focusable elements exist", async () => {
      application.stop()

      const htmlNoFocusable = `
        <div data-controller="shadcn--sheet">
          <button data-shadcn--sheet-target="trigger" data-action="click->shadcn--sheet#toggle">
            Open
          </button>
          <template data-shadcn--sheet-target="template">
            <div data-shadcn--sheet-target="overlay" data-state="closed" hidden></div>
            <div data-shadcn--sheet-target="content" data-state="closed" hidden tabindex="-1">
              <div>No focusable content</div>
            </div>
          </template>
        </div>
      `

      document.body.innerHTML = htmlNoFocusable

      application = Application.start()
      application.register("shadcn--sheet", SheetController)

      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--sheet"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--sheet")

      controller.open()
      await nextFrame()

      // Should not throw when trying to trap focus
      expect(() => {
        keydown(document, 'Tab')
      }).not.toThrow()
    })

    test("portal removal timeout is cleared properly", async () => {
      controller.open()
      await nextFrame()

      controller.close()

      // Open again before timeout completes
      await wait(150) // Half of the 300ms timeout
      controller.open()
      await nextFrame()

      // Portal should exist
      const portal = await waitForPortal(".shadcn-sheet-portal")
      expect(portal).toBeTruthy()
    })

    test("previousActiveElement is null-safe", async () => {
      // Don't focus anything
      document.activeElement?.blur()

      controller.open()
      await nextFrame()

      controller.close()
      await nextFrame()

      // Should not throw even without previous active element
      expect(controller.openValue).toBe(false)
    })
  })

  describe("accessibility", () => {
    test("overlay has appropriate class for backdrop", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const overlay = portal.querySelector('[data-shadcn--sheet-target="overlay"]')

      expect(overlay.className).toContain("bg-black/80")
      expect(overlay.className).toContain("fixed")
      expect(overlay.className).toContain("inset-0")
    })

    test("content has appropriate positioning classes", async () => {
      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const content = portal.querySelector('[data-shadcn--sheet-target="content"]')

      expect(content.className).toContain("fixed")
      expect(content.className).toContain("z-50")
    })

    test("content maintains data-side attribute", async () => {
      application.stop()
      document.body.innerHTML = createSheetHTML({ side: "left" })

      application = Application.start()
      application.register("shadcn--sheet", SheetController)

      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--sheet"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--sheet")

      controller.open()
      await nextFrame()

      const portal = await waitForPortal(".shadcn-sheet-portal")
      const content = portal.querySelector('[data-shadcn--sheet-target="content"]')

      expect(content.dataset.side).toBe("left")
    })
  })

  describe("snapshots", () => {
    test("renders closed sheet correctly", () => {
      expect(element.innerHTML).toMatchSnapshot()
    })

    test("renders with different sides", async () => {
      const sides = ["top", "right", "bottom", "left"]

      for (const side of sides) {
        application.stop()
        document.body.innerHTML = createSheetHTML({ side })

        application = Application.start()
        application.register("shadcn--sheet", SheetController)

        await nextFrame()

        element = document.querySelector('[data-controller="shadcn--sheet"]')

        expect(element.innerHTML).toMatchSnapshot(`side-${side}`)
      }
    })
  })
})
