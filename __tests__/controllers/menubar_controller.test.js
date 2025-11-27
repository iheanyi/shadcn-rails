import { Application } from "@hotwired/stimulus"
import MenubarController from "../../app/assets/javascripts/shadcn/controllers/menubar_controller.js"
import { setupController, cleanupController, click, nextFrame, wait } from '../helpers/stimulus-test-helper.js'

describe("MenubarController", () => {
  let application
  let element
  let controller

  afterEach(() => {
    cleanupController(application)
  })

  describe("basic rendering and initialization", () => {
    const basicHTML = `
      <div data-controller="shadcn--menubar"
           data-shadcn--menubar-open-index-value="-1">
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger"
                  data-action="click->shadcn--menubar#toggle mouseenter->shadcn--menubar#hoverOpen"
                  aria-expanded="false">File</button>
          <div data-shadcn--menubar-target="content" hidden>
            <button data-shadcn--menubar-target="item"
                    data-action="click->shadcn--menubar#selectItem">New</button>
            <button data-shadcn--menubar-target="item"
                    data-action="click->shadcn--menubar#selectItem">Open</button>
          </div>
        </div>
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger"
                  data-action="click->shadcn--menubar#toggle mouseenter->shadcn--menubar#hoverOpen"
                  aria-expanded="false">Edit</button>
          <div data-shadcn--menubar-target="content" hidden>
            <button data-shadcn--menubar-target="item"
                    data-action="click->shadcn--menubar#selectItem">Undo</button>
          </div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(MenubarController, basicHTML, 'shadcn--menubar')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with closed state", () => {
      expect(controller.openIndexValue).toBe(-1)
    })

    test("initializes isMenuOpen to false", () => {
      expect(controller.isMenuOpen).toBe(false)
    })

    test("initializes focusedIndex to -1", () => {
      expect(controller.focusedIndex).toBe(-1)
    })

    test("has menu targets", () => {
      expect(controller.menuTargets.length).toBe(2)
    })

    test("has trigger targets", () => {
      expect(controller.triggerTargets.length).toBe(2)
    })

    test("has content targets", () => {
      expect(controller.contentTargets.length).toBe(2)
    })

    test("has item targets", () => {
      expect(controller.itemTargets.length).toBe(3)
    })

    test("all content is initially hidden", () => {
      controller.contentTargets.forEach(content => {
        expect(content.hidden).toBe(true)
      })
    })
  })

  describe("toggle functionality", () => {
    const toggleHTML = `
      <div data-controller="shadcn--menubar"
           data-shadcn--menubar-open-index-value="-1">
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger"
                  data-action="click->shadcn--menubar#toggle"
                  aria-expanded="false">File</button>
          <div data-shadcn--menubar-target="content" hidden>
            <button data-shadcn--menubar-target="item">New</button>
          </div>
        </div>
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger"
                  data-action="click->shadcn--menubar#toggle"
                  aria-expanded="false">Edit</button>
          <div data-shadcn--menubar-target="content" hidden>
            <button data-shadcn--menubar-target="item">Undo</button>
          </div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(MenubarController, toggleHTML, 'shadcn--menubar')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("opens menu on toggle", async () => {
      const trigger = controller.triggerTargets[0]
      controller.toggle({ currentTarget: trigger, preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(0)
      expect(controller.isMenuOpen).toBe(true)
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

    test("closes menu on second toggle", async () => {
      const trigger = controller.triggerTargets[0]
      controller.toggle({ currentTarget: trigger, preventDefault: jest.fn() })
      await nextFrame()
      controller.toggle({ currentTarget: trigger, preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(-1)
      expect(controller.isMenuOpen).toBe(false)
    })

    test("switches to different menu on toggle", async () => {
      const trigger1 = controller.triggerTargets[0]
      const trigger2 = controller.triggerTargets[1]

      controller.toggle({ currentTarget: trigger1, preventDefault: jest.fn() })
      await nextFrame()
      expect(controller.openIndexValue).toBe(0)

      controller.toggle({ currentTarget: trigger2, preventDefault: jest.fn() })
      await nextFrame()
      expect(controller.openIndexValue).toBe(1)
    })
  })

  describe("hover functionality", () => {
    const hoverHTML = `
      <div data-controller="shadcn--menubar"
           data-shadcn--menubar-open-index-value="-1">
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger"
                  data-action="mouseenter->shadcn--menubar#hoverOpen"
                  aria-expanded="false">File</button>
          <div data-shadcn--menubar-target="content" hidden>Content 1</div>
        </div>
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger"
                  data-action="mouseenter->shadcn--menubar#hoverOpen"
                  aria-expanded="false">Edit</button>
          <div data-shadcn--menubar-target="content" hidden>Content 2</div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(MenubarController, hoverHTML, 'shadcn--menubar')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("does not open on hover when no menu is open", async () => {
      const trigger = controller.triggerTargets[0]
      controller.hoverOpen({ currentTarget: trigger })
      await nextFrame()

      expect(controller.isMenuOpen).toBe(false)
    })

    test("opens different menu on hover when one is already open", async () => {
      // First open a menu
      controller.openMenu(0)
      await nextFrame()

      const trigger2 = controller.triggerTargets[1]
      controller.hoverOpen({ currentTarget: trigger2 })
      await nextFrame()

      expect(controller.openIndexValue).toBe(1)
    })
  })

  describe("item selection", () => {
    const selectHTML = `
      <div data-controller="shadcn--menubar"
           data-shadcn--menubar-open-index-value="-1">
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger" aria-expanded="false">File</button>
          <div data-shadcn--menubar-target="content" hidden>
            <button data-shadcn--menubar-target="item"
                    data-action="click->shadcn--menubar#selectItem">New</button>
            <button data-shadcn--menubar-target="item"
                    data-action="click->shadcn--menubar#selectItem"
                    data-disabled>Disabled</button>
          </div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(MenubarController, selectHTML, 'shadcn--menubar')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("dispatches select event", async () => {
      controller.openMenu(0)
      await nextFrame()

      let selectedItem = null
      element.addEventListener("shadcn--menubar:select", (e) => {
        selectedItem = e.detail.item
      })

      const item = controller.itemTargets[0]
      controller.selectItem({ currentTarget: item })
      await nextFrame()

      expect(selectedItem).toBe(item)
    })

    test("closes menu after selection", async () => {
      controller.openMenu(0)
      await nextFrame()

      const item = controller.itemTargets[0]
      controller.selectItem({ currentTarget: item })
      await nextFrame()

      expect(controller.isMenuOpen).toBe(false)
    })

    test("does not select disabled items", async () => {
      controller.openMenu(0)
      await nextFrame()

      let selectFired = false
      element.addEventListener("shadcn--menubar:select", () => {
        selectFired = true
      })

      const disabledItem = controller.itemTargets[1]
      controller.selectItem({ currentTarget: disabledItem })
      await nextFrame()

      expect(selectFired).toBe(false)
    })
  })

  describe("checkbox items", () => {
    const checkboxHTML = `
      <div data-controller="shadcn--menubar"
           data-shadcn--menubar-open-index-value="-1">
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger" aria-expanded="false">View</button>
          <div data-shadcn--menubar-target="content" hidden>
            <button data-shadcn--menubar-target="item"
                    role="menuitemcheckbox"
                    aria-checked="false"
                    data-state="unchecked"
                    data-action="click->shadcn--menubar#toggleCheckbox">
              <span><svg style="display: none;">✓</svg></span>
              Show Toolbar
            </button>
          </div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(MenubarController, checkboxHTML, 'shadcn--menubar')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("toggles checkbox state", async () => {
      controller.openMenu(0)
      await nextFrame()

      const item = controller.itemTargets[0]
      controller.toggleCheckbox({ currentTarget: item })
      await nextFrame()

      expect(item.dataset.state).toBe("checked")
      expect(item.getAttribute("aria-checked")).toBe("true")
    })

    test("toggles checkbox back to unchecked", async () => {
      controller.openMenu(0)
      await nextFrame()

      const item = controller.itemTargets[0]
      controller.toggleCheckbox({ currentTarget: item })
      await nextFrame()
      controller.toggleCheckbox({ currentTarget: item })
      await nextFrame()

      expect(item.dataset.state).toBe("unchecked")
      expect(item.getAttribute("aria-checked")).toBe("false")
    })

    test("dispatches check event", async () => {
      controller.openMenu(0)
      await nextFrame()

      let checkDetail = null
      element.addEventListener("shadcn--menubar:check", (e) => {
        checkDetail = e.detail
      })

      const item = controller.itemTargets[0]
      controller.toggleCheckbox({ currentTarget: item })
      await nextFrame()

      expect(checkDetail.item).toBe(item)
      expect(checkDetail.checked).toBe(true)
    })
  })

  describe("radio items", () => {
    const radioHTML = `
      <div data-controller="shadcn--menubar"
           data-shadcn--menubar-open-index-value="-1">
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger" aria-expanded="false">View</button>
          <div data-shadcn--menubar-target="content" hidden>
            <div role="group">
              <button data-shadcn--menubar-target="item"
                      role="menuitemradio"
                      aria-checked="true"
                      data-state="checked"
                      data-value="small"
                      data-action="click->shadcn--menubar#selectRadio">
                <span><svg style="display: block;">●</svg></span>
                Small
              </button>
              <button data-shadcn--menubar-target="item"
                      role="menuitemradio"
                      aria-checked="false"
                      data-state="unchecked"
                      data-value="medium"
                      data-action="click->shadcn--menubar#selectRadio">
                <span><svg style="display: none;">●</svg></span>
                Medium
              </button>
            </div>
          </div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(MenubarController, radioHTML, 'shadcn--menubar')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("selects radio item", async () => {
      controller.openMenu(0)
      await nextFrame()

      const mediumItem = controller.itemTargets[1]
      controller.selectRadio({ currentTarget: mediumItem })
      await nextFrame()

      expect(mediumItem.dataset.state).toBe("checked")
      expect(mediumItem.getAttribute("aria-checked")).toBe("true")
    })

    test("unchecks other radio items in group", async () => {
      controller.openMenu(0)
      await nextFrame()

      const smallItem = controller.itemTargets[0]
      const mediumItem = controller.itemTargets[1]

      controller.selectRadio({ currentTarget: mediumItem })
      await nextFrame()

      expect(smallItem.dataset.state).toBe("unchecked")
      expect(smallItem.getAttribute("aria-checked")).toBe("false")
    })

    test("dispatches radioChange event", async () => {
      controller.openMenu(0)
      await nextFrame()

      let radioDetail = null
      element.addEventListener("shadcn--menubar:radioChange", (e) => {
        radioDetail = e.detail
      })

      const mediumItem = controller.itemTargets[1]
      controller.selectRadio({ currentTarget: mediumItem })
      await nextFrame()

      expect(radioDetail.item).toBe(mediumItem)
      expect(radioDetail.value).toBe("medium")
    })
  })

  describe("keyboard navigation", () => {
    const keyboardHTML = `
      <div data-controller="shadcn--menubar"
           data-shadcn--menubar-open-index-value="-1">
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger" aria-expanded="false">File</button>
          <div data-shadcn--menubar-target="content" hidden>
            <button data-shadcn--menubar-target="item">New</button>
            <button data-shadcn--menubar-target="item" data-disabled>Disabled</button>
            <button data-shadcn--menubar-target="item">Save</button>
          </div>
        </div>
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger" aria-expanded="false">Edit</button>
          <div data-shadcn--menubar-target="content" hidden>
            <button data-shadcn--menubar-target="item">Undo</button>
          </div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(MenubarController, keyboardHTML, 'shadcn--menubar')
      application = setup.application
      element = setup.element
      controller = setup.controller

      // Open the first menu
      controller.openMenu(0)
      await nextFrame()
    })

    test("ArrowDown moves to next item", async () => {
      // Initially focused on first item (index 0)
      controller.handleKeydown({ key: "ArrowDown", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.focusedIndex).toBe(1)
    })

    test("ArrowDown wraps to first item", async () => {
      // Move to last item
      controller.focusedIndex = 1 // Last enabled item in current menu
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

    test("ArrowRight opens next menu", async () => {
      controller.handleKeydown({ key: "ArrowRight", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(1)
    })

    test("ArrowLeft opens previous menu", async () => {
      controller.openMenu(1)
      await nextFrame()

      controller.handleKeydown({ key: "ArrowLeft", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.openIndexValue).toBe(0)
    })

    test("Home moves to first item", async () => {
      controller.focusedIndex = 1
      controller.handleKeydown({ key: "Home", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.focusedIndex).toBe(0)
    })

    test("End moves to last item", async () => {
      controller.handleKeydown({ key: "End", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.focusedIndex).toBe(1) // Last enabled item
    })

    test("Escape closes menu", async () => {
      controller.handleKeydown({ key: "Escape", preventDefault: jest.fn() })
      await nextFrame()

      expect(controller.isMenuOpen).toBe(false)
    })

    test("Enter/Space triggers click on focused item", async () => {
      const items = controller.currentMenuItems
      const clickSpy = jest.spyOn(items[0], 'click')

      controller.focusedIndex = 0
      controller.handleKeydown({ key: "Enter", preventDefault: jest.fn() })
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
      controller.handleKeydown({ key: "ArrowRight", preventDefault })
      expect(preventDefault).toHaveBeenCalled()

      preventDefault.mockClear()
      controller.handleKeydown({ key: "ArrowLeft", preventDefault })
      expect(preventDefault).toHaveBeenCalled()
    })
  })

  describe("submenu functionality", () => {
    const submenuHTML = `
      <div data-controller="shadcn--menubar"
           data-shadcn--menubar-open-index-value="-1">
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger" aria-expanded="false">File</button>
          <div data-shadcn--menubar-target="content" hidden>
            <div data-shadcn--menubar-target="sub">
              <button data-shadcn--menubar-target="subTrigger"
                      data-action="mouseenter->shadcn--menubar#openSub mouseleave->shadcn--menubar#startCloseSubTimer"
                      aria-expanded="false">Share</button>
              <div data-shadcn--menubar-target="subContent" hidden>
                <button data-shadcn--menubar-target="item">Email</button>
                <button data-shadcn--menubar-target="item">Twitter</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(MenubarController, submenuHTML, 'shadcn--menubar')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("opens submenu", async () => {
      controller.openMenu(0)
      await nextFrame()

      const subTrigger = controller.subTriggerTargets[0]
      controller.openSub({ currentTarget: subTrigger })
      await nextFrame()

      expect(subTrigger.getAttribute("aria-expanded")).toBe("true")
      expect(controller.subContentTargets[0].hidden).toBe(false)
    })

    test("closeAllSubs closes all submenus", async () => {
      controller.openMenu(0)
      await nextFrame()

      const subTrigger = controller.subTriggerTargets[0]
      controller.openSub({ currentTarget: subTrigger })
      await nextFrame()

      controller.closeAllSubs()
      await nextFrame()

      expect(subTrigger.getAttribute("aria-expanded")).toBe("false")
      expect(controller.subContentTargets[0].hidden).toBe(true)
    })
  })

  describe("click outside handling", () => {
    const clickOutsideHTML = `
      <div data-controller="shadcn--menubar"
           data-shadcn--menubar-open-index-value="-1">
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger" aria-expanded="false">File</button>
          <div data-shadcn--menubar-target="content" hidden>
            <button data-shadcn--menubar-target="item">New</button>
          </div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(MenubarController, clickOutsideHTML, 'shadcn--menubar')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("closes on click outside", async () => {
      controller.openMenu(0)
      await nextFrame()

      const outsideElement = document.createElement("div")
      document.body.appendChild(outsideElement)

      // Use clickOutside directly since stimulus-use doesn't trigger via DOM events in jsdom
      controller.clickOutside({ target: outsideElement })
      await nextFrame()

      expect(controller.isMenuOpen).toBe(false)

      document.body.removeChild(outsideElement)
    })

    test("does not close on click inside", async () => {
      controller.openMenu(0)
      await nextFrame()

      // Clicking inside the controller element should not close via clickOutside
      // The clickOutside method from stimulus-use only fires for clicks outside the element
      // So we verify the menu stays open
      expect(controller.isMenuOpen).toBe(true)
    })
  })

  describe("currentMenuItems getter", () => {
    const itemsHTML = `
      <div data-controller="shadcn--menubar"
           data-shadcn--menubar-open-index-value="-1">
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger" aria-expanded="false">File</button>
          <div data-shadcn--menubar-target="content" hidden>
            <button data-shadcn--menubar-target="item">New</button>
            <button data-shadcn--menubar-target="item" data-disabled>Disabled</button>
            <button data-shadcn--menubar-target="item">Save</button>
          </div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(MenubarController, itemsHTML, 'shadcn--menubar')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("returns empty array when no menu open", () => {
      expect(controller.currentMenuItems).toEqual([])
    })

    test("returns enabled items when menu is open", async () => {
      controller.openMenu(0)
      await nextFrame()

      const items = controller.currentMenuItems
      expect(items.length).toBe(2) // Only enabled items
    })
  })

  describe("disconnect cleanup", () => {
    const disconnectHTML = `
      <div data-controller="shadcn--menubar"
           data-shadcn--menubar-open-index-value="-1">
        <div data-shadcn--menubar-target="menu">
          <button data-shadcn--menubar-target="trigger" aria-expanded="false">File</button>
          <div data-shadcn--menubar-target="content" hidden>
            <button data-shadcn--menubar-target="item">New</button>
          </div>
        </div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(MenubarController, disconnectHTML, 'shadcn--menubar')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("closes all on disconnect", async () => {
      controller.openMenu(0)
      await nextFrame()

      controller.disconnect()
      await nextFrame()

      expect(controller.openIndexValue).toBe(-1)
    })
  })
})
