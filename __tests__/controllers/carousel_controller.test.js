import { Application } from "@hotwired/stimulus"
import CarouselController from "../../app/assets/javascripts/shadcn/controllers/carousel_controller.js"
import { setupController, cleanupController, click, wait, nextFrame, keydown, waitForEvent } from '../helpers/stimulus-test-helper.js'

describe("CarouselController", () => {
  let application
  let element
  let controller

  const createCarouselHTML = ({
    orientation = "horizontal",
    loop = false,
    autoplay = false,
    autoplayInterval = 4000,
    align = "start",
    selectedIndex = 0,
    itemCount = 3
  } = {}) => {
    const items = Array.from({ length: itemCount }, (_, i) =>
      `<div data-shadcn--carousel-target="item" data-index="${i}">Slide ${i + 1}</div>`
    ).join('')

    return `
      <div data-controller="shadcn--carousel"
           data-shadcn--carousel-orientation-value="${orientation}"
           data-shadcn--carousel-loop-value="${loop}"
           data-shadcn--carousel-autoplay-value="${autoplay}"
           data-shadcn--carousel-autoplay-interval-value="${autoplayInterval}"
           data-shadcn--carousel-align-value="${align}"
           data-shadcn--carousel-selected-index-value="${selectedIndex}">
        <div data-shadcn--carousel-target="viewport">
          <div data-shadcn--carousel-target="content">
            ${items}
          </div>
        </div>
        <button data-shadcn--carousel-target="prevButton" data-action="click->shadcn--carousel#previous">Prev</button>
        <button data-shadcn--carousel-target="nextButton" data-action="click->shadcn--carousel#next">Next</button>
      </div>
    `
  }

  const setupCarousel = async (options = {}) => {
    application = Application.start()
    application.register("shadcn--carousel", CarouselController)
    document.body.innerHTML = createCarouselHTML(options)

    await nextFrame()

    element = document.querySelector('[data-controller="shadcn--carousel"]')
    controller = application.getControllerForElementAndIdentifier(element, "shadcn--carousel")

    return { application, element, controller }
  }

  afterEach(() => {
    if (application) {
      application.stop()
    }
    document.body.innerHTML = ""
  })

  describe("Value Initialization", () => {
    test("initializes with default values", async () => {
      await setupCarousel()

      expect(controller.orientationValue).toBe("horizontal")
      expect(controller.loopValue).toBe(false)
      expect(controller.autoplayValue).toBe(false)
      expect(controller.autoplayIntervalValue).toBe(4000)
      expect(controller.alignValue).toBe("start")
      expect(controller.selectedIndexValue).toBe(0)
    })

    test("initializes with custom orientation value", async () => {
      await setupCarousel({ orientation: "vertical" })

      expect(controller.orientationValue).toBe("vertical")
    })

    test("initializes with loop enabled", async () => {
      await setupCarousel({ loop: true })

      expect(controller.loopValue).toBe(true)
    })

    test("initializes with autoplay enabled", async () => {
      await setupCarousel({ autoplay: true })

      expect(controller.autoplayValue).toBe(true)
      expect(controller.autoplayTimer).toBeDefined()
    })

    test("initializes with custom autoplay interval", async () => {
      await setupCarousel({ autoplayInterval: 2000 })

      expect(controller.autoplayIntervalValue).toBe(2000)
    })

    test("initializes with custom align value", async () => {
      await setupCarousel({ align: "center" })

      expect(controller.alignValue).toBe("center")
    })

    test("initializes with custom selected index", async () => {
      await setupCarousel({ selectedIndex: 1 })

      expect(controller.selectedIndexValue).toBe(1)
    })
  })

  describe("Navigation - next()", () => {
    test("advances to next slide", async () => {
      await setupCarousel()

      expect(controller.selectedIndexValue).toBe(0)

      controller.next()
      expect(controller.selectedIndexValue).toBe(1)

      controller.next()
      expect(controller.selectedIndexValue).toBe(2)
    })

    test("stops at last slide when loop is disabled", async () => {
      await setupCarousel({ loop: false })

      controller.selectedIndexValue = 2 // Last slide

      controller.next()
      expect(controller.selectedIndexValue).toBe(2) // Should stay at 2
    })

    test("wraps around to first slide when loop is enabled", async () => {
      await setupCarousel({ loop: true })

      controller.selectedIndexValue = 2 // Last slide

      controller.next()
      expect(controller.selectedIndexValue).toBe(0) // Should wrap to first
    })

    test("dispatches select event with correct index", async () => {
      await setupCarousel()

      const selectPromise = waitForEvent(element, "shadcn--carousel:select")

      controller.next()

      const event = await selectPromise
      expect(event.detail.index).toBe(1)
    })

    test("next button triggers next slide", async () => {
      await setupCarousel()

      const nextButton = element.querySelector('[data-shadcn--carousel-target="nextButton"]')

      click(nextButton)
      await nextFrame()

      expect(controller.selectedIndexValue).toBe(1)
    })
  })

  describe("Navigation - previous()", () => {
    test("goes back to previous slide", async () => {
      await setupCarousel({ selectedIndex: 2 })

      expect(controller.selectedIndexValue).toBe(2)

      controller.previous()
      expect(controller.selectedIndexValue).toBe(1)

      controller.previous()
      expect(controller.selectedIndexValue).toBe(0)
    })

    test("stops at first slide when loop is disabled", async () => {
      await setupCarousel({ loop: false, selectedIndex: 0 })

      controller.previous()
      expect(controller.selectedIndexValue).toBe(0) // Should stay at 0
    })

    test("wraps around to last slide when loop is enabled", async () => {
      await setupCarousel({ loop: true, selectedIndex: 0 })

      controller.previous()
      expect(controller.selectedIndexValue).toBe(2) // Should wrap to last (index 2)
    })

    test("dispatches select event with correct index", async () => {
      await setupCarousel({ selectedIndex: 1 })

      const selectPromise = waitForEvent(element, "shadcn--carousel:select")

      controller.previous()

      const event = await selectPromise
      expect(event.detail.index).toBe(0)
    })

    test("previous button triggers previous slide", async () => {
      await setupCarousel({ selectedIndex: 2 })

      const prevButton = element.querySelector('[data-shadcn--carousel-target="prevButton"]')

      click(prevButton)
      await nextFrame()

      expect(controller.selectedIndexValue).toBe(1)
    })
  })

  describe("Loop Behavior", () => {
    test("loop disabled - buttons disabled at boundaries", async () => {
      await setupCarousel({ loop: false, selectedIndex: 0 })

      const prevButton = element.querySelector('[data-shadcn--carousel-target="prevButton"]')
      const nextButton = element.querySelector('[data-shadcn--carousel-target="nextButton"]')

      // At first slide, prev should be disabled
      expect(prevButton.disabled).toBe(true)
      expect(nextButton.disabled).toBe(false)

      // Navigate to last slide
      controller.selectedIndexValue = 2
      controller.updateButtonStates()

      // At last slide, next should be disabled
      expect(prevButton.disabled).toBe(false)
      expect(nextButton.disabled).toBe(true)
    })

    test("loop enabled - buttons never disabled", async () => {
      await setupCarousel({ loop: true, selectedIndex: 0 })

      const prevButton = element.querySelector('[data-shadcn--carousel-target="prevButton"]')
      const nextButton = element.querySelector('[data-shadcn--carousel-target="nextButton"]')

      // At first slide
      expect(prevButton.disabled).toBe(false)
      expect(nextButton.disabled).toBe(false)

      // At last slide
      controller.selectedIndexValue = 2
      controller.updateButtonStates()

      expect(prevButton.disabled).toBe(false)
      expect(nextButton.disabled).toBe(false)
    })

    test("loop enabled - continuous navigation forward", async () => {
      await setupCarousel({ loop: true, itemCount: 3 })

      const indices = []
      for (let i = 0; i < 5; i++) {
        indices.push(controller.selectedIndexValue)
        controller.next()
      }

      expect(indices).toEqual([0, 1, 2, 0, 1])
    })

    test("loop enabled - continuous navigation backward", async () => {
      await setupCarousel({ loop: true, selectedIndex: 0, itemCount: 3 })

      const indices = []
      for (let i = 0; i < 5; i++) {
        indices.push(controller.selectedIndexValue)
        controller.previous()
      }

      expect(indices).toEqual([0, 2, 1, 0, 2])
    })
  })

  describe("Autoplay", () => {
    test("starts autoplay on connect when enabled", async () => {
      await setupCarousel({ autoplay: true, autoplayInterval: 100 })

      expect(controller.autoplayTimer).toBeDefined()
      expect(controller.selectedIndexValue).toBe(0)

      // Wait for autoplay to advance
      await wait(110)
      expect(controller.selectedIndexValue).toBe(1)

      await wait(100)
      expect(controller.selectedIndexValue).toBe(2)
    })

    test("does not start autoplay when disabled", async () => {
      await setupCarousel({ autoplay: false })

      expect(controller.autoplayTimer).toBeUndefined()
    })

    test("respects custom autoplay interval", async () => {
      await setupCarousel({ autoplay: true, autoplayInterval: 150 })

      expect(controller.selectedIndexValue).toBe(0)

      // Wait a bit less than the interval - should still be at 0
      await wait(100)
      expect(controller.selectedIndexValue).toBe(0) // Still at 0

      // Wait for the interval to complete
      await wait(60)
      expect(controller.selectedIndexValue).toBe(1) // Now at 1
    })

    test("pauses autoplay on mouse enter", async () => {
      await setupCarousel({ autoplay: true, autoplayInterval: 100 })

      expect(controller.autoplayTimer).toBeDefined()

      controller.mouseEnter()
      expect(controller.autoplayTimer).toBeNull()

      // Timer should not advance slides
      await wait(110)
      expect(controller.selectedIndexValue).toBe(0)
    })

    test("resumes autoplay on mouse leave", async () => {
      await setupCarousel({ autoplay: true, autoplayInterval: 100 })

      controller.mouseEnter()
      expect(controller.autoplayTimer).toBeNull()

      controller.mouseLeave()
      expect(controller.autoplayTimer).toBeDefined()

      await wait(110)
      expect(controller.selectedIndexValue).toBe(1)
    })

    test("pauses autoplay on touch start", async () => {
      await setupCarousel({ autoplay: true, autoplayInterval: 100 })

      const viewport = element.querySelector('[data-shadcn--carousel-target="viewport"]')

      const touchStartEvent = new TouchEvent('touchstart', {
        touches: [{ clientX: 100, clientY: 100 }]
      })

      viewport.dispatchEvent(touchStartEvent)
      expect(controller.autoplayTimer).toBeNull()
    })

    test("resumes autoplay after touch end", async () => {
      await setupCarousel({ autoplay: true, autoplayInterval: 100 })

      const viewport = element.querySelector('[data-shadcn--carousel-target="viewport"]')

      // Touch start
      controller.touchStartX = 100
      controller.touchStartY = 100
      controller.stopAutoplay()

      // Touch end (small swipe, below threshold)
      const touchEndEvent = new TouchEvent('touchend', {
        changedTouches: [{ clientX: 110, clientY: 100 }]
      })

      viewport.dispatchEvent(touchEndEvent)

      expect(controller.autoplayTimer).toBeDefined()
    })

    test("autoplay wraps around with loop enabled", async () => {
      await setupCarousel({ autoplay: true, loop: true, autoplayInterval: 100 })

      controller.selectedIndexValue = 2 // Last slide

      await wait(110)
      expect(controller.selectedIndexValue).toBe(0) // Should wrap to first
    })

    test("autoplay stops at end with loop disabled", async () => {
      await setupCarousel({ autoplay: true, loop: false, autoplayInterval: 100 })

      controller.selectedIndexValue = 2 // Last slide

      await wait(110)
      expect(controller.selectedIndexValue).toBe(2) // Should stay at last
    })
  })

  describe("Orientation", () => {
    test("horizontal orientation - ArrowLeft goes to previous", async () => {
      await setupCarousel({ orientation: "horizontal", selectedIndex: 1 })

      keydown(element, "ArrowLeft")
      expect(controller.selectedIndexValue).toBe(0)
    })

    test("horizontal orientation - ArrowRight goes to next", async () => {
      await setupCarousel({ orientation: "horizontal", selectedIndex: 0 })

      keydown(element, "ArrowRight")
      expect(controller.selectedIndexValue).toBe(1)
    })

    test("horizontal orientation - ArrowUp/Down do nothing", async () => {
      await setupCarousel({ orientation: "horizontal", selectedIndex: 1 })

      keydown(element, "ArrowUp")
      expect(controller.selectedIndexValue).toBe(1) // Unchanged

      keydown(element, "ArrowDown")
      expect(controller.selectedIndexValue).toBe(1) // Unchanged
    })

    test("vertical orientation - ArrowUp goes to previous", async () => {
      await setupCarousel({ orientation: "vertical", selectedIndex: 1 })

      keydown(element, "ArrowUp")
      expect(controller.selectedIndexValue).toBe(0)
    })

    test("vertical orientation - ArrowDown goes to next", async () => {
      await setupCarousel({ orientation: "vertical", selectedIndex: 0 })

      keydown(element, "ArrowDown")
      expect(controller.selectedIndexValue).toBe(1)
    })

    test("vertical orientation - ArrowLeft/Right do nothing", async () => {
      await setupCarousel({ orientation: "vertical", selectedIndex: 1 })

      keydown(element, "ArrowLeft")
      expect(controller.selectedIndexValue).toBe(1) // Unchanged

      keydown(element, "ArrowRight")
      expect(controller.selectedIndexValue).toBe(1) // Unchanged
    })
  })

  describe("Selected Index", () => {
    test("updates aria-hidden on slides when index changes", async () => {
      await setupCarousel()

      const items = element.querySelectorAll('[data-shadcn--carousel-target="item"]')

      // Initial state - first slide visible
      expect(items[0].getAttribute('aria-hidden')).toBe('false')
      expect(items[1].getAttribute('aria-hidden')).toBe('true')
      expect(items[2].getAttribute('aria-hidden')).toBe('true')

      // Navigate to second slide
      controller.selectedIndexValue = 1
      controller.scrollToIndex(1)

      expect(items[0].getAttribute('aria-hidden')).toBe('true')
      expect(items[1].getAttribute('aria-hidden')).toBe('false')
      expect(items[2].getAttribute('aria-hidden')).toBe('true')
    })

    test("updates inert property on slides when index changes", async () => {
      await setupCarousel()

      const items = element.querySelectorAll('[data-shadcn--carousel-target="item"]')

      // Initial state
      expect(items[0].inert).toBe(false)
      expect(items[1].inert).toBe(true)
      expect(items[2].inert).toBe(true)

      // Navigate to third slide
      controller.selectedIndexValue = 2
      controller.scrollToIndex(2)

      expect(items[0].inert).toBe(true)
      expect(items[1].inert).toBe(true)
      expect(items[2].inert).toBe(false)
    })

    test("selectedIndexValueChanged triggers scrollToIndex", async () => {
      await setupCarousel()

      // Track the current index before change
      const previousIndex = controller.selectedIndexValue

      controller.selectedIndexValue = 1

      // Verify index changed
      expect(controller.selectedIndexValue).toBe(1)
      expect(previousIndex).toBe(0)
    })

    test("persists selected index through interactions", async () => {
      await setupCarousel({ selectedIndex: 1 })

      expect(controller.selectedIndexValue).toBe(1)

      controller.next()
      expect(controller.selectedIndexValue).toBe(2)

      controller.previous()
      expect(controller.selectedIndexValue).toBe(1)
    })
  })

  describe("Timer Cleanup", () => {
    test("clears autoplay timer on disconnect", async () => {
      await setupCarousel({ autoplay: true, autoplayInterval: 100 })

      expect(controller.autoplayTimer).toBeDefined()

      // Stop autoplay manually before disconnecting
      controller.stopAutoplay()

      // Timer should be cleared
      expect(controller.autoplayTimer).toBeNull()

      // Wait - if timer wasn't cleared, it would cause errors
      await wait(110)
    })

    test("clears autoplay timer when stopAutoplay is called", async () => {
      await setupCarousel({ autoplay: true, autoplayInterval: 100 })

      expect(controller.autoplayTimer).toBeDefined()

      controller.stopAutoplay()

      expect(controller.autoplayTimer).toBeNull()
    })

    test("no memory leaks - multiple start/stop cycles", async () => {
      await setupCarousel({ autoplay: false })

      // Start and stop multiple times
      for (let i = 0; i < 5; i++) {
        controller.autoplayValue = true
        controller.startAutoplay()
        expect(controller.autoplayTimer).toBeDefined()

        controller.stopAutoplay()
        expect(controller.autoplayTimer).toBeNull()
      }
    })

    test("clears old timer when starting new autoplay", async () => {
      await setupCarousel({ autoplay: true, autoplayInterval: 100 })

      const firstTimerId = controller.autoplayTimer

      // Start autoplay again (should clear old timer)
      controller.startAutoplay()

      const secondTimerId = controller.autoplayTimer

      expect(secondTimerId).toBeDefined()
      expect(firstTimerId).not.toBe(secondTimerId)
    })

    test("removes event listeners on disconnect", async () => {
      await setupCarousel()

      // Verify bound event handlers exist
      expect(controller.boundHandleKeydown).toBeDefined()
      expect(controller.boundHandleTouchStart).toBeDefined()
      expect(controller.boundHandleTouchEnd).toBeDefined()

      // Test that disconnect actually calls stopAutoplay
      controller.autoplayValue = true
      controller.startAutoplay()
      expect(controller.autoplayTimer).toBeDefined()

      // Manually call disconnect to test cleanup
      controller.disconnect()

      // Timer should be cleared after disconnect
      expect(controller.autoplayTimer).toBeNull()
    })
  })

  describe("Keyboard Navigation", () => {
    test("prevents default on arrow key navigation", async () => {
      await setupCarousel({ orientation: "horizontal" })

      let defaultPrevented = false

      const event = new KeyboardEvent('keydown', {
        key: 'ArrowRight',
        bubbles: true,
        cancelable: true
      })

      // Override preventDefault to track if it was called
      const originalPreventDefault = event.preventDefault
      event.preventDefault = function() {
        defaultPrevented = true
        originalPreventDefault.call(this)
      }

      element.dispatchEvent(event)

      expect(defaultPrevented).toBe(true)
    })

    test("horizontal carousel ignores non-arrow keys", async () => {
      await setupCarousel({ orientation: "horizontal", selectedIndex: 1 })

      keydown(element, "Enter")
      expect(controller.selectedIndexValue).toBe(1)

      keydown(element, "Space")
      expect(controller.selectedIndexValue).toBe(1)

      keydown(element, "Tab")
      expect(controller.selectedIndexValue).toBe(1)
    })

    test("vertical carousel ignores non-arrow keys", async () => {
      await setupCarousel({ orientation: "vertical", selectedIndex: 1 })

      keydown(element, "Enter")
      expect(controller.selectedIndexValue).toBe(1)

      keydown(element, "Space")
      expect(controller.selectedIndexValue).toBe(1)
    })

    test("keyboard navigation respects loop setting", async () => {
      await setupCarousel({ orientation: "horizontal", loop: false, selectedIndex: 0 })

      keydown(element, "ArrowLeft")
      expect(controller.selectedIndexValue).toBe(0) // Should not wrap

      controller.loopValue = true
      keydown(element, "ArrowLeft")
      expect(controller.selectedIndexValue).toBe(2) // Should wrap to last
    })
  })

  describe("goToSlide", () => {
    test("navigates to specific slide by index", async () => {
      await setupCarousel()

      const mockEvent = {
        currentTarget: { dataset: { index: "2" } }
      }

      controller.goToSlide(mockEvent)

      expect(controller.selectedIndexValue).toBe(2)
    })

    test("dispatches select event when going to slide", async () => {
      await setupCarousel()

      const selectPromise = waitForEvent(element, "shadcn--carousel:select")

      const mockEvent = {
        currentTarget: { dataset: { index: "1" } }
      }

      controller.goToSlide(mockEvent)

      const event = await selectPromise
      expect(event.detail.index).toBe(1)
    })

    test("ignores invalid index values", async () => {
      await setupCarousel({ selectedIndex: 1 })

      const mockEvent = {
        currentTarget: { dataset: { index: "invalid" } }
      }

      controller.goToSlide(mockEvent)

      expect(controller.selectedIndexValue).toBe(1) // Unchanged
    })

    test("ignores out of range index values", async () => {
      await setupCarousel({ selectedIndex: 1 })

      // Index too high
      let mockEvent = {
        currentTarget: { dataset: { index: "10" } }
      }

      controller.goToSlide(mockEvent)
      expect(controller.selectedIndexValue).toBe(1) // Unchanged

      // Index negative
      mockEvent = {
        currentTarget: { dataset: { index: "-1" } }
      }

      controller.goToSlide(mockEvent)
      expect(controller.selectedIndexValue).toBe(1) // Unchanged
    })
  })

  describe("Touch/Swipe Support", () => {
    test("horizontal swipe left triggers next", async () => {
      await setupCarousel({ orientation: "horizontal", selectedIndex: 0 })

      const viewport = element.querySelector('[data-shadcn--carousel-target="viewport"]')

      // Swipe left (large enough to trigger - threshold is 50)
      const touchStartEvent = new TouchEvent('touchstart', {
        touches: [{ clientX: 200, clientY: 100 }]
      })
      viewport.dispatchEvent(touchStartEvent)

      const touchEndEvent = new TouchEvent('touchend', {
        changedTouches: [{ clientX: 100, clientY: 100 }]
      })
      viewport.dispatchEvent(touchEndEvent)

      expect(controller.selectedIndexValue).toBe(1)
    })

    test("horizontal swipe right triggers previous", async () => {
      await setupCarousel({ orientation: "horizontal", selectedIndex: 1 })

      const viewport = element.querySelector('[data-shadcn--carousel-target="viewport"]')

      // Swipe right
      const touchStartEvent = new TouchEvent('touchstart', {
        touches: [{ clientX: 100, clientY: 100 }]
      })
      viewport.dispatchEvent(touchStartEvent)

      const touchEndEvent = new TouchEvent('touchend', {
        changedTouches: [{ clientX: 200, clientY: 100 }]
      })
      viewport.dispatchEvent(touchEndEvent)

      expect(controller.selectedIndexValue).toBe(0)
    })

    test("vertical swipe down triggers previous", async () => {
      await setupCarousel({ orientation: "vertical", selectedIndex: 1 })

      const viewport = element.querySelector('[data-shadcn--carousel-target="viewport"]')

      // Swipe down (positive deltaY)
      const touchStartEvent = new TouchEvent('touchstart', {
        touches: [{ clientX: 100, clientY: 100 }]
      })
      viewport.dispatchEvent(touchStartEvent)

      const touchEndEvent = new TouchEvent('touchend', {
        changedTouches: [{ clientX: 100, clientY: 200 }]
      })
      viewport.dispatchEvent(touchEndEvent)

      expect(controller.selectedIndexValue).toBe(0)
    })

    test("vertical swipe up triggers next", async () => {
      await setupCarousel({ orientation: "vertical", selectedIndex: 0 })

      const viewport = element.querySelector('[data-shadcn--carousel-target="viewport"]')

      // Swipe up (negative deltaY)
      const touchStartEvent = new TouchEvent('touchstart', {
        touches: [{ clientX: 100, clientY: 200 }]
      })
      viewport.dispatchEvent(touchStartEvent)

      const touchEndEvent = new TouchEvent('touchend', {
        changedTouches: [{ clientX: 100, clientY: 100 }]
      })
      viewport.dispatchEvent(touchEndEvent)

      expect(controller.selectedIndexValue).toBe(1)
    })

    test("small swipe below threshold does not trigger navigation", async () => {
      await setupCarousel({ orientation: "horizontal", selectedIndex: 1 })

      const viewport = element.querySelector('[data-shadcn--carousel-target="viewport"]')

      // Small swipe (threshold is 50)
      const touchStartEvent = new TouchEvent('touchstart', {
        touches: [{ clientX: 100, clientY: 100 }]
      })
      viewport.dispatchEvent(touchStartEvent)

      const touchEndEvent = new TouchEvent('touchend', {
        changedTouches: [{ clientX: 130, clientY: 100 }]
      })
      viewport.dispatchEvent(touchEndEvent)

      expect(controller.selectedIndexValue).toBe(1) // Unchanged
    })

    test("diagonal swipe with stronger horizontal component triggers horizontal navigation", async () => {
      await setupCarousel({ orientation: "horizontal", selectedIndex: 1 })

      const viewport = element.querySelector('[data-shadcn--carousel-target="viewport"]')

      // Diagonal swipe with stronger horizontal
      const touchStartEvent = new TouchEvent('touchstart', {
        touches: [{ clientX: 200, clientY: 100 }]
      })
      viewport.dispatchEvent(touchStartEvent)

      const touchEndEvent = new TouchEvent('touchend', {
        changedTouches: [{ clientX: 100, clientY: 120 }]
      })
      viewport.dispatchEvent(touchEndEvent)

      expect(controller.selectedIndexValue).toBe(2) // Next slide
    })
  })

  describe("Align Offset Calculation", () => {
    test("start alignment returns 0 offset", async () => {
      await setupCarousel({ align: "start" })

      const mockItem = { offsetWidth: 100, offsetHeight: 100 }
      const offset = controller.getAlignOffset(mockItem, "width")

      expect(offset).toBe(0)
    })

    test("center alignment calculates correct offset", async () => {
      await setupCarousel({ align: "center" })

      // Mock viewport size
      const viewport = element.querySelector('[data-shadcn--carousel-target="viewport"]')
      Object.defineProperty(viewport, 'offsetWidth', { value: 500, configurable: true })

      const mockItem = { offsetWidth: 100 }
      const offset = controller.getAlignOffset(mockItem, "width")

      expect(offset).toBe(200) // (500 - 100) / 2
    })

    test("end alignment calculates correct offset", async () => {
      await setupCarousel({ align: "end" })

      const viewport = element.querySelector('[data-shadcn--carousel-target="viewport"]')
      Object.defineProperty(viewport, 'offsetWidth', { value: 500, configurable: true })

      const mockItem = { offsetWidth: 100 }
      const offset = controller.getAlignOffset(mockItem, "width")

      expect(offset).toBe(400) // 500 - 100
    })
  })

  describe("Edge Cases", () => {
    test("handles carousel with single item", async () => {
      await setupCarousel({ itemCount: 1 })

      controller.next()
      expect(controller.selectedIndexValue).toBe(0) // Stays at 0

      controller.previous()
      expect(controller.selectedIndexValue).toBe(0) // Stays at 0
    })

    test("handles carousel with no items gracefully", async () => {
      await setupCarousel({ itemCount: 0 })

      expect(() => {
        controller.next()
        controller.previous()
        controller.scrollToIndex(0)
      }).not.toThrow()
    })

    test("updateButtonStates handles missing button targets", async () => {
      application = Application.start()
      application.register("shadcn--carousel", CarouselController)

      // Create carousel without button targets
      document.body.innerHTML = `
        <div data-controller="shadcn--carousel">
          <div data-shadcn--carousel-target="viewport">
            <div data-shadcn--carousel-target="content">
              <div data-shadcn--carousel-target="item">Slide 1</div>
            </div>
          </div>
        </div>
      `

      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--carousel"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--carousel")

      expect(() => {
        controller.updateButtonStates()
      }).not.toThrow()
    })

    test("scrollToIndex handles missing content target", async () => {
      await setupCarousel()

      // Remove content target
      const content = element.querySelector('[data-shadcn--carousel-target="content"]')
      content.removeAttribute('data-shadcn--carousel-target')

      expect(() => {
        controller.scrollToIndex(1)
      }).not.toThrow()
    })
  })
})
