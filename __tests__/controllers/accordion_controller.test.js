import { Application } from "@hotwired/stimulus"
import AccordionController from "../../app/assets/javascripts/shadcn/controllers/accordion_controller.ts"
import { click, wait, nextFrame, keydown, waitForEvent } from '../helpers/stimulus-test-helper.js'

describe("AccordionController", () => {
  let application
  let element
  let controller

  const createAccordionHTML = (type = "single", collapsible = false, defaultValue = "") => {
    const collapsibleAttr = collapsible ? `data-shadcn--accordion-collapsible-value="true"` : ''
    const defaultAttr = defaultValue ? `data-shadcn--accordion-default-value="${defaultValue}"` : ''

    return `
      <div data-controller="shadcn--accordion"
           data-shadcn--accordion-type-value="${type}"
           ${collapsibleAttr}
           ${defaultAttr}>
        <div data-shadcn--accordion-target="item" data-value="item-1" data-state="closed">
          <button data-shadcn--accordion-target="trigger"
                  data-action="click->shadcn--accordion#toggle keydown->shadcn--accordion#handleKeydown"
                  aria-expanded="false">
            Trigger 1
          </button>
          <div data-shadcn--accordion-target="content" hidden>Content 1</div>
        </div>
        <div data-shadcn--accordion-target="item" data-value="item-2" data-state="closed">
          <button data-shadcn--accordion-target="trigger"
                  data-action="click->shadcn--accordion#toggle keydown->shadcn--accordion#handleKeydown"
                  aria-expanded="false">
            Trigger 2
          </button>
          <div data-shadcn--accordion-target="content" hidden>Content 2</div>
        </div>
        <div data-shadcn--accordion-target="item" data-value="item-3" data-state="closed">
          <button data-shadcn--accordion-target="trigger"
                  data-action="click->shadcn--accordion#toggle keydown->shadcn--accordion#handleKeydown"
                  aria-expanded="false">
            Trigger 3
          </button>
          <div data-shadcn--accordion-target="content" hidden>Content 3</div>
        </div>
      </div>
    `
  }

  beforeEach(async () => {
    application = Application.start()
    application.register("shadcn--accordion", AccordionController)
    document.body.innerHTML = createAccordionHTML()

    await nextFrame()

    element = document.querySelector('[data-controller="shadcn--accordion"]')
    controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")
  })

  afterEach(() => {
    if (application) {
      application.stop()
    }
    document.body.innerHTML = ""
  })

  describe("value initialization", () => {
    test("initializes with default type value of 'single'", () => {
      expect(controller.typeValue).toBe("single")
    })

    test("initializes with default collapsible value of false", () => {
      expect(controller.collapsibleValue).toBe(false)
    })

    test("initializes with empty default value", () => {
      expect(controller.defaultValue).toBe("")
    })

    test("accepts custom type value", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("multiple")

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      expect(controller.typeValue).toBe("multiple")
    })

    test("accepts collapsible value", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("single", true)

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      expect(controller.collapsibleValue).toBe(true)
    })
  })

  describe("default values", () => {
    test("expands single item on connect with default value", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("single", false, "item-2")

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const item2 = element.querySelector('[data-value="item-2"]')
      expect(item2.dataset.state).toBe("open")
    })

    test("expands multiple items on connect with comma-separated default values", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("multiple", false, "item-1, item-3")

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const item1 = element.querySelector('[data-value="item-1"]')
      const item3 = element.querySelector('[data-value="item-3"]')

      expect(item1.dataset.state).toBe("open")
      expect(item3.dataset.state).toBe("open")
    })

    test("handles whitespace in comma-separated default values", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("multiple", false, "item-1,  item-2  , item-3")

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const item1 = element.querySelector('[data-value="item-1"]')
      const item2 = element.querySelector('[data-value="item-2"]')
      const item3 = element.querySelector('[data-value="item-3"]')

      expect(item1.dataset.state).toBe("open")
      expect(item2.dataset.state).toBe("open")
      expect(item3.dataset.state).toBe("open")
    })

    test("ignores invalid default values gracefully", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("multiple", false, "item-1, invalid-item, item-3")

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const item1 = element.querySelector('[data-value="item-1"]')
      const item3 = element.querySelector('[data-value="item-3"]')

      // Valid items should still be expanded
      expect(item1.dataset.state).toBe("open")
      expect(item3.dataset.state).toBe("open")
    })
  })

  describe("single mode", () => {
    test("expands an item when clicked", () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const item1 = element.querySelector('[data-value="item-1"]')

      click(trigger1)

      expect(item1.dataset.state).toBe("open")
    })

    test("collapses other items when expanding one", async () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const trigger2 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[1]
      const item1 = element.querySelector('[data-value="item-1"]')
      const item2 = element.querySelector('[data-value="item-2"]')

      // Expand first item
      click(trigger1)
      expect(item1.dataset.state).toBe("open")

      // Expand second item - should collapse first
      click(trigger2)
      await nextFrame()

      expect(item2.dataset.state).toBe("open")
      expect(item1.dataset.state).toBe("closed")
    })

    test("does not collapse open item when collapsible is false", () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const item1 = element.querySelector('[data-value="item-1"]')

      // Expand item
      click(trigger1)
      expect(item1.dataset.state).toBe("open")

      // Try to collapse - should remain open
      click(trigger1)
      expect(item1.dataset.state).toBe("open")
    })

    test("collapses open item when collapsible is true", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("single", true)

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const item1 = element.querySelector('[data-value="item-1"]')

      // Expand item
      click(trigger1)
      expect(item1.dataset.state).toBe("open")

      // Collapse item
      click(trigger1)
      await nextFrame()

      expect(item1.dataset.state).toBe("closed")
    })

    test("updates aria-expanded on trigger when expanding", () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]

      click(trigger1)

      expect(trigger1.getAttribute("aria-expanded")).toBe("true")
    })

    test("updates aria-expanded on trigger when collapsing", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("single", true)

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]

      // Expand then collapse
      click(trigger1)
      click(trigger1)
      await nextFrame()

      expect(trigger1.getAttribute("aria-expanded")).toBe("false")
    })

    test("sets data-state on content when expanding", () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const content1 = element.querySelectorAll('[data-shadcn--accordion-target="content"]')[0]

      click(trigger1)

      expect(content1.dataset.state).toBe("open")
    })

    test("removes hidden attribute from content when expanding", () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const content1 = element.querySelectorAll('[data-shadcn--accordion-target="content"]')[0]

      click(trigger1)

      expect(content1.hidden).toBe(false)
    })
  })

  describe("multiple mode", () => {
    beforeEach(async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("multiple")

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")
    })

    test("can expand multiple items simultaneously", () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const trigger2 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[1]
      const item1 = element.querySelector('[data-value="item-1"]')
      const item2 = element.querySelector('[data-value="item-2"]')

      click(trigger1)
      click(trigger2)

      expect(item1.dataset.state).toBe("open")
      expect(item2.dataset.state).toBe("open")
    })

    test("does not collapse other items when expanding", () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const trigger2 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[1]
      const trigger3 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[2]
      const item1 = element.querySelector('[data-value="item-1"]')
      const item2 = element.querySelector('[data-value="item-2"]')
      const item3 = element.querySelector('[data-value="item-3"]')

      click(trigger1)
      click(trigger2)
      click(trigger3)

      expect(item1.dataset.state).toBe("open")
      expect(item2.dataset.state).toBe("open")
      expect(item3.dataset.state).toBe("open")
    })

    test("can collapse individual items", async () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const trigger2 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[1]
      const item1 = element.querySelector('[data-value="item-1"]')
      const item2 = element.querySelector('[data-value="item-2"]')

      // Expand both
      click(trigger1)
      click(trigger2)

      // Collapse first
      click(trigger1)
      await nextFrame()

      expect(item1.dataset.state).toBe("closed")
      expect(item2.dataset.state).toBe("open")
    })

    test("can expand all items then collapse all", async () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      const items = element.querySelectorAll('[data-shadcn--accordion-target="item"]')

      // Expand all
      triggers.forEach(trigger => click(trigger))
      items.forEach(item => expect(item.dataset.state).toBe("open"))

      // Collapse all
      triggers.forEach(trigger => click(trigger))
      await nextFrame()

      items.forEach(item => expect(item.dataset.state).toBe("closed"))
    })
  })

  describe("type safety", () => {
    test("findItemByValue returns correct item", () => {
      const item2 = controller.findItemByValue("item-2")
      expect(item2.dataset.value).toBe("item-2")
    })

    test("findItemByValue returns undefined for non-existent item", () => {
      const item = controller.findItemByValue("non-existent")
      expect(item).toBeUndefined()
    })

    test("handles missing item gracefully in expandItem", () => {
      // Attempt to expand non-existent item should not throw
      expect(() => {
        const fakeItem = document.createElement('div')
        controller.expandItem(fakeItem)
      }).not.toThrow()
    })

    test("handles missing trigger gracefully", () => {
      const item = document.createElement('div')
      item.setAttribute('data-shadcn--accordion-target', 'item')

      expect(() => {
        controller.expandItem(item)
      }).not.toThrow()
    })

    test("handles missing content gracefully", () => {
      const item = document.createElement('div')
      item.setAttribute('data-shadcn--accordion-target', 'item')

      const trigger = document.createElement('button')
      trigger.setAttribute('data-shadcn--accordion-target', 'trigger')
      item.appendChild(trigger)

      expect(() => {
        controller.expandItem(item)
      }).not.toThrow()
    })
  })

  describe("keyboard navigation", () => {
    beforeEach(() => {
      // Focus first trigger
      const firstTrigger = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      firstTrigger.focus()
    })

    test("ArrowDown moves focus to next trigger", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      triggers[0].focus()

      keydown(triggers[0], 'ArrowDown')

      expect(document.activeElement).toBe(triggers[1])
    })

    test("ArrowUp moves focus to previous trigger", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      triggers[1].focus()

      keydown(triggers[1], 'ArrowUp')

      expect(document.activeElement).toBe(triggers[0])
    })

    test("ArrowDown wraps to first trigger from last", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      triggers[2].focus()

      keydown(triggers[2], 'ArrowDown')

      expect(document.activeElement).toBe(triggers[0])
    })

    test("ArrowUp wraps to last trigger from first", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      triggers[0].focus()

      keydown(triggers[0], 'ArrowUp')

      expect(document.activeElement).toBe(triggers[2])
    })

    test("Home moves focus to first trigger", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      triggers[2].focus()

      keydown(triggers[2], 'Home')

      expect(document.activeElement).toBe(triggers[0])
    })

    test("End moves focus to last trigger", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      triggers[0].focus()

      keydown(triggers[0], 'End')

      expect(document.activeElement).toBe(triggers[2])
    })

    test("other keys do not move focus", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      triggers[0].focus()

      keydown(triggers[0], 'Tab')
      expect(document.activeElement).toBe(triggers[0])

      keydown(triggers[0], 'Enter')
      expect(document.activeElement).toBe(triggers[0])

      keydown(triggers[0], 'Escape')
      expect(document.activeElement).toBe(triggers[0])
    })

    test("ArrowDown prevents default behavior", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      triggers[0].focus()

      let defaultPrevented = false
      const event = new KeyboardEvent('keydown', {
        key: 'ArrowDown',
        bubbles: true,
        cancelable: true
      })

      // Override preventDefault to track if it was called
      event.preventDefault = () => { defaultPrevented = true }
      triggers[0].dispatchEvent(event)

      expect(defaultPrevented).toBe(true)
    })

    test("ArrowUp prevents default behavior", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      triggers[0].focus()

      let defaultPrevented = false
      const event = new KeyboardEvent('keydown', {
        key: 'ArrowUp',
        bubbles: true,
        cancelable: true
      })

      // Override preventDefault to track if it was called
      event.preventDefault = () => { defaultPrevented = true }
      triggers[0].dispatchEvent(event)

      expect(defaultPrevented).toBe(true)
    })

    test("Home prevents default behavior", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      triggers[0].focus()

      let defaultPrevented = false
      const event = new KeyboardEvent('keydown', {
        key: 'Home',
        bubbles: true,
        cancelable: true
      })

      // Override preventDefault to track if it was called
      event.preventDefault = () => { defaultPrevented = true }
      triggers[0].dispatchEvent(event)

      expect(defaultPrevented).toBe(true)
    })

    test("End prevents default behavior", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      triggers[0].focus()

      let defaultPrevented = false
      const event = new KeyboardEvent('keydown', {
        key: 'End',
        bubbles: true,
        cancelable: true
      })

      // Override preventDefault to track if it was called
      event.preventDefault = () => { defaultPrevented = true }
      triggers[0].dispatchEvent(event)

      expect(defaultPrevented).toBe(true)
    })

    test("does nothing when no trigger is focused", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')

      // Create a separate element to focus that's not a trigger
      const outsideElement = document.createElement('button')
      document.body.appendChild(outsideElement)
      outsideElement.focus()

      const initialActiveElement = document.activeElement

      // Dispatch keydown on a trigger but it's not focused
      keydown(triggers[0], 'ArrowDown')

      // Active element should remain the outside element
      expect(document.activeElement).toBe(initialActiveElement)
      expect(document.activeElement).not.toBe(triggers[1])

      // Cleanup
      document.body.removeChild(outsideElement)
    })
  })

  describe("event dispatch", () => {
    test("dispatches expand event when item is expanded", async () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]

      const eventPromise = waitForEvent(element, 'shadcn--accordion:expand')

      click(trigger1)

      const event = await eventPromise
      expect(event.detail.value).toBe("item-1")
    })

    test("dispatches collapse event when item is collapsed", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("single", true)

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]

      // Expand first
      click(trigger1)

      const eventPromise = waitForEvent(element, 'shadcn--accordion:collapse')

      // Then collapse
      click(trigger1)

      const event = await eventPromise
      expect(event.detail.value).toBe("item-1")
    })

    test("dispatches collapse event when another item is expanded in single mode", async () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const trigger2 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[1]

      // Expand first item
      click(trigger1)

      const eventPromise = waitForEvent(element, 'shadcn--accordion:collapse')

      // Expand second item (should collapse first)
      click(trigger2)

      const event = await eventPromise
      expect(event.detail.value).toBe("item-1")
    })

    test("dispatches events with correct value detail", async () => {
      const trigger3 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[2]

      const eventPromise = waitForEvent(element, 'shadcn--accordion:expand')

      click(trigger3)

      const event = await eventPromise
      expect(event.detail.value).toBe("item-3")
    })

    test("expand event is dispatched before collapse event in single mode", async () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const trigger2 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[1]

      const events = []

      element.addEventListener('shadcn--accordion:expand', (e) => {
        events.push({ type: 'expand', value: e.detail.value })
      })

      element.addEventListener('shadcn--accordion:collapse', (e) => {
        events.push({ type: 'collapse', value: e.detail.value })
      })

      // Expand first item
      click(trigger1)
      await nextFrame()

      // Expand second item
      click(trigger2)
      await nextFrame()

      // Based on the implementation, collapse happens first, then expand
      // This is because collapseItem is called before expandItem in toggle()
      expect(events).toEqual([
        { type: 'expand', value: 'item-1' },
        { type: 'collapse', value: 'item-1' },
        { type: 'expand', value: 'item-2' }
      ])
    })
  })

  describe("animation", () => {
    test("sets height on content during expand animation", () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const content1 = element.querySelectorAll('[data-shadcn--accordion-target="content"]')[0]

      click(trigger1)

      // After requestAnimationFrame, height should be set
      expect(content1.style.height).toBeTruthy()
    })

    test("sets height to 0px initially during collapse", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("single", true)

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const content1 = element.querySelectorAll('[data-shadcn--accordion-target="content"]')[0]

      // Expand first
      click(trigger1)
      await nextFrame()

      // Collapse
      click(trigger1)
      await nextFrame()

      expect(content1.style.height).toBe('0px')
    })

    test("sets hidden attribute after collapse animation", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("single", true)

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const content1 = element.querySelectorAll('[data-shadcn--accordion-target="content"]')[0]

      // Expand first
      click(trigger1)
      await nextFrame()

      // Collapse
      click(trigger1)

      // Wait for animation (200ms)
      await wait(250)

      expect(content1.hidden).toBe(true)
    })

    test("removes fixed height after expand animation", async () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const content1 = element.querySelectorAll('[data-shadcn--accordion-target="content"]')[0]

      click(trigger1)

      // Wait for animation to complete (200ms)
      await wait(250)

      expect(content1.style.height).toBe('')
    })
  })

  describe("data-state attributes", () => {
    test("item has data-state='closed' initially", () => {
      const item1 = element.querySelector('[data-value="item-1"]')
      expect(item1.dataset.state).toBe("closed")
    })

    test("item has data-state='open' when expanded", () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const item1 = element.querySelector('[data-value="item-1"]')

      click(trigger1)

      expect(item1.dataset.state).toBe("open")
    })

    test("trigger has data-state='open' when item is expanded", () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]

      click(trigger1)

      expect(trigger1.dataset.state).toBe("open")
    })

    test("content has data-state='open' when item is expanded", () => {
      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const content1 = element.querySelectorAll('[data-shadcn--accordion-target="content"]')[0]

      click(trigger1)

      expect(content1.dataset.state).toBe("open")
    })

    test("all elements have data-state='closed' when collapsed in collapsible mode", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("single", true)

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const trigger1 = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')[0]
      const item1 = element.querySelector('[data-value="item-1"]')
      const content1 = element.querySelectorAll('[data-shadcn--accordion-target="content"]')[0]

      // Expand then collapse
      click(trigger1)
      click(trigger1)
      await nextFrame()

      expect(item1.dataset.state).toBe("closed")
      expect(trigger1.dataset.state).toBe("closed")
      expect(content1.dataset.state).toBe("closed")
    })
  })

  describe("integration scenarios", () => {
    test("can toggle between items in single mode", async () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      const items = element.querySelectorAll('[data-shadcn--accordion-target="item"]')

      // Expand item 1
      click(triggers[0])
      expect(items[0].dataset.state).toBe("open")
      expect(items[1].dataset.state).toBe("closed")
      expect(items[2].dataset.state).toBe("closed")

      // Expand item 2
      click(triggers[1])
      await nextFrame()

      expect(items[0].dataset.state).toBe("closed")
      expect(items[1].dataset.state).toBe("open")
      expect(items[2].dataset.state).toBe("closed")

      // Expand item 3
      click(triggers[2])
      await nextFrame()

      expect(items[0].dataset.state).toBe("closed")
      expect(items[1].dataset.state).toBe("closed")
      expect(items[2].dataset.state).toBe("open")
    })

    test("can expand and collapse all items in multiple mode", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("multiple")

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      const items = element.querySelectorAll('[data-shadcn--accordion-target="item"]')

      // Expand all
      triggers.forEach(trigger => click(trigger))
      items.forEach(item => expect(item.dataset.state).toBe("open"))

      // Collapse all
      triggers.forEach(trigger => click(trigger))
      await nextFrame()

      items.forEach(item => expect(item.dataset.state).toBe("closed"))
    })

    test("keyboard navigation works with expanded items", () => {
      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')

      // Expand first item
      click(triggers[0])

      // Focus first trigger and navigate
      triggers[0].focus()
      keydown(triggers[0], 'ArrowDown')

      expect(document.activeElement).toBe(triggers[1])
    })

    test("can expand default items and navigate with keyboard", async () => {
      application.stop()
      document.body.innerHTML = createAccordionHTML("multiple", false, "item-1, item-3")

      application = Application.start()
      application.register("shadcn--accordion", AccordionController)
      await nextFrame()

      element = document.querySelector('[data-controller="shadcn--accordion"]')
      controller = application.getControllerForElementAndIdentifier(element, "shadcn--accordion")

      const triggers = element.querySelectorAll('[data-shadcn--accordion-target="trigger"]')
      const item1 = element.querySelector('[data-value="item-1"]')
      const item3 = element.querySelector('[data-value="item-3"]')

      // Verify defaults are expanded
      expect(item1.dataset.state).toBe("open")
      expect(item3.dataset.state).toBe("open")

      // Navigate with keyboard
      triggers[0].focus()
      keydown(triggers[0], 'End')
      expect(document.activeElement).toBe(triggers[2])
    })
  })
})
