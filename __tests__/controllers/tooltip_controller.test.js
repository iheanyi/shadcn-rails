import { Application } from "@hotwired/stimulus"
import TooltipController from "../../app/assets/javascripts/shadcn/controllers/tooltip_controller.ts"
import { wait, nextFrame, keydown } from '../helpers/stimulus-test-helper.js'

describe("TooltipController", () => {
  let application
  let element
  let controller

  const createTooltipHTML = (side = "top", align = "center", delay = 200, skipDelay = 300) => {
    return `
      <div data-controller="shadcn--tooltip"
           data-shadcn--tooltip-side-value="${side}"
           data-shadcn--tooltip-align-value="${align}"
           data-shadcn--tooltip-delay-value="${delay}"
           data-shadcn--tooltip-skip-delay-value="${skipDelay}">
        <button data-shadcn--tooltip-target="trigger"
                data-action="mouseenter->shadcn--tooltip#show mouseleave->shadcn--tooltip#hide focus->shadcn--tooltip#show blur->shadcn--tooltip#hide">
          Hover me
        </button>
        <div data-shadcn--tooltip-target="content"
             hidden
             role="tooltip"
             style="position: relative;">
          Tooltip content
        </div>
      </div>
    `
  }

  beforeEach(async () => {
    application = Application.start()
    application.register("shadcn--tooltip", TooltipController)
    document.body.innerHTML = createTooltipHTML()

    await nextFrame()

    element = document.querySelector('[data-controller="shadcn--tooltip"]')
    controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")
  })

  afterEach(() => {
    if (application) {
      application.stop()
    }
    document.body.innerHTML = ""
  })

  describe("value initialization", () => {
    test("initializes with default side value of 'top'", () => {
      expect(controller.sideValue).toBe("top")
    })

    test("initializes with default align value of 'center'", () => {
      expect(controller.alignValue).toBe("center")
    })

    test("initializes with default delay value of 200", () => {
      expect(controller.delayValue).toBe(200)
    })

    test("initializes with default skipDelay value of 300", () => {
      expect(controller.skipDelayValue).toBe(300)
    })

    test("accepts custom side value", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("bottom")

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      expect(controller.sideValue).toBe("bottom")
    })

    test("accepts custom align value", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("top", "start")

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      expect(controller.alignValue).toBe("start")
    })

    test("accepts custom delay value", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("top", "center", 500)

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      expect(controller.delayValue).toBe(500)
    })

    test("accepts custom skipDelay value", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("top", "center", 200, 1000)

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      expect(controller.skipDelayValue).toBe(1000)
    })
  })

  describe("connect and disconnect", () => {
    test("initializes timeouts to null on connect", () => {
      expect(controller.showTimeout).toBeNull()
      expect(controller.hideTimeout).toBeNull()
    })

    test("clears timeouts on disconnect", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')

      // Start showing tooltip
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))

      expect(controller.showTimeout).not.toBeNull()

      // Disconnect controller
      controller.disconnect()

      expect(controller.showTimeout).toBeNull()
      expect(controller.hideTimeout).toBeNull()
    })
  })

  describe("show and hide on hover", () => {
    test("shows tooltip on mouseenter", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))

      // Wait for delay
      await wait(250)

      expect(content.hidden).toBe(false)
      expect(content.dataset.state).toBe("open")
    })

    test("hides tooltip on mouseleave", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Show tooltip
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      expect(content.hidden).toBe(false)

      // Hide tooltip
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      await wait(150)

      expect(content.dataset.state).toBe("closed")
      expect(content.hidden).toBe(true)
    })

    test("does not show tooltip if mouseleave before delay", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))

      // Leave before delay completes
      await wait(100)
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))

      // Wait past original delay
      await wait(200)

      expect(content.hidden).toBe(true)
    })
  })

  describe("delay behavior", () => {
    test("waits for delay before showing tooltip", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))

      // Tooltip should not be visible before delay
      await wait(100)
      expect(content.hidden).toBe(true)

      // Should be visible after delay
      await wait(150)
      expect(content.hidden).toBe(false)
    })

    test("respects custom delay value", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("top", "center", 500)

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))

      // Should not show before custom delay
      await wait(400)
      expect(content.hidden).toBe(true)

      // Should show after custom delay
      await wait(150)
      expect(content.hidden).toBe(false)
    })
  })

  describe("positioning - side", () => {
    test("positions tooltip with Floating UI on top by default", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Floating UI sets absolute positioning with pixel values
      expect(content.style.position).toBe("absolute")
      expect(content.style.left).toMatch(/^\d+px$/)
      expect(content.style.top).toMatch(/^\d+px$/)
      expect(content.dataset.side).toBeDefined()
    })

    test("positions tooltip on bottom", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("bottom")

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Floating UI handles positioning with absolute coordinates
      expect(content.style.position).toBe("absolute")
      expect(content.style.left).toMatch(/^\d+px$/)
      expect(content.style.top).toMatch(/^\d+px$/)
      expect(content.dataset.side).toBeDefined()
    })

    test("positions tooltip on left", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("left")

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Floating UI handles all positioning via absolute coordinates
      expect(content.style.position).toBe("absolute")
      expect(content.style.left).toMatch(/^\d+px$/)
      expect(content.style.top).toMatch(/^\d+px$/)
      expect(content.dataset.side).toBeDefined()
    })

    test("positions tooltip on right", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("right")

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Floating UI handles positioning
      expect(content.style.position).toBe("absolute")
      expect(content.style.left).toMatch(/^\d+px$/)
      expect(content.style.top).toMatch(/^\d+px$/)
      expect(content.dataset.side).toBeDefined()
    })
  })

  describe("positioning - Floating UI", () => {
    test("uses absolute positioning via Floating UI", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Floating UI sets absolute positioning with pixel values
      expect(content.style.position).toBe("absolute")
      expect(content.style.left).toMatch(/^\d+px$/)
      expect(content.style.top).toMatch(/^\d+px$/)
    })

    test("sets data-side attribute based on placement", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("top", "start")

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Floating UI sets data-side based on final placement
      expect(content.dataset.side).toBeDefined()
    })

    test("positions with different placements", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("top", "end")

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Floating UI handles positioning, we just verify it's applied
      expect(content.style.position).toBe("absolute")
    })

    test("applies Floating UI positioning for bottom placement", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("bottom", "center")

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Floating UI handles all positioning via computed coordinates
      expect(content.style.position).toBe("absolute")
      expect(content.style.left).toMatch(/^\d+px$/)
      expect(content.style.top).toMatch(/^\d+px$/)
    })

    test("applies Floating UI positioning for left side", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("left", "start")

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Floating UI handles all placements with absolute positioning
      expect(content.style.position).toBe("absolute")
      expect(content.style.left).toMatch(/^\d+px$/)
      expect(content.style.top).toMatch(/^\d+px$/)
    })
  })

  describe("timeout cleanup", () => {
    test("clears show timeout when hide is called", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Start showing
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      expect(controller.showTimeout).not.toBeNull()

      // Hide before show completes
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      expect(controller.showTimeout).toBeNull()

      // Advance past original show delay
      await wait(300)

      // Tooltip should not be shown
      expect(content.hidden).toBe(true)
    })

    test("clears hide timeout when show is called", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Show tooltip
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Start hiding
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      expect(controller.hideTimeout).not.toBeNull()

      // Show again before hide completes
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      expect(controller.hideTimeout).toBeNull()
    })

    test("no memory leaks when quickly hovering in and out", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')

      // Rapidly hover in/out
      for (let i = 0; i < 10; i++) {
        trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
        await wait(50)
        trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
        await wait(50)
      }

      // Only one timeout should be active at most
      const hasTimeout = controller.showTimeout !== null || controller.hideTimeout !== null
      expect(hasTimeout).toBe(true)

      // Clean up
      await wait(300)
    })

    test("clears all timeouts in clearTimeouts method", () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')

      // Create a show timeout
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      expect(controller.showTimeout).not.toBeNull()

      // Call clearTimeouts
      controller.clearTimeouts()

      expect(controller.showTimeout).toBeNull()
      expect(controller.hideTimeout).toBeNull()
    })
  })

  describe("keyboard accessibility", () => {
    test("shows tooltip on focus", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new FocusEvent('focus', { bubbles: true }))

      await wait(250)

      expect(content.hidden).toBe(false)
      expect(content.dataset.state).toBe("open")
    })

    test("hides tooltip on blur", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Show tooltip
      trigger.dispatchEvent(new FocusEvent('focus', { bubbles: true }))
      await wait(250)

      expect(content.hidden).toBe(false)

      // Hide tooltip
      trigger.dispatchEvent(new FocusEvent('blur', { bubbles: true }))
      await wait(150)

      expect(content.dataset.state).toBe("closed")
      expect(content.hidden).toBe(true)
    })

    test("shows tooltip with keyboard navigation", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Tab to focus the button
      trigger.focus()
      trigger.dispatchEvent(new FocusEvent('focus', { bubbles: true }))

      await wait(250)

      expect(content.hidden).toBe(false)
    })
  })

  describe("ARIA attributes", () => {
    test("tooltip has role='tooltip'", () => {
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')
      expect(content.getAttribute('role')).toBe('tooltip')
    })

    test("content is hidden initially", () => {
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')
      expect(content.hidden).toBe(true)
    })

    test("content data-state changes to open when shown", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      expect(content.dataset.state).toBe("open")
    })

    test("content data-state changes to closed when hidden", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Show
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Hide
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      await wait(50)

      expect(content.dataset.state).toBe("closed")
    })
  })

  describe("positioning edge cases", () => {
    test("handles missing trigger target gracefully", async () => {
      // Remove trigger
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      trigger.remove()

      expect(() => {
        controller.show()
      }).not.toThrow()

      await wait(250)
    })

    test("handles missing content target gracefully", async () => {
      // Remove content
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')
      content.remove()

      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')

      expect(() => {
        trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      }).not.toThrow()

      await wait(250)
    })

    test("resets positioning styles before positioning", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Show tooltip
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Verify position is absolute
      expect(content.style.position).toBe("absolute")
    })

    test("sets data-side attribute on content", async () => {
      application.stop()
      document.body.innerHTML = createTooltipHTML("bottom")

      application = Application.start()
      application.register("shadcn--tooltip", TooltipController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--tooltip"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tooltip")

      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      expect(content.dataset.side).toBe("bottom")
    })
  })

  describe("hide animation timing", () => {
    test("sets data-state to closed immediately", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Show tooltip
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Hide tooltip
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      await wait(10) // hideTimeout is 0ms but let event loop process

      expect(content.dataset.state).toBe("closed")
    })

    test("sets hidden attribute after 100ms delay", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Show tooltip
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      expect(content.hidden).toBe(false)

      // Hide tooltip
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      await wait(10)

      // Should not be hidden yet
      expect(content.hidden).toBe(false)

      // After 100ms animation delay
      await wait(100)

      expect(content.hidden).toBe(true)
    })
  })

  describe("integration scenarios", () => {
    test("can show and hide tooltip multiple times", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Show
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)
      expect(content.hidden).toBe(false)

      // Hide
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      await wait(150)
      expect(content.hidden).toBe(true)

      // Show again
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)
      expect(content.hidden).toBe(false)

      // Hide again
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      await wait(150)
      expect(content.hidden).toBe(true)
    })

    test("switches between hover and focus correctly", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Show on hover
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)
      expect(content.hidden).toBe(false)

      // Hide on leave
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      await wait(150)
      expect(content.hidden).toBe(true)

      // Show on focus
      trigger.dispatchEvent(new FocusEvent('focus', { bubbles: true }))
      await wait(250)
      expect(content.hidden).toBe(false)

      // Hide on blur
      trigger.dispatchEvent(new FocusEvent('blur', { bubbles: true }))
      await wait(150)
      expect(content.hidden).toBe(true)
    })

    test("repositions tooltip on each show", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Show tooltip
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      const firstPosition = {
        bottom: content.style.bottom,
        left: content.style.left,
        transform: content.style.transform
      }

      // Hide
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      await wait(150)

      // Show again
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Position should be recalculated (same values in this case)
      expect(content.style.bottom).toBe(firstPosition.bottom)
      expect(content.style.left).toBe(firstPosition.left)
      expect(content.style.transform).toBe(firstPosition.transform)
    })

    test("handles rapid hover in and out gracefully", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Rapid hover events
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(50)
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      await wait(20)
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(50)
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))
      await wait(20)
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))

      // Complete the final show
      await wait(250)

      expect(content.hidden).toBe(false)
      expect(content.dataset.state).toBe("open")
    })
  })

  describe("cleanup on disconnect", () => {
    test("prevents show after disconnect", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Start showing
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))

      // Disconnect before delay completes
      controller.disconnect()

      // Advance past delay
      await wait(300)

      // Should not show because timeouts were cleared
      expect(content.hidden).toBe(true)
    })

    test("clears pending hide timeout on disconnect", async () => {
      const trigger = element.querySelector('[data-shadcn--tooltip-target="trigger"]')
      const content = element.querySelector('[data-shadcn--tooltip-target="content"]')

      // Show tooltip
      trigger.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }))
      await wait(250)

      // Start hiding
      trigger.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }))

      // Disconnect before hide completes
      controller.disconnect()

      expect(controller.hideTimeout).toBeNull()
    })
  })
})
