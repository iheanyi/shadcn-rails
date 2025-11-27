import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use"

/**
 * Menubar controller
 * Handles menu opening/closing, keyboard navigation, hover behavior
 * Uses stimulus-use for click outside detection
 */
export default class extends Controller {
  static targets = ["menu", "trigger", "content", "item", "sub", "subTrigger", "subContent"]
  static values = {
    openIndex: { type: Number, default: -1 }
  }

  connect() {
    this.focusedIndex = -1
    this.isMenuOpen = false
    this.boundHandleKeydown = this.handleKeydown.bind(this)
    this.closeSubTimer = null

    // Use stimulus-use for click outside detection
    useClickOutside(this)
  }

  disconnect() {
    this.closeAll()
    document.removeEventListener("keydown", this.boundHandleKeydown)
  }

  toggle(event) {
    event?.preventDefault()
    const trigger = event.currentTarget
    const menu = trigger.closest("[data-shadcn--menubar-target='menu']")
    const menuIndex = this.menuTargets.indexOf(menu)

    if (this.openIndexValue === menuIndex) {
      this.closeAll()
    } else {
      this.openMenu(menuIndex)
    }
  }

  hoverOpen(event) {
    // Only open on hover if a menu is already open
    if (!this.isMenuOpen) return

    const trigger = event.currentTarget
    const menu = trigger.closest("[data-shadcn--menubar-target='menu']")
    const menuIndex = this.menuTargets.indexOf(menu)

    if (this.openIndexValue !== menuIndex) {
      this.openMenu(menuIndex)
    }
  }

  openMenu(index) {
    // Close any currently open menu
    this.closeAllMenus()

    if (index < 0 || index >= this.menuTargets.length) return

    const menu = this.menuTargets[index]
    const trigger = menu.querySelector("[data-shadcn--menubar-target='trigger']")
    const content = menu.querySelector("[data-shadcn--menubar-target='content']")

    if (trigger && content) {
      trigger.setAttribute("aria-expanded", "true")
      trigger.dataset.state = "open"
      content.hidden = false
      content.dataset.state = "open"
      this.positionContent(trigger, content)
    }

    this.openIndexValue = index
    this.isMenuOpen = true
    this.focusedIndex = -1

    // Add keydown event listener (click outside is handled by stimulus-use)
    document.addEventListener("keydown", this.boundHandleKeydown)

    // Focus first item
    this.focusNextItem()
  }

  closeAllMenus() {
    this.triggerTargets.forEach(trigger => {
      trigger.setAttribute("aria-expanded", "false")
      trigger.dataset.state = "closed"
    })

    this.contentTargets.forEach(content => {
      content.dataset.state = "closed"
      content.hidden = true
    })

    this.closeAllSubs()
  }

  closeAll() {
    this.closeAllMenus()
    this.openIndexValue = -1
    this.isMenuOpen = false
    this.focusedIndex = -1

    // Remove keydown listener (click outside is handled by stimulus-use)
    document.removeEventListener("keydown", this.boundHandleKeydown)
  }

  selectItem(event) {
    const item = event.currentTarget
    if (item.dataset.disabled !== undefined) return

    this.dispatch("select", { detail: { item } })
    this.closeAll()
  }

  toggleCheckbox(event) {
    const item = event.currentTarget
    if (item.dataset.disabled !== undefined) return

    const isChecked = item.dataset.state === "checked"
    item.dataset.state = isChecked ? "unchecked" : "checked"
    item.setAttribute("aria-checked", (!isChecked).toString())

    // Toggle the check icon visibility
    const indicator = item.querySelector("span svg")
    if (indicator) {
      indicator.style.display = isChecked ? "none" : "block"
    }

    this.dispatch("check", { detail: { item, checked: !isChecked } })
  }

  selectRadio(event) {
    const item = event.currentTarget
    if (item.dataset.disabled !== undefined) return

    const group = item.closest("[role='group']")
    if (group) {
      // Uncheck all radio items in the group
      group.querySelectorAll("[role='menuitemradio']").forEach(radio => {
        radio.dataset.state = "unchecked"
        radio.setAttribute("aria-checked", "false")
        const indicator = radio.querySelector("span svg")
        if (indicator) indicator.style.display = "none"
      })
    }

    // Check this item
    item.dataset.state = "checked"
    item.setAttribute("aria-checked", "true")
    const indicator = item.querySelector("span svg")
    if (indicator) indicator.style.display = "block"

    this.dispatch("radioChange", { detail: { item, value: item.dataset.value } })
  }

  // Submenu handling
  openSub(event) {
    this.cancelCloseSubTimer()

    const subTrigger = event.currentTarget
    const sub = subTrigger.closest("[data-shadcn--menubar-target='sub']")
    const subContent = sub?.querySelector("[data-shadcn--menubar-target='subContent']")

    if (subTrigger && subContent) {
      // Close other submenus at the same level
      this.closeAllSubs()

      subTrigger.setAttribute("aria-expanded", "true")
      subTrigger.dataset.state = "open"
      subContent.hidden = false
      subContent.dataset.state = "open"
      this.positionSubContent(subTrigger, subContent)
    }
  }

  startCloseSubTimer() {
    this.closeSubTimer = setTimeout(() => {
      this.closeAllSubs()
    }, 100)
  }

  cancelCloseSubTimer() {
    if (this.closeSubTimer) {
      clearTimeout(this.closeSubTimer)
      this.closeSubTimer = null
    }
  }

  closeAllSubs() {
    this.subTriggerTargets.forEach(trigger => {
      trigger.setAttribute("aria-expanded", "false")
      trigger.dataset.state = "closed"
    })

    this.subContentTargets.forEach(content => {
      content.dataset.state = "closed"
      content.hidden = true
    })
  }

  // Called by stimulus-use when clicking outside the element
  clickOutside(event) {
    if (this.isMenuOpen) {
      this.closeAll()
    }
  }

  handleKeydown(event) {
    switch (event.key) {
      case "Escape":
        this.closeAll()
        if (this.openIndexValue >= 0) {
          this.triggerTargets[this.openIndexValue]?.focus()
        }
        break
      case "ArrowDown":
        event.preventDefault()
        this.focusNextItem()
        break
      case "ArrowUp":
        event.preventDefault()
        this.focusPreviousItem()
        break
      case "ArrowRight":
        event.preventDefault()
        this.openNextMenu()
        break
      case "ArrowLeft":
        event.preventDefault()
        this.openPreviousMenu()
        break
      case "Home":
        event.preventDefault()
        this.focusFirstItem()
        break
      case "End":
        event.preventDefault()
        this.focusLastItem()
        break
      case "Enter":
      case " ":
        event.preventDefault()
        this.selectFocusedItem()
        break
    }
  }

  openNextMenu() {
    const nextIndex = (this.openIndexValue + 1) % this.menuTargets.length
    this.openMenu(nextIndex)
  }

  openPreviousMenu() {
    const prevIndex = this.openIndexValue <= 0 ? this.menuTargets.length - 1 : this.openIndexValue - 1
    this.openMenu(prevIndex)
  }

  focusNextItem() {
    const items = this.currentMenuItems
    if (items.length === 0) return

    this.focusedIndex = (this.focusedIndex + 1) % items.length
    items[this.focusedIndex].focus()
  }

  focusPreviousItem() {
    const items = this.currentMenuItems
    if (items.length === 0) return

    this.focusedIndex = this.focusedIndex <= 0 ? items.length - 1 : this.focusedIndex - 1
    items[this.focusedIndex].focus()
  }

  focusFirstItem() {
    const items = this.currentMenuItems
    if (items.length === 0) return

    this.focusedIndex = 0
    items[0].focus()
  }

  focusLastItem() {
    const items = this.currentMenuItems
    if (items.length === 0) return

    this.focusedIndex = items.length - 1
    items[this.focusedIndex].focus()
  }

  selectFocusedItem() {
    const items = this.currentMenuItems
    if (this.focusedIndex >= 0 && this.focusedIndex < items.length) {
      items[this.focusedIndex].click()
    }
  }

  get currentMenuItems() {
    if (this.openIndexValue < 0) return []
    const menu = this.menuTargets[this.openIndexValue]
    if (!menu) return []

    const content = menu.querySelector("[data-shadcn--menubar-target='content']")
    if (!content) return []

    return Array.from(content.querySelectorAll("[data-shadcn--menubar-target='item']"))
      .filter(item => item.dataset.disabled === undefined)
  }

  positionContent(trigger, content) {
    const triggerRect = trigger.getBoundingClientRect()

    content.style.position = "absolute"
    content.style.top = "100%"
    content.style.left = "0"
    content.style.marginTop = "4px"
  }

  positionSubContent(trigger, content) {
    content.style.position = "absolute"
    content.style.top = "0"
    content.style.left = "100%"
    content.style.marginLeft = "2px"
  }
}
