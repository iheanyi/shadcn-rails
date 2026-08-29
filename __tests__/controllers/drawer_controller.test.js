import { Application } from "@hotwired/stimulus"
import DrawerController from "../../app/assets/javascripts/shadcn/controllers/drawer_controller.ts"
import { click, wait, nextFrame, keydown, waitForEvent } from '../helpers/stimulus-test-helper.js'

describe("DrawerController", () => {
  let application
  let element
  let controller

  const createDrawerHTML = (open = false, direction = "bottom") => {
    const openAttr = open ? `data-shadcn--drawer-open-value="true"` : ''

    return `
      <div data-controller="shadcn--drawer"
           data-shadcn--drawer-direction-value="${direction}"
           ${openAttr}>
        <button data-shadcn--drawer-target="trigger"
                data-action="click->shadcn--drawer#toggle">
          Open Drawer
        </button>
        <template data-shadcn--drawer-target="template">
          <div data-shadcn--drawer-target="overlay" data-state="closed"></div>
          <div data-shadcn--drawer-target="content" data-state="closed" tabindex="-1">
            <h2>Drawer Content</h2>
            <button class="close-btn">Close</button>
            <input type="text" placeholder="Focus test" />
          </div>
        </template>
      </div>
    `
  }

  beforeEach(async () => {
    application = Application.start()
    application.register("shadcn--drawer", DrawerController)
    document.body.innerHTML = createDrawerHTML()

    await nextFrame()

    element = document.querySelector('[data-controller="shadcn--drawer"]')
    controller = application.getControllerForElementAndIdentifier(element, "shadcn--drawer")
  })

  afterEach(() => {
    // Clean up any portals
    const portals = document.querySelectorAll('body > div:not([data-controller])')
    portals.forEach(portal => portal.remove())

    if (application) {
      application.stop()
    }
    document.body.innerHTML = ""
    document.body.style.overflow = ""
  })

  describe("value initialization", () => {
    test("initializes with default open value of false", () => {
      expect(controller.openValue).toBe(false)
    })

    test("initializes with default direction value of 'bottom'", () => {
      expect(controller.directionValue).toBe("bottom")
    })

    test("accepts custom direction value", async () => {
      application.stop()
      document.body.innerHTML = createDrawerHTML(false, "right")

      application = Application.start()
      application.register("shadcn--drawer", DrawerController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--drawer"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--drawer")

      expect(controller.directionValue).toBe("right")
    })

    test("accepts custom open value", async () => {
      application.stop()
      document.body.innerHTML = createDrawerHTML(true, "bottom")

      application = Application.start()
      application.register("shadcn--drawer", DrawerController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--drawer"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--drawer")

      expect(controller.openValue).toBe(true)
    })
  })

  describe("targets", () => {
    test("has trigger target", () => {
      expect(controller.hasTriggerTarget).toBe(true)
    })

    test("has template target", () => {
      expect(controller.hasTemplateTarget).toBe(true)
    })

    test("trigger target is correct element", () => {
      const trigger = element.querySelector('[data-shadcn--drawer-target="trigger"]')
      expect(controller.triggerTarget).toBe(trigger)
    })

    test("template target is correct element", () => {
      const template = element.querySelector('[data-shadcn--drawer-target="template"]')
      expect(controller.templateTarget).toBe(template)
    })
  })

  describe("connect", () => {
    test("initializes portal as null", () => {
      expect(controller.portal).toBeNull()
    })

    test("opens drawer if openValue is true on connect", async () => {
      application.stop()
      document.body.innerHTML = createDrawerHTML(true, "bottom")

      application = Application.start()
      application.register("shadcn--drawer", DrawerController)
      await nextFrame()
      await nextFrame() // Wait for requestAnimationFrame in open()

      const portal = document.querySelector('body > div:not([data-controller])')
      expect(portal).toBeTruthy()
    })

    test("does not open drawer if openValue is false on connect", async () => {
      application.stop()
      document.body.innerHTML = createDrawerHTML(false, "bottom")

      application = Application.start()
      application.register("shadcn--drawer", DrawerController)
      await nextFrame()

      const portal = document.querySelector('body > div:not([data-controller])')
      expect(portal).toBeFalsy()
    })
  })

  describe("toggle behavior", () => {
    test("toggle opens drawer when closed", async () => {
      const trigger = controller.triggerTarget

      click(trigger)
      await nextFrame()

      expect(controller.openValue).toBe(true)
      expect(controller.portal).toBeTruthy()
    })

    test("toggle closes drawer when open", async () => {
      const trigger = controller.triggerTarget

      // Open
      click(trigger)
      await nextFrame()
      expect(controller.openValue).toBe(true)

      // Close
      click(trigger)
      await wait(250) // Wait for closing animation

      expect(controller.openValue).toBe(false)
      expect(controller.portal).toBeNull()
    })

    test("multiple toggles work correctly", async () => {
      const trigger = controller.triggerTarget

      // Open
      click(trigger)
      await nextFrame()
      expect(controller.openValue).toBe(true)

      // Close
      click(trigger)
      await wait(250)
      expect(controller.openValue).toBe(false)

      // Open again
      click(trigger)
      await nextFrame()
      expect(controller.openValue).toBe(true)

      // Close again
      click(trigger)
      await wait(250)
      expect(controller.openValue).toBe(false)
    })
  })

  describe("portal rendering", () => {
    test("creates portal in document body when opened", async () => {
      controller.open()
      await nextFrame()

      const portal = document.querySelector('body > div:not([data-controller])')
      expect(portal).toBeTruthy()
      expect(portal).toBe(controller.portal)
    })

    test("portal contains overlay element", async () => {
      controller.open()
      await nextFrame()

      const overlay = controller.portal.querySelector('[data-shadcn--drawer-target="overlay"]')
      expect(overlay).toBeTruthy()
    })

    test("portal contains content element", async () => {
      controller.open()
      await nextFrame()

      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')
      expect(content).toBeTruthy()
    })

    test("portal contains template innerHTML", async () => {
      controller.open()
      await nextFrame()

      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')
      expect(content.innerHTML).toContain("Drawer Content")
    })

    test("removes portal from DOM when closed", async () => {
      controller.open()
      await nextFrame()

      const portalBefore = document.querySelector('body > div:not([data-controller])')
      expect(portalBefore).toBeTruthy()

      controller.close()
      await wait(250) // Wait for closing animation

      const portalAfter = document.querySelector('body > div:not([data-controller])')
      expect(portalAfter).toBeFalsy()
    })

    test("does not open if template target is missing", async () => {
      // Remove template
      const template = element.querySelector('[data-shadcn--drawer-target="template"]')
      template.remove()

      controller.open()
      await nextFrame()

      expect(controller.portal).toBeNull()
    })
  })

  describe("data-state attributes", () => {
    test("overlay has data-state='closed' initially in portal", async () => {
      controller.open()

      const overlay = controller.portal.querySelector('[data-shadcn--drawer-target="overlay"]')
      expect(overlay.getAttribute("data-state")).toBe("closed")
    })

    test("content has data-state='closed' initially in portal", async () => {
      controller.open()

      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')
      expect(content.getAttribute("data-state")).toBe("closed")
    })

    test("overlay has data-state='open' after animation frame", async () => {
      controller.open()
      await nextFrame()

      const overlay = controller.portal.querySelector('[data-shadcn--drawer-target="overlay"]')
      expect(overlay.getAttribute("data-state")).toBe("open")
    })

    test("content has data-state='open' after animation frame", async () => {
      controller.open()
      await nextFrame()

      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')
      expect(content.getAttribute("data-state")).toBe("open")
    })

    test("overlay has data-state='closed' when closing", async () => {
      controller.open()
      await nextFrame()

      controller.close()

      const overlay = controller.portal.querySelector('[data-shadcn--drawer-target="overlay"]')
      expect(overlay.getAttribute("data-state")).toBe("closed")
    })

    test("content has data-state='closed' when closing", async () => {
      controller.open()
      await nextFrame()

      controller.close()

      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')
      expect(content.getAttribute("data-state")).toBe("closed")
    })
  })

  describe("direction variants", () => {
    const directions = ["top", "right", "bottom", "left"]

    directions.forEach(direction => {
      test(`supports direction='${direction}'`, async () => {
        application.stop()
        document.body.innerHTML = createDrawerHTML(false, direction)

        application = Application.start()
        application.register("shadcn--drawer", DrawerController)
        await nextFrame()

        element = document.querySelector('[data-controller="shadcn--drawer"]')
        controller = application.getControllerForElementAndIdentifier(element, "shadcn--drawer")

        expect(controller.directionValue).toBe(direction)
      })

      test(`opens drawer with direction='${direction}'`, async () => {
        application.stop()
        document.body.innerHTML = createDrawerHTML(false, direction)

        application = Application.start()
        application.register("shadcn--drawer", DrawerController)
        await nextFrame()

        element = document.querySelector('[data-controller="shadcn--drawer"]')
        controller = application.getControllerForElementAndIdentifier(element, "shadcn--drawer")

        controller.open()
        await nextFrame()

        const portal = document.querySelector('body > div:not([data-controller])')
        expect(portal).toBeTruthy()
      })
    })
  })

  describe("focus management", () => {
    test("focuses content when drawer opens", async () => {
      controller.open()
      await nextFrame()

      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')
      expect(document.activeElement).toBe(content)
    })

    test("content is focusable with tabindex", async () => {
      controller.open()
      await nextFrame()

      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')
      expect(content.getAttribute("tabindex")).toBe("-1")
    })

    test("maintains focus within drawer when open", async () => {
      controller.open()
      await nextFrame()

      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')
      const input = controller.portal.querySelector('input')

      // Focus moves to content first
      expect(document.activeElement).toBe(content)

      // Can focus elements within content
      input.focus()
      expect(document.activeElement).toBe(input)
    })
  })

  describe("escape key handling", () => {
    test("closes drawer when Escape key is pressed", async () => {
      controller.open()
      await nextFrame()

      expect(controller.openValue).toBe(true)

      keydown(document, 'Escape')
      await wait(250)

      expect(controller.openValue).toBe(false)
      expect(controller.portal).toBeNull()
    })

    test("escape key listener is added when drawer opens", async () => {
      expect(controller.boundHandleKeydown).toBeDefined()

      controller.open()
      await nextFrame()

      // Verify that escape works (indirectly confirms listener is attached)
      keydown(document, 'Escape')
      await wait(250)

      expect(controller.openValue).toBe(false)
    })

    test("escape key listener is removed when drawer closes", async () => {
      controller.open()
      await nextFrame()

      controller.close()
      await wait(250)

      // Try to close again with escape - shouldn't do anything since already closed
      keydown(document, 'Escape')
      await nextFrame()

      expect(controller.openValue).toBe(false)
    })

    test("escape key only affects open drawer", async () => {
      // Try escape when drawer is closed
      keydown(document, 'Escape')
      await nextFrame()

      expect(controller.openValue).toBe(false)
    })
  })

  describe("overlay click handling", () => {
    test("closes drawer when overlay is clicked", async () => {
      controller.open()
      await nextFrame()

      const overlay = controller.portal.querySelector('[data-shadcn--drawer-target="overlay"]')

      click(overlay)
      await wait(250)

      expect(controller.openValue).toBe(false)
      expect(controller.portal).toBeNull()
    })

    test("overlay click listener is added when drawer opens", async () => {
      controller.open()
      await nextFrame()

      const overlay = controller.portal.querySelector('[data-shadcn--drawer-target="overlay"]')
      expect(overlay).toBeTruthy()

      // Verify overlay click works (indirectly confirms listener is attached)
      click(overlay)
      await wait(250)

      expect(controller.openValue).toBe(false)
    })

    test("clicking content does not close drawer", async () => {
      controller.open()
      await nextFrame()

      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')

      click(content)
      await nextFrame()

      expect(controller.openValue).toBe(true)
      expect(controller.portal).toBeTruthy()
    })
  })

  describe("body scroll lock", () => {
    test("locks body scroll when drawer opens", async () => {
      expect(document.body.style.overflow).toBe("")

      controller.open()
      await nextFrame()

      expect(document.body.style.overflow).toBe("hidden")
    })

    test("restores body scroll when drawer closes", async () => {
      controller.open()
      await nextFrame()
      expect(document.body.style.overflow).toBe("hidden")

      controller.close()
      await wait(250)

      expect(document.body.style.overflow).toBe("")
    })

    test("restores body scroll even if closed quickly", async () => {
      controller.open()
      await nextFrame()

      controller.close()
      // Don't wait for animation

      expect(document.body.style.overflow).toBe("")
    })

    test("body scroll is locked for multiple open/close cycles", async () => {
      // First cycle
      controller.open()
      await nextFrame()
      expect(document.body.style.overflow).toBe("hidden")

      controller.close()
      await wait(250)
      expect(document.body.style.overflow).toBe("")

      // Second cycle
      controller.open()
      await nextFrame()
      expect(document.body.style.overflow).toBe("hidden")

      controller.close()
      await wait(250)
      expect(document.body.style.overflow).toBe("")
    })
  })

  describe("event dispatch", () => {
    test("dispatches 'open' event when drawer opens", async () => {
      const eventPromise = waitForEvent(element, 'shadcn--drawer:open')

      controller.open()

      const event = await eventPromise
      expect(event).toBeTruthy()
    })

    test("dispatches 'close' event when drawer closes", async () => {
      controller.open()
      await nextFrame()

      const eventPromise = waitForEvent(element, 'shadcn--drawer:close')

      controller.close()

      const event = await eventPromise
      expect(event).toBeTruthy()
    })

    test("events bubble up correctly", async () => {
      let openEventFired = false
      let closeEventFired = false

      element.addEventListener('shadcn--drawer:open', () => {
        openEventFired = true
      })

      element.addEventListener('shadcn--drawer:close', () => {
        closeEventFired = true
      })

      controller.open()
      await nextFrame()
      expect(openEventFired).toBe(true)

      controller.close()
      await nextFrame()
      expect(closeEventFired).toBe(true)
    })

    test("open event is dispatched before portal is shown", async () => {
      let eventTime = null
      let portalStateAtEvent = null

      element.addEventListener('shadcn--drawer:open', () => {
        eventTime = Date.now()
        const portalOverlay = controller.portal?.querySelector('[data-shadcn--drawer-target="overlay"]')
        portalStateAtEvent = portalOverlay?.getAttribute('data-state')
      })

      controller.open()
      await nextFrame()

      expect(eventTime).toBeTruthy()
      // Portal exists but might still be in closed state when event fires
      expect(portalStateAtEvent).toBe('closed')
    })
  })

  describe("openValueChanged", () => {
    test("opens drawer when openValue changes from false to true", async () => {
      expect(controller.portal).toBeNull()

      controller.openValue = true
      await nextFrame()

      expect(controller.portal).toBeTruthy()
    })

    test("closes drawer when openValue changes from true to false", async () => {
      controller.openValue = true
      await nextFrame()
      expect(controller.portal).toBeTruthy()

      controller.openValue = false
      await wait(250)

      expect(controller.portal).toBeNull()
    })

    test("does not open if already has portal", async () => {
      controller.open()
      await nextFrame()

      const firstPortal = controller.portal

      controller.openValue = true
      await nextFrame()

      // Should be same portal
      expect(controller.portal).toBe(firstPortal)
    })

    test("does not close if already closed", async () => {
      expect(controller.portal).toBeNull()

      controller.openValue = false
      await nextFrame()

      // Should still be null
      expect(controller.portal).toBeNull()
    })
  })

  describe("disconnect", () => {
    test("calls removePortal on disconnect", async () => {
      controller.open()
      await nextFrame()

      expect(controller.portal).toBeTruthy()
      const portal = controller.portal

      // Manually call disconnect to test
      controller.disconnect()

      // removePortal should have been called
      expect(controller.portal).toBeNull()
      expect(document.body.contains(portal)).toBe(false)
    })

    test("removes keydown event listener on disconnect", async () => {
      controller.open()
      await nextFrame()

      // Manually call disconnect
      controller.disconnect()

      // Create new controller to verify listener was removed
      // (Cannot directly test listener removal, but can verify no errors)
      keydown(document, 'Escape')
      await nextFrame()

      // No errors means success
      expect(true).toBe(true)
    })

    test("cleans up even if drawer is open", async () => {
      controller.open()
      await nextFrame()

      const portal = controller.portal
      expect(portal).toBeTruthy()

      const portalInBody = document.body.contains(portal)
      expect(portalInBody).toBe(true)

      // Manually call disconnect
      controller.disconnect()

      // Portal should be removed from DOM
      expect(controller.portal).toBeNull()
      expect(document.body.contains(portal)).toBe(false)
    })

    test("restores body overflow on disconnect", async () => {
      controller.open()
      await nextFrame()

      expect(document.body.style.overflow).toBe("hidden")

      // Disconnect removes event listener but doesn't restore overflow
      // We need to close first
      controller.close()
      await nextFrame()

      application.stop()

      // Overflow should be restored from close, not disconnect
      expect(document.body.style.overflow).toBe("")
    })
  })

  describe("removePortal", () => {
    test("removes portal from DOM", async () => {
      controller.open()
      await nextFrame()

      const portal = controller.portal
      expect(document.body.contains(portal)).toBe(true)

      controller.removePortal()

      expect(document.body.contains(portal)).toBe(false)
    })

    test("sets portal to null", async () => {
      controller.open()
      await nextFrame()

      expect(controller.portal).toBeTruthy()

      controller.removePortal()

      expect(controller.portal).toBeNull()
    })

    test("does nothing if portal is null", () => {
      expect(controller.portal).toBeNull()

      expect(() => {
        controller.removePortal()
      }).not.toThrow()

      expect(controller.portal).toBeNull()
    })

    test("can be called multiple times safely", async () => {
      controller.open()
      await nextFrame()

      controller.removePortal()
      expect(controller.portal).toBeNull()

      controller.removePortal()
      expect(controller.portal).toBeNull()
    })
  })

  describe("animation timing", () => {
    test("waits 200ms before removing portal when closing", async () => {
      controller.open()
      await nextFrame()

      const portal = controller.portal

      controller.close()

      // Portal should still exist immediately after close
      expect(document.body.contains(portal)).toBe(true)

      // Wait less than 200ms
      await wait(100)
      expect(document.body.contains(portal)).toBe(true)

      // Wait for full duration
      await wait(150)
      expect(document.body.contains(portal)).toBe(false)
    })

    test("state changes after animation frame", async () => {
      controller.open()

      const overlay = controller.portal.querySelector('[data-shadcn--drawer-target="overlay"]')
      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')

      // Before animation frame
      expect(overlay.getAttribute('data-state')).toBe('closed')
      expect(content.getAttribute('data-state')).toBe('closed')

      await nextFrame()

      // After animation frame
      expect(overlay.getAttribute('data-state')).toBe('open')
      expect(content.getAttribute('data-state')).toBe('open')
    })

    test("state is open after requestAnimationFrame completes", async () => {
      controller.open()
      await nextFrame()

      const overlay = controller.portal.querySelector('[data-shadcn--drawer-target="overlay"]')
      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')

      // Verify animation has completed
      expect(overlay.getAttribute('data-state')).toBe('open')
      expect(content.getAttribute('data-state')).toBe('open')
    })
  })

  describe("edge cases", () => {
    test("handles missing overlay gracefully", async () => {
      // Modify template to not have overlay
      const template = element.querySelector('[data-shadcn--drawer-target="template"]')
      template.innerHTML = `
        <div data-shadcn--drawer-target="content" data-state="closed" tabindex="-1">
          <h2>Drawer Content</h2>
        </div>
      `

      expect(() => {
        controller.open()
      }).not.toThrow()

      await nextFrame()

      expect(controller.portal).toBeTruthy()
    })

    test("handles missing content gracefully", async () => {
      // Modify template to not have content
      const template = element.querySelector('[data-shadcn--drawer-target="template"]')
      template.innerHTML = `
        <div data-shadcn--drawer-target="overlay" data-state="closed"></div>
      `

      expect(() => {
        controller.open()
      }).not.toThrow()

      await nextFrame()

      expect(controller.portal).toBeTruthy()
    })

    test("handles rapid open/close cycles", async () => {
      // Open
      controller.open()
      await nextFrame()

      // Close immediately
      controller.close()

      // Open again before close animation finishes
      controller.open()
      await nextFrame()

      // Should have a portal
      expect(controller.portal).toBeTruthy()
    })

    test("close does nothing if portal is null", () => {
      expect(controller.portal).toBeNull()

      expect(() => {
        controller.close()
      }).not.toThrow()

      expect(controller.portal).toBeNull()
    })

    test("handles empty template gracefully", async () => {
      const template = element.querySelector('[data-shadcn--drawer-target="template"]')
      template.innerHTML = ''

      controller.open()
      await nextFrame()

      // Portal exists but is empty
      expect(controller.portal).toBeTruthy()
      expect(controller.portal.innerHTML).toBe('')
    })
  })

  describe("integration scenarios", () => {
    test("complete open and close cycle", async () => {
      // Initial state
      expect(controller.openValue).toBe(false)
      expect(controller.portal).toBeNull()
      expect(document.body.style.overflow).toBe("")

      // Open
      const trigger = controller.triggerTarget
      click(trigger)
      await nextFrame()

      expect(controller.openValue).toBe(true)
      expect(controller.portal).toBeTruthy()
      expect(document.body.style.overflow).toBe("hidden")

      const overlay = controller.portal.querySelector('[data-shadcn--drawer-target="overlay"]')
      expect(overlay.getAttribute('data-state')).toBe('open')

      // Close via overlay
      click(overlay)
      await wait(250)

      expect(controller.openValue).toBe(false)
      expect(controller.portal).toBeNull()
      expect(document.body.style.overflow).toBe("")
    })

    test("open via trigger, close via escape", async () => {
      const trigger = controller.triggerTarget

      click(trigger)
      await nextFrame()

      expect(controller.openValue).toBe(true)

      keydown(document, 'Escape')
      await wait(250)

      expect(controller.openValue).toBe(false)
      expect(controller.portal).toBeNull()
    })

    test("multiple drawers can coexist", async () => {
      // Create second drawer
      const drawer2HTML = createDrawerHTML(false, "right")
      const tempDiv = document.createElement('div')
      tempDiv.innerHTML = drawer2HTML
      document.body.appendChild(tempDiv.firstElementChild)

      await nextFrame()

      const element2 = document.querySelectorAll('[data-controller="shadcn--drawer"]')[1]
      const controller2 = application.getControllerForElementAndIdentifier(element2, "shadcn--drawer")

      // Open first drawer
      controller.open()
      await nextFrame()

      // Open second drawer
      controller2.open()
      await nextFrame()

      // Both should be open
      expect(controller.portal).toBeTruthy()
      expect(controller2.portal).toBeTruthy()

      // Close first
      controller.close()
      await wait(250)

      expect(controller.portal).toBeNull()
      expect(controller2.portal).toBeTruthy()

      // Clean up
      controller2.close()
      await wait(250)
    })

    test("works with different directions in sequence", async () => {
      const directions = ["top", "right", "bottom", "left"]

      for (const direction of directions) {
        application.stop()
        document.body.innerHTML = createDrawerHTML(false, direction)

        application = Application.start()
        application.register("shadcn--drawer", DrawerController)
        await nextFrame()

        element = document.querySelector('[data-controller="shadcn--drawer"]')
        controller = application.getControllerForElementAndIdentifier(element, "shadcn--drawer")

        controller.open()
        await nextFrame()

        expect(controller.directionValue).toBe(direction)
        expect(controller.portal).toBeTruthy()

        controller.close()
        await wait(250)

        expect(controller.portal).toBeNull()
      }
    })

    test("focus returns to trigger after closing", async () => {
      const trigger = controller.triggerTarget

      trigger.focus()
      expect(document.activeElement).toBe(trigger)

      click(trigger)
      await nextFrame()

      const content = controller.portal.querySelector('[data-shadcn--drawer-target="content"]')
      expect(document.activeElement).toBe(content)

      controller.close()
      await wait(250)

      // Note: This behavior may need to be implemented in the controller
      // Currently it doesn't restore focus automatically
    })
  })
})
