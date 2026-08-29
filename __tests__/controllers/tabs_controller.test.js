import { Application } from "@hotwired/stimulus"
import TabsController from "../../app/assets/javascripts/shadcn/controllers/tabs_controller.ts"
import { setupController, cleanupController, click, wait, nextFrame, keydown, mockLocation, mockHistory, waitForEvent } from '../helpers/stimulus-test-helper.js'

describe("TabsController", () => {
  let application
  let element
  let controller

  const createTabsHTML = (options = {}) => {
    const {
      defaultValue = "tab1",
      urlParam = null,
      tabCount = 3
    } = options

    const urlParamAttr = urlParam ? `data-shadcn--tabs-url-param-value="${urlParam}"` : ''

    const triggers = Array.from({ length: tabCount }, (_, i) => {
      const tabNum = i + 1
      return `<button data-shadcn--tabs-target="trigger" data-value="tab${tabNum}" role="tab" data-action="click->shadcn--tabs#selectTab keydown->shadcn--tabs#handleKeydown">Tab ${tabNum}</button>`
    }).join('\n')

    const contents = Array.from({ length: tabCount }, (_, i) => {
      const tabNum = i + 1
      const hidden = tabNum === 1 ? '' : 'hidden'
      return `<div data-shadcn--tabs-target="content" data-value="tab${tabNum}" role="tabpanel" ${hidden}>Content ${tabNum}</div>`
    }).join('\n')

    return `
      <div data-controller="shadcn--tabs"
           data-shadcn--tabs-default-value-value="${defaultValue}"
           ${urlParamAttr}>
        <div data-shadcn--tabs-target="list" role="tablist">
          ${triggers}
        </div>
        ${contents}
      </div>
    `
  }

  beforeEach(async () => {
    application = Application.start()
    application.register("shadcn--tabs", TabsController)
    document.body.innerHTML = createTabsHTML()

    await new Promise(resolve => requestAnimationFrame(resolve))

    element = document.querySelector('[data-controller="shadcn--tabs"]')
    controller = application.getControllerForElementAndIdentifier(element, "shadcn--tabs")
  })

  afterEach(() => {
    if (application) {
      application.stop()
    }
    document.body.innerHTML = ""
  })

  describe("initialization", () => {
    test("connects successfully", () => {
      expect(controller).not.toBeNull()
      expect(controller).toBeDefined()
    })

    test("initializes with default value", () => {
      const trigger = element.querySelector('[data-value="tab1"]')
      expect(trigger.dataset.state).toBe("active")
      expect(trigger.getAttribute("aria-selected")).toBe("true")
      expect(trigger.tabIndex).toBe(0)
    })

    test("sets first tab as active when no default value", async () => {
      application.stop()
      document.body.innerHTML = createTabsHTML({ defaultValue: "" })

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')
      const trigger = element.querySelector('[data-value="tab1"]')

      expect(trigger.dataset.state).toBe("active")
    })

    test("initializes inactive tabs correctly", () => {
      const tab2 = element.querySelector('[data-value="tab2"]')
      const tab3 = element.querySelector('[data-value="tab3"]')

      expect(tab2.dataset.state).toBe("inactive")
      expect(tab2.getAttribute("aria-selected")).toBe("false")
      expect(tab2.tabIndex).toBe(-1)

      expect(tab3.dataset.state).toBe("inactive")
      expect(tab3.getAttribute("aria-selected")).toBe("false")
      expect(tab3.tabIndex).toBe(-1)
    })

    test("shows correct content panel on initialization", () => {
      const content1 = element.querySelector('[data-shadcn--tabs-target="content"][data-value="tab1"]')
      const content2 = element.querySelector('[data-shadcn--tabs-target="content"][data-value="tab2"]')
      const content3 = element.querySelector('[data-shadcn--tabs-target="content"][data-value="tab3"]')

      expect(content1.dataset.state).toBe("active")
      expect(content1.hidden).toBe(false)

      expect(content2.dataset.state).toBe("inactive")
      expect(content2.hidden).toBe(true)

      expect(content3.dataset.state).toBe("inactive")
      expect(content3.hidden).toBe(true)
    })

    test("validates initial value and falls back to default if invalid", async () => {
      application.stop()

      const restoreLocation = mockLocation("http://localhost?tab=invalid")

      document.body.innerHTML = `
        <div data-controller="shadcn--tabs"
             data-shadcn--tabs-default-value-value="tab2"
             data-shadcn--tabs-url-param-value="tab">
          <div data-shadcn--tabs-target="list" role="tablist">
            <button data-shadcn--tabs-target="trigger" data-value="tab1" role="tab" data-action="click->shadcn--tabs#selectTab">Tab 1</button>
            <button data-shadcn--tabs-target="trigger" data-value="tab2" role="tab" data-action="click->shadcn--tabs#selectTab">Tab 2</button>
          </div>
          <div data-shadcn--tabs-target="content" data-value="tab1" role="tabpanel">Content 1</div>
          <div data-shadcn--tabs-target="content" data-value="tab2" role="tabpanel" hidden>Content 2</div>
        </div>
      `

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')

      // Should fall back to default value "tab2"
      const tab2 = element.querySelector('[data-value="tab2"]')
      expect(tab2.dataset.state).toBe("active")

      restoreLocation()
    })
  })

  describe("tab switching", () => {
    test("switches to clicked tab", () => {
      const tab2Trigger = element.querySelector('[data-value="tab2"]')
      click(tab2Trigger)

      expect(tab2Trigger.dataset.state).toBe("active")
      expect(tab2Trigger.getAttribute("aria-selected")).toBe("true")
      expect(tab2Trigger.tabIndex).toBe(0)
    })

    test("deactivates previously active tab", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      const tab2 = element.querySelector('[data-value="tab2"]')

      expect(tab1.dataset.state).toBe("active")

      click(tab2)

      expect(tab1.dataset.state).toBe("inactive")
      expect(tab1.getAttribute("aria-selected")).toBe("false")
      expect(tab1.tabIndex).toBe(-1)
    })

    test("shows correct content panel when tab is clicked", () => {
      const tab2Trigger = element.querySelector('[data-value="tab2"]')
      const content1 = element.querySelector('[data-shadcn--tabs-target="content"][data-value="tab1"]')
      const content2 = element.querySelector('[data-shadcn--tabs-target="content"][data-value="tab2"]')

      click(tab2Trigger)

      expect(content1.dataset.state).toBe("inactive")
      expect(content1.hidden).toBe(true)

      expect(content2.dataset.state).toBe("active")
      expect(content2.hidden).toBe(false)
    })

    test("can switch between multiple tabs", () => {
      const tab2 = element.querySelector('[data-value="tab2"]')
      const tab3 = element.querySelector('[data-value="tab3"]')
      const tab1 = element.querySelector('[data-value="tab1"]')

      click(tab2)
      expect(tab2.dataset.state).toBe("active")

      click(tab3)
      expect(tab3.dataset.state).toBe("active")
      expect(tab2.dataset.state).toBe("inactive")

      click(tab1)
      expect(tab1.dataset.state).toBe("active")
      expect(tab3.dataset.state).toBe("inactive")
    })

    test("dispatches change event with correct value", async () => {
      const tab2 = element.querySelector('[data-value="tab2"]')

      const eventPromise = waitForEvent(element, "shadcn--tabs:change")

      click(tab2)

      const event = await eventPromise
      expect(event.detail.value).toBe("tab2")
    })

    test("dispatches change event when switching tabs", async () => {
      const tab2 = element.querySelector('[data-value="tab2"]')

      let changeEventFired = false
      element.addEventListener("shadcn--tabs:change", () => {
        changeEventFired = true
      })

      click(tab2)

      await nextFrame()

      expect(changeEventFired).toBe(true)
    })
  })

  describe("content visibility", () => {
    test("only selected tab content is visible", () => {
      const allContents = element.querySelectorAll('[data-shadcn--tabs-target="content"]')

      // Initially tab1 is active
      expect(allContents[0].hidden).toBe(false)
      expect(allContents[1].hidden).toBe(true)
      expect(allContents[2].hidden).toBe(true)
    })

    test("content visibility updates when switching tabs", () => {
      const tab3 = element.querySelector('[data-value="tab3"]')
      const allContents = element.querySelectorAll('[data-shadcn--tabs-target="content"]')

      click(tab3)

      expect(allContents[0].hidden).toBe(true)
      expect(allContents[1].hidden).toBe(true)
      expect(allContents[2].hidden).toBe(false)
    })

    test("content state attribute matches visibility", () => {
      const tab2 = element.querySelector('[data-value="tab2"]')
      const content2 = element.querySelector('[data-shadcn--tabs-target="content"][data-value="tab2"]')

      click(tab2)

      expect(content2.dataset.state).toBe("active")
      expect(content2.hidden).toBe(false)
    })
  })

  describe("URL sync", () => {
    let historyMock
    let restoreLocation

    beforeEach(async () => {
      application.stop()
      document.body.innerHTML = ""

      // Mock window.location
      restoreLocation = mockLocation("http://localhost/")

      // Mock history methods
      historyMock = mockHistory()

      // Create tabs with URL param
      document.body.innerHTML = createTabsHTML({ urlParam: "tab" })

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tabs")
    })

    afterEach(() => {
      historyMock.restore()
      restoreLocation()
    })

    test("updates URL when tab is clicked", () => {
      const tab2 = element.querySelector('[data-value="tab2"]')
      click(tab2)

      expect(historyMock.calls.replaceState.length).toBe(1)
      expect(historyMock.calls.replaceState[0].url).toContain("tab=tab2")
    })

    test("does not update URL on initial load", () => {
      // Should not have called replaceState during initialization
      expect(historyMock.calls.replaceState.length).toBe(0)
    })

    test("reads initial tab from URL parameter", async () => {
      application.stop()
      historyMock.restore()
      restoreLocation()

      const newRestoreLocation = mockLocation("http://localhost?tab=tab3")
      const newHistoryMock = mockHistory()

      document.body.innerHTML = createTabsHTML({ urlParam: "tab" })

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')

      const tab3 = element.querySelector('[data-value="tab3"]')
      expect(tab3.dataset.state).toBe("active")

      newHistoryMock.restore()
      newRestoreLocation()

      // Re-initialize for next tests
      historyMock = mockHistory()
      restoreLocation = mockLocation("http://localhost/")
    })

    test("URL parameter takes precedence over default value", async () => {
      application.stop()
      historyMock.restore()
      restoreLocation()

      const newRestoreLocation = mockLocation("http://localhost?tab=tab2")
      const newHistoryMock = mockHistory()

      document.body.innerHTML = createTabsHTML({ defaultValue: "tab1", urlParam: "tab" })

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')

      const tab2 = element.querySelector('[data-value="tab2"]')
      expect(tab2.dataset.state).toBe("active")

      newHistoryMock.restore()
      newRestoreLocation()

      // Re-initialize for next tests
      historyMock = mockHistory()
      restoreLocation = mockLocation("http://localhost/")
    })

    test("does not update URL when urlParam is not set", async () => {
      application.stop()
      historyMock.restore()
      historyMock = mockHistory()

      document.body.innerHTML = createTabsHTML() // No urlParam

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')

      const tab2 = element.querySelector('[data-value="tab2"]')
      click(tab2)

      expect(historyMock.calls.replaceState.length).toBe(0)
    })

    test("handles popstate event for browser navigation", async () => {
      // Start with tab1 active
      const tab1 = element.querySelector('[data-value="tab1"]')
      const tab2 = element.querySelector('[data-value="tab2"]')

      expect(tab1.dataset.state).toBe("active")

      // Update the mocked location to have tab2 in the URL
      historyMock.restore()
      restoreLocation()

      const newRestoreLocation = mockLocation("http://localhost?tab=tab2")
      const newHistoryMock = mockHistory()

      // Re-get the element reference since we're in a new context
      element = document.querySelector('[data-controller="shadcn--tabs"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tabs")

      // Simulate browser back/forward by firing popstate
      window.dispatchEvent(new PopStateEvent('popstate'))

      await nextFrame()

      // Controller should react to popstate and switch tabs
      const newTab2 = element.querySelector('[data-value="tab2"]')
      const newTab1 = element.querySelector('[data-value="tab1"]')

      expect(newTab2.dataset.state).toBe("active")
      expect(newTab1.dataset.state).toBe("inactive")

      newHistoryMock.restore()
      newRestoreLocation()

      // Re-initialize for next tests
      historyMock = mockHistory()
      restoreLocation = mockLocation("http://localhost/")
    })

    test("cleans up popstate listener on disconnect", () => {
      let popstateRemoved = false
      const originalRemove = window.removeEventListener

      window.removeEventListener = function(event) {
        if (event === 'popstate') {
          popstateRemoved = true
        }
        return originalRemove.apply(this, arguments)
      }

      controller.disconnect()

      // Should have removed the popstate listener
      expect(popstateRemoved).toBe(true)

      window.removeEventListener = originalRemove
    })

    test("does not add popstate listener when urlParam is not set", async () => {
      application.stop()
      historyMock.restore()
      restoreLocation()

      let popstateAdded = false
      const originalAdd = window.addEventListener

      window.addEventListener = function(event) {
        if (event === 'popstate') {
          popstateAdded = true
        }
        return originalAdd.apply(this, arguments)
      }

      document.body.innerHTML = createTabsHTML() // No urlParam

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      // Should not have added popstate listener
      expect(popstateAdded).toBe(false)

      window.addEventListener = originalAdd

      // Re-initialize for potential next tests in URL sync suite
      historyMock = mockHistory()
      restoreLocation = mockLocation("http://localhost/")
    })
  })

  describe("keyboard navigation", () => {
    test("ArrowRight moves to next tab", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      const tab2 = element.querySelector('[data-value="tab2"]')

      tab1.focus()
      keydown(tab1, 'ArrowRight')

      expect(document.activeElement).toBe(tab2)
      expect(tab2.dataset.state).toBe("active")
    })

    test("ArrowLeft moves to previous tab", () => {
      const tab2 = element.querySelector('[data-value="tab2"]')
      const tab1 = element.querySelector('[data-value="tab1"]')

      // First switch to tab2
      click(tab2)
      tab2.focus()

      keydown(tab2, 'ArrowLeft')

      expect(document.activeElement).toBe(tab1)
      expect(tab1.dataset.state).toBe("active")
    })

    test("ArrowDown moves to next tab", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      const tab2 = element.querySelector('[data-value="tab2"]')

      tab1.focus()
      keydown(tab1, 'ArrowDown')

      expect(document.activeElement).toBe(tab2)
      expect(tab2.dataset.state).toBe("active")
    })

    test("ArrowUp moves to previous tab", () => {
      const tab2 = element.querySelector('[data-value="tab2"]')
      const tab1 = element.querySelector('[data-value="tab1"]')

      click(tab2)
      tab2.focus()

      keydown(tab2, 'ArrowUp')

      expect(document.activeElement).toBe(tab1)
      expect(tab1.dataset.state).toBe("active")
    })

    test("ArrowRight wraps from last to first tab", () => {
      const tab3 = element.querySelector('[data-value="tab3"]')
      const tab1 = element.querySelector('[data-value="tab1"]')

      click(tab3)
      tab3.focus()

      keydown(tab3, 'ArrowRight')

      expect(document.activeElement).toBe(tab1)
      expect(tab1.dataset.state).toBe("active")
    })

    test("ArrowLeft wraps from first to last tab", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      const tab3 = element.querySelector('[data-value="tab3"]')

      tab1.focus()

      keydown(tab1, 'ArrowLeft')

      expect(document.activeElement).toBe(tab3)
      expect(tab3.dataset.state).toBe("active")
    })

    test("Home key moves to first tab", () => {
      const tab3 = element.querySelector('[data-value="tab3"]')
      const tab1 = element.querySelector('[data-value="tab1"]')

      click(tab3)
      tab3.focus()

      keydown(tab3, 'Home')

      expect(document.activeElement).toBe(tab1)
      expect(tab1.dataset.state).toBe("active")
    })

    test("End key moves to last tab", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      const tab3 = element.querySelector('[data-value="tab3"]')

      tab1.focus()

      keydown(tab1, 'End')

      expect(document.activeElement).toBe(tab3)
      expect(tab3.dataset.state).toBe("active")
    })

    test("keyboard navigation triggers click to update content", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      const content2 = element.querySelector('[data-shadcn--tabs-target="content"][data-value="tab2"]')

      tab1.focus()
      keydown(tab1, 'ArrowRight')

      // Content should have switched
      expect(content2.hidden).toBe(false)
      expect(content2.dataset.state).toBe("active")
    })

    test("does not handle keyboard events when no tab is focused", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      const tab2 = element.querySelector('[data-value="tab2"]')

      // Don't focus any tab
      document.body.focus()

      keydown(element, 'ArrowRight')

      // Should still be on tab1
      expect(tab1.dataset.state).toBe("active")
      expect(tab2.dataset.state).toBe("inactive")
    })

    test("ignores other keys", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')

      tab1.focus()

      keydown(tab1, 'Enter')
      expect(tab1.dataset.state).toBe("active")

      keydown(tab1, ' ')
      expect(tab1.dataset.state).toBe("active")

      keydown(tab1, 'Tab')
      expect(tab1.dataset.state).toBe("active")
    })

    test("skips disabled tabs when navigating", async () => {
      // Create tabs with disabled trigger
      application.stop()
      document.body.innerHTML = `
        <div data-controller="shadcn--tabs"
             data-shadcn--tabs-default-value-value="tab1">
          <div data-shadcn--tabs-target="list" role="tablist">
            <button data-shadcn--tabs-target="trigger" data-value="tab1" role="tab" data-action="click->shadcn--tabs#selectTab keydown->shadcn--tabs#handleKeydown">Tab 1</button>
            <button data-shadcn--tabs-target="trigger" data-value="tab2" role="tab" disabled data-action="click->shadcn--tabs#selectTab keydown->shadcn--tabs#handleKeydown">Tab 2</button>
            <button data-shadcn--tabs-target="trigger" data-value="tab3" role="tab" data-action="click->shadcn--tabs#selectTab keydown->shadcn--tabs#handleKeydown">Tab 3</button>
          </div>
          <div data-shadcn--tabs-target="content" data-value="tab1" role="tabpanel">Content 1</div>
          <div data-shadcn--tabs-target="content" data-value="tab2" role="tabpanel" hidden>Content 2</div>
          <div data-shadcn--tabs-target="content" data-value="tab3" role="tabpanel" hidden>Content 3</div>
        </div>
      `

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')

      const tab1 = element.querySelector('[data-value="tab1"]')
      const tab3 = element.querySelector('[data-value="tab3"]')

      tab1.focus()
      keydown(tab1, 'ArrowRight')

      // Should skip disabled tab2 and go to tab3
      expect(document.activeElement).toBe(tab3)
      expect(tab3.dataset.state).toBe("active")
    })

    test("keyboard navigation prevents default behavior", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      tab1.focus()

      let preventDefaultCalled = false

      const event = new KeyboardEvent('keydown', {
        key: 'ArrowRight',
        bubbles: true,
        cancelable: true
      })

      // Override preventDefault to track if it was called
      const originalPreventDefault = event.preventDefault
      event.preventDefault = function() {
        preventDefaultCalled = true
        return originalPreventDefault.apply(this, arguments)
      }

      tab1.dispatchEvent(event)

      expect(preventDefaultCalled).toBe(true)
    })
  })

  describe("ARIA attributes", () => {
    test("triggers have correct role", () => {
      const triggers = element.querySelectorAll('[data-shadcn--tabs-target="trigger"]')

      triggers.forEach(trigger => {
        expect(trigger.getAttribute("role")).toBe("tab")
      })
    })

    test("list has correct role", () => {
      const list = element.querySelector('[data-shadcn--tabs-target="list"]')
      expect(list.getAttribute("role")).toBe("tablist")
    })

    test("content panels have correct role", () => {
      const contents = element.querySelectorAll('[data-shadcn--tabs-target="content"]')

      contents.forEach(content => {
        expect(content.getAttribute("role")).toBe("tabpanel")
      })
    })

    test("active tab has aria-selected=true", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      expect(tab1.getAttribute("aria-selected")).toBe("true")
    })

    test("inactive tabs have aria-selected=false", () => {
      const tab2 = element.querySelector('[data-value="tab2"]')
      const tab3 = element.querySelector('[data-value="tab3"]')

      expect(tab2.getAttribute("aria-selected")).toBe("false")
      expect(tab3.getAttribute("aria-selected")).toBe("false")
    })

    test("aria-selected updates when tab is clicked", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      const tab2 = element.querySelector('[data-value="tab2"]')

      click(tab2)

      expect(tab1.getAttribute("aria-selected")).toBe("false")
      expect(tab2.getAttribute("aria-selected")).toBe("true")
    })

    test("active tab has tabIndex 0", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      expect(tab1.tabIndex).toBe(0)
    })

    test("inactive tabs have tabIndex -1", () => {
      const tab2 = element.querySelector('[data-value="tab2"]')
      const tab3 = element.querySelector('[data-value="tab3"]')

      expect(tab2.tabIndex).toBe(-1)
      expect(tab3.tabIndex).toBe(-1)
    })

    test("tabIndex updates when switching tabs", () => {
      const tab1 = element.querySelector('[data-value="tab1"]')
      const tab2 = element.querySelector('[data-value="tab2"]')

      click(tab2)

      expect(tab1.tabIndex).toBe(-1)
      expect(tab2.tabIndex).toBe(0)
    })
  })

  describe("default value", () => {
    test("respects custom default value", async () => {
      application.stop()
      document.body.innerHTML = createTabsHTML({ defaultValue: "tab2" })

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')

      const tab2 = element.querySelector('[data-value="tab2"]')
      expect(tab2.dataset.state).toBe("active")
    })

    test("uses first tab when default value is empty", async () => {
      application.stop()
      document.body.innerHTML = createTabsHTML({ defaultValue: "" })

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')

      const tab1 = element.querySelector('[data-value="tab1"]')
      expect(tab1.dataset.state).toBe("active")
    })

    test("falls back to default or first tab if value is invalid", async () => {
      application.stop()
      document.body.innerHTML = createTabsHTML({ defaultValue: "tab2" })

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')

      // Should use the valid default value (tab2)
      const tab2 = element.querySelector('[data-value="tab2"]')
      expect(tab2.dataset.state).toBe("active")
    })
  })

  describe("edge cases", () => {
    test("handles single tab gracefully", async () => {
      application.stop()
      document.body.innerHTML = createTabsHTML({ tabCount: 1 })

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')

      const tab1 = element.querySelector('[data-value="tab1"]')
      expect(tab1.dataset.state).toBe("active")

      // Keyboard navigation should stay on same tab
      tab1.focus()
      keydown(tab1, 'ArrowRight')
      expect(document.activeElement).toBe(tab1)

      keydown(tab1, 'ArrowLeft')
      expect(document.activeElement).toBe(tab1)
    })

    test("handles many tabs", async () => {
      application.stop()
      document.body.innerHTML = createTabsHTML({ tabCount: 10 })

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')

      const tab10 = element.querySelector('[data-value="tab10"]')
      click(tab10)

      expect(tab10.dataset.state).toBe("active")

      // End key should work
      const tab1 = element.querySelector('[data-value="tab1"]')
      click(tab1)
      tab1.focus()

      keydown(tab1, 'End')
      expect(document.activeElement).toBe(tab10)
    })

    test("selectTabByValue method works correctly", () => {
      controller.selectTabByValue("tab3")

      const tab3 = element.querySelector('[data-value="tab3"]')
      const content3 = element.querySelector('[data-shadcn--tabs-target="content"][data-value="tab3"]')

      expect(tab3.dataset.state).toBe("active")
      expect(content3.hidden).toBe(false)
    })

    test("selectTabByValue with updateUrl=false does not update URL", async () => {
      application.stop()

      // Set up mocks in correct order: location first, then history
      const localRestoreLocation = mockLocation("http://localhost/")
      const localHistoryMock = mockHistory()

      document.body.innerHTML = createTabsHTML({ urlParam: "tab" })

      application = Application.start()
      application.register("shadcn--tabs", TabsController)

      await new Promise(resolve => requestAnimationFrame(resolve))

      element = document.querySelector('[data-controller="shadcn--tabs"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--tabs")

      // Clear any calls from initialization
      localHistoryMock.calls.replaceState = []

      controller.selectTabByValue("tab2", false)

      expect(localHistoryMock.calls.replaceState.length).toBe(0)

      localHistoryMock.restore()
      localRestoreLocation()
    })

    test("handles rapid tab switching", async () => {
      const tab2 = element.querySelector('[data-value="tab2"]')
      const tab3 = element.querySelector('[data-value="tab3"]')
      const tab1 = element.querySelector('[data-value="tab1"]')

      click(tab2)
      click(tab3)
      click(tab1)
      click(tab2)

      await nextFrame()

      expect(tab2.dataset.state).toBe("active")
      const content2 = element.querySelector('[data-shadcn--tabs-target="content"][data-value="tab2"]')
      expect(content2.hidden).toBe(false)
    })
  })

  describe("snapshots", () => {
    test("renders default tabs correctly", () => {
      expect(element.innerHTML).toMatchSnapshot()
    })

    test("renders tabs with tab2 active", () => {
      const tab2 = element.querySelector('[data-value="tab2"]')
      click(tab2)

      expect(element.innerHTML).toMatchSnapshot()
    })
  })
})
