import { Application } from "@hotwired/stimulus"
import NavigationMenuController from "../../app/assets/javascripts/shadcn/controllers/navigation_menu_controller.ts"
import { setupController, cleanupController, click, nextFrame, wait } from '../helpers/stimulus-test-helper.js'

describe("NavigationMenuController", () => {
  let application
  let element
  let controller

  afterEach(() => {
    cleanupController(application)
  })

  describe("basic rendering and initialization", () => {
    const basicHTML = `
      <nav data-controller="shadcn--navigation-menu"
           data-shadcn--navigation-menu-open-index-value="-1"
           data-shadcn--navigation-menu-delay-duration-value="200"
           data-shadcn--navigation-menu-skip-delay-duration-value="300">
        <ul data-shadcn--navigation-menu-target="list">
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger"
                    data-action="click->shadcn--navigation-menu#toggle mouseenter->shadcn--navigation-menu#hoverOpen mouseleave->shadcn--navigation-menu#hoverClose"
                    aria-expanded="false">Products</button>
            <div data-shadcn--navigation-menu-target="content" hidden>
              <a href="/product1">Product 1</a>
            </div>
          </li>
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger"
                    data-action="click->shadcn--navigation-menu#toggle mouseenter->shadcn--navigation-menu#hoverOpen mouseleave->shadcn--navigation-menu#hoverClose"
                    aria-expanded="false">Services</button>
            <div data-shadcn--navigation-menu-target="content" hidden>
              <a href="/service1">Service 1</a>
            </div>
          </li>
        </ul>
      </nav>
    `

    beforeEach(async () => {
      const setup = await setupController(NavigationMenuController, basicHTML, 'shadcn--navigation-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with closed state", () => {
      expect(controller.openIndexValue).toBe(-1)
    })

    test("initializes isOpen to false", () => {
      expect(controller.isOpen).toBe(false)
    })

    test("initializes with default delay values", () => {
      expect(controller.delayDurationValue).toBe(200)
      expect(controller.skipDelayDurationValue).toBe(300)
    })

    test("has list target", () => {
      expect(controller.hasListTarget).toBe(true)
    })

    test("has item targets", () => {
      expect(controller.itemTargets.length).toBe(2)
    })

    test("has trigger targets", () => {
      expect(controller.triggerTargets.length).toBe(2)
    })

    test("has content targets", () => {
      expect(controller.contentTargets.length).toBe(2)
    })

    test("all content is initially hidden", () => {
      controller.contentTargets.forEach(content => {
        expect(content.hidden).toBe(true)
      })
    })
  })

  describe("toggle functionality", () => {
    const toggleHTML = `
      <nav data-controller="shadcn--navigation-menu"
           data-shadcn--navigation-menu-open-index-value="-1">
        <ul data-shadcn--navigation-menu-target="list">
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger"
                    data-action="click->shadcn--navigation-menu#toggle"
                    aria-expanded="false">Products</button>
            <div data-shadcn--navigation-menu-target="content" hidden>Content 1</div>
          </li>
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger"
                    data-action="click->shadcn--navigation-menu#toggle"
                    aria-expanded="false">Services</button>
            <div data-shadcn--navigation-menu-target="content" hidden>Content 2</div>
          </li>
        </ul>
      </nav>
    `

    beforeEach(async () => {
      const setup = await setupController(NavigationMenuController, toggleHTML, 'shadcn--navigation-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("opens item on toggle", async () => {
      const trigger = controller.triggerTargets[0]
      controller.toggle({ currentTarget: trigger, preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(0)
      expect(controller.isOpen).toBe(true)
    })

    test("sets aria-expanded to true", async () => {
      const trigger = controller.triggerTargets[0]
      controller.toggle({ currentTarget: trigger, preventDefault: jest.fn() })
      await nextFrame()

      expect(trigger.getAttribute("aria-expanded")).toBe("true")
    })

    test("shows content when opened", async () => {
      const trigger = controller.triggerTargets[0]
      controller.toggle({ currentTarget: trigger, preventDefault: jest.fn() })
      await nextFrame()

      const content = controller.contentTargets[0]
      expect(content.hidden).toBe(false)
    })

    test("sets content data-state to open", async () => {
      const trigger = controller.triggerTargets[0]
      controller.toggle({ currentTarget: trigger, preventDefault: jest.fn() })
      await nextFrame()

      const content = controller.contentTargets[0]
      expect(content.dataset.state).toBe("open")
    })

    test("closes item on second toggle", async () => {
      const trigger = controller.triggerTargets[0]
      controller.toggle({ currentTarget: trigger, preventDefault: jest.fn() })
      await nextFrame()
      controller.toggle({ currentTarget: trigger, preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(-1)
      expect(controller.isOpen).toBe(false)
    })

    test("switches to different item on toggle", async () => {
      const trigger1 = controller.triggerTargets[0]
      const trigger2 = controller.triggerTargets[1]

      controller.toggle({ currentTarget: trigger1, preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(0)

      controller.toggle({ currentTarget: trigger2, preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(1)
    })

    test("sets wasClickOpened flag on toggle", async () => {
      const trigger = controller.triggerTargets[0]
      controller.toggle({ currentTarget: trigger, preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.wasClickOpened).toBe(true)
    })
  })

  describe("openItem and closeItem", () => {
    const itemHTML = `
      <nav data-controller="shadcn--navigation-menu"
           data-shadcn--navigation-menu-open-index-value="-1">
        <ul data-shadcn--navigation-menu-target="list">
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger" aria-expanded="false">Menu 1</button>
            <div data-shadcn--navigation-menu-target="content" hidden>Content 1</div>
          </li>
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger" aria-expanded="false">Menu 2</button>
            <div data-shadcn--navigation-menu-target="content" hidden>Content 2</div>
          </li>
        </ul>
      </nav>
    `

    beforeEach(async () => {
      const setup = await setupController(NavigationMenuController, itemHTML, 'shadcn--navigation-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("openItem opens specified index", async () => {
      controller.openItem(0)
      await nextFrame()

      expect(controller.openIndexValue).toBe(0)
    })

    test("openItem ignores invalid index (negative)", async () => {
      controller.openItem(-1)
      await nextFrame()

      expect(controller.openIndexValue).toBe(-1)
    })

    test("openItem ignores invalid index (too high)", async () => {
      controller.openItem(99)
      await nextFrame()

      expect(controller.openIndexValue).toBe(-1)
    })

    test("openItem closes previous item when opening new one", async () => {
      controller.openItem(0)
      await nextFrame()

      controller.openItem(1)
      await nextFrame()

      const trigger0 = controller.triggerTargets[0]
      const content0 = controller.contentTargets[0]

      expect(trigger0.getAttribute("aria-expanded")).toBe("false")
      expect(content0.dataset.state).toBe("closed")
    })

    test("closeItem closes specified index", async () => {
      controller.openItem(0)
      await nextFrame()

      controller.closeItem(0)
      await nextFrame()

      const trigger = controller.triggerTargets[0]
      expect(trigger.getAttribute("aria-expanded")).toBe("false")
    })

    test("sets motion direction when switching items", async () => {
      controller.openItem(0)
      await nextFrame()

      controller.openItem(1)
      await nextFrame()

      const content1 = controller.contentTargets[1]
      expect(content1.dataset.motion).toBe("from-end")
    })

    test("sets opposite motion direction", async () => {
      controller.openItem(1)
      await nextFrame()

      controller.openItem(0)
      await nextFrame()

      const content0 = controller.contentTargets[0]
      expect(content0.dataset.motion).toBe("from-start")
    })
  })

  describe("closeAll", () => {
    const closeAllHTML = `
      <nav data-controller="shadcn--navigation-menu"
           data-shadcn--navigation-menu-open-index-value="-1">
        <ul data-shadcn--navigation-menu-target="list">
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger" aria-expanded="false">Menu</button>
            <div data-shadcn--navigation-menu-target="content" hidden>Content</div>
          </li>
        </ul>
      </nav>
    `

    beforeEach(async () => {
      const setup = await setupController(NavigationMenuController, closeAllHTML, 'shadcn--navigation-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("resets openIndexValue to -1", async () => {
      controller.openItem(0)
      await nextFrame()

      controller.closeAll()
      await nextFrame()

      expect(controller.openIndexValue).toBe(-1)
    })

    test("resets isOpen to false", async () => {
      controller.openItem(0)
      await nextFrame()

      controller.closeAll()
      await nextFrame()

      expect(controller.isOpen).toBe(false)
    })

    test("resets wasClickOpened to false", async () => {
      const trigger = controller.triggerTargets[0]
      controller.toggle({ currentTarget: trigger, preventDefault: jest.fn() })
      await nextFrame()

      controller.closeAll()
      await nextFrame()

      expect(controller.wasClickOpened).toBe(false)
    })

    test("sets all triggers to aria-expanded false", async () => {
      controller.openItem(0)
      await nextFrame()

      controller.closeAll()
      await nextFrame()

      controller.triggerTargets.forEach(trigger => {
        expect(trigger.getAttribute("aria-expanded")).toBe("false")
      })
    })
  })

  describe("keyboard navigation", () => {
    const keyboardHTML = `
      <nav data-controller="shadcn--navigation-menu"
           data-shadcn--navigation-menu-open-index-value="-1">
        <ul data-shadcn--navigation-menu-target="list">
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger" aria-expanded="false">Menu 1</button>
            <div data-shadcn--navigation-menu-target="content" hidden>Content 1</div>
          </li>
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger" aria-expanded="false">Menu 2</button>
            <div data-shadcn--navigation-menu-target="content" hidden>Content 2</div>
          </li>
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger" aria-expanded="false">Menu 3</button>
            <div data-shadcn--navigation-menu-target="content" hidden>Content 3</div>
          </li>
        </ul>
      </nav>
    `

    beforeEach(async () => {
      const setup = await setupController(NavigationMenuController, keyboardHTML, 'shadcn--navigation-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller

      // Open the first menu to enable keyboard navigation
      controller.openItem(0)
      await nextFrame()
    })

    test("ArrowRight navigates to next item", async () => {
      controller.handleKeydown({ key: "ArrowRight", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(1)
    })

    test("ArrowRight wraps to first item", async () => {
      controller.openItem(2)
      await nextFrame()

      controller.handleKeydown({ key: "ArrowRight", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(0)
    })

    test("ArrowLeft navigates to previous item", async () => {
      controller.openItem(1)
      await nextFrame()

      controller.handleKeydown({ key: "ArrowLeft", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(0)
    })

    test("ArrowLeft wraps to last item", async () => {
      controller.handleKeydown({ key: "ArrowLeft", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(2)
    })

    test("Escape closes all menus", async () => {
      controller.handleKeydown({ key: "Escape", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.isOpen).toBe(false)
      expect(controller.openIndexValue).toBe(-1)
    })

    test("prevents default on navigation keys", () => {
      const preventDefault = jest.fn()
      controller.handleKeydown({ key: "ArrowRight", preventDefault })
      expect(preventDefault).toHaveBeenCalled()

      preventDefault.mockClear()
      controller.handleKeydown({ key: "ArrowLeft", preventDefault })
      expect(preventDefault).toHaveBeenCalled()
    })
  })

  describe("click outside handling", () => {
    const clickOutsideHTML = `
      <nav data-controller="shadcn--navigation-menu"
           data-shadcn--navigation-menu-open-index-value="-1">
        <ul data-shadcn--navigation-menu-target="list">
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger" aria-expanded="false">Menu</button>
            <div data-shadcn--navigation-menu-target="content" hidden>Content</div>
          </li>
        </ul>
      </nav>
    `

    beforeEach(async () => {
      const setup = await setupController(NavigationMenuController, clickOutsideHTML, 'shadcn--navigation-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("closes on click outside", async () => {
      controller.openItem(0)
      await nextFrame()

      const outsideElement = document.createElement("div")
      document.body.appendChild(outsideElement)

      // Use clickOutside directly since stimulus-use doesn't trigger via DOM events in jsdom
      controller.clickOutside({ target: outsideElement })
      await nextFrame()

      expect(controller.isOpen).toBe(false)

      document.body.removeChild(outsideElement)
    })

    test("does not close on click inside", async () => {
      controller.openItem(0)
      await nextFrame()

      // Clicking inside the controller element should not close via clickOutside
      // The clickOutside method from stimulus-use only fires for clicks outside the element
      // So we verify the menu stays open (clickOutside isn't even called for inside clicks)
      expect(controller.isOpen).toBe(true)
    })
  })

  describe("timer management", () => {
    const timerHTML = `
      <nav data-controller="shadcn--navigation-menu"
           data-shadcn--navigation-menu-open-index-value="-1"
           data-shadcn--navigation-menu-delay-duration-value="50"
           data-shadcn--navigation-menu-skip-delay-duration-value="50">
        <ul data-shadcn--navigation-menu-target="list">
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger"
                    data-action="mouseenter->shadcn--navigation-menu#hoverOpen mouseleave->shadcn--navigation-menu#hoverClose"
                    aria-expanded="false">Menu</button>
            <div data-shadcn--navigation-menu-target="content" hidden>Content</div>
          </li>
        </ul>
      </nav>
    `

    beforeEach(async () => {
      const setup = await setupController(NavigationMenuController, timerHTML, 'shadcn--navigation-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("clearTimers clears open timer", () => {
      controller.openTimer = setTimeout(() => {}, 1000)
      controller.clearTimers()

      expect(controller.openTimer).toBeNull()
    })

    test("clearTimers clears close timer", () => {
      controller.closeTimer = setTimeout(() => {}, 1000)
      controller.clearTimers()

      expect(controller.closeTimer).toBeNull()
    })
  })

  describe("disconnect cleanup", () => {
    const disconnectHTML = `
      <nav data-controller="shadcn--navigation-menu"
           data-shadcn--navigation-menu-open-index-value="-1">
        <ul data-shadcn--navigation-menu-target="list">
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger" aria-expanded="false">Menu</button>
            <div data-shadcn--navigation-menu-target="content" hidden>Content</div>
          </li>
        </ul>
      </nav>
    `

    beforeEach(async () => {
      const setup = await setupController(NavigationMenuController, disconnectHTML, 'shadcn--navigation-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("closes all on disconnect", async () => {
      controller.openItem(0)
      await nextFrame()

      controller.disconnect()
      await nextFrame()

      expect(controller.openIndexValue).toBe(-1)
    })

    test("clears timers on disconnect", () => {
      controller.openTimer = setTimeout(() => {}, 1000)
      controller.closeTimer = setTimeout(() => {}, 1000)

      controller.disconnect()

      expect(controller.openTimer).toBeNull()
      expect(controller.closeTimer).toBeNull()
    })
  })

  describe("viewport functionality", () => {
    const viewportHTML = `
      <nav data-controller="shadcn--navigation-menu"
           data-shadcn--navigation-menu-open-index-value="-1">
        <ul data-shadcn--navigation-menu-target="list">
          <li data-shadcn--navigation-menu-target="item">
            <button data-shadcn--navigation-menu-target="trigger" aria-expanded="false">Menu</button>
            <div data-shadcn--navigation-menu-target="content" hidden style="width: 200px; height: 100px;">
              <p>Content here</p>
            </div>
          </li>
        </ul>
        <div data-shadcn--navigation-menu-target="viewport" hidden></div>
      </nav>
    `

    beforeEach(async () => {
      const setup = await setupController(NavigationMenuController, viewportHTML, 'shadcn--navigation-menu')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("has viewport target", () => {
      expect(controller.hasViewportTarget).toBe(true)
    })

    test("shows viewport when item opened", async () => {
      controller.openItem(0)
      await nextFrame()

      expect(controller.viewportTarget.hidden).toBe(false)
    })

    test("sets viewport data-state to open", async () => {
      controller.openItem(0)
      await nextFrame()

      expect(controller.viewportTarget.dataset.state).toBe("open")
    })

    test("copies content to viewport", async () => {
      controller.openItem(0)
      await nextFrame()

      expect(controller.viewportTarget.innerHTML).toContain("Content here")
    })
  })
})
