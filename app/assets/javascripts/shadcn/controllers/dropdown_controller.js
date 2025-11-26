import { Controller } from "@hotwired/stimulus"

/**
 * Dropdown controller for dropdown menus
 * Handles opening, closing, keyboard navigation, and item selection
 */
export default class extends Controller {
  static targets = ["trigger", "content", "item"]
  static values = {
    open: { type: Boolean, default: false },
    align: { type: String, default: "end" },
    side: { type: String, default: "bottom" }
  }

  connect() {
    this.focusedIndex = -1
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
    this.boundHandleKeydown = this.handleKeydown.bind(this)

    if (this.openValue) {
      this.show()
    }
  }

  disconnect() {
    this.hide()
  }

  toggle(event) {
    event?.preventDefault()
    if (this.openValue) {
      this.hide()
    } else {
      this.show()
    }
  }

  show() {
    if (this.openValue) return

    this.openValue = true

    if (this.hasContentTarget) {
      this.contentTarget.hidden = false
      this.contentTarget.dataset.state = "open"
      this.contentTarget.dataset.side = this.sideValue
      this.positionContent()
    }

    if (this.hasTriggerTarget) {
      this.triggerTarget.setAttribute("aria-expanded", "true")
    }

    // Add event listeners
    document.addEventListener("click", this.boundHandleClickOutside)
    document.addEventListener("keydown", this.boundHandleKeydown)

    // Focus first item
    this.focusedIndex = -1
    this.focusNextItem()

    this.dispatch("opened")
  }

  hide() {
    if (!this.openValue) return

    this.openValue = false

    if (this.hasContentTarget) {
      this.contentTarget.dataset.state = "closed"
      // Hide after animation
      setTimeout(() => {
        if (!this.openValue) {
          this.contentTarget.hidden = true
        }
      }, 150)
    }

    if (this.hasTriggerTarget) {
      this.triggerTarget.setAttribute("aria-expanded", "false")
    }

    // Remove event listeners
    document.removeEventListener("click", this.boundHandleClickOutside)
    document.removeEventListener("keydown", this.boundHandleKeydown)

    // Reset focus index
    this.focusedIndex = -1

    this.dispatch("closed")
  }

  close() {
    this.hide()
  }

  selectItem(event) {
    const item = event.currentTarget
    if (item.dataset.disabled !== undefined) return

    this.dispatch("select", { detail: { item } })
    this.hide()
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hide()
    }
  }

  handleKeydown(event) {
    switch (event.key) {
      case "Escape":
        this.hide()
        this.triggerTarget?.focus()
        break
      case "ArrowDown":
        event.preventDefault()
        this.focusNextItem()
        break
      case "ArrowUp":
        event.preventDefault()
        this.focusPreviousItem()
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

  focusNextItem() {
    const items = this.enabledItems
    if (items.length === 0) return

    this.focusedIndex = (this.focusedIndex + 1) % items.length
    items[this.focusedIndex].focus()
  }

  focusPreviousItem() {
    const items = this.enabledItems
    if (items.length === 0) return

    this.focusedIndex = this.focusedIndex <= 0 ? items.length - 1 : this.focusedIndex - 1
    items[this.focusedIndex].focus()
  }

  focusFirstItem() {
    const items = this.enabledItems
    if (items.length === 0) return

    this.focusedIndex = 0
    items[0].focus()
  }

  focusLastItem() {
    const items = this.enabledItems
    if (items.length === 0) return

    this.focusedIndex = items.length - 1
    items[this.focusedIndex].focus()
  }

  selectFocusedItem() {
    const items = this.enabledItems
    if (this.focusedIndex >= 0 && this.focusedIndex < items.length) {
      items[this.focusedIndex].click()
    }
  }

  get enabledItems() {
    return this.itemTargets.filter(item => item.dataset.disabled === undefined)
  }

  positionContent() {
    if (!this.hasContentTarget || !this.hasTriggerTarget) return

    const trigger = this.triggerTarget.getBoundingClientRect()
    const content = this.contentTarget

    // Position based on side and align
    content.style.position = "absolute"
    content.style.minWidth = `${trigger.width}px`

    switch (this.sideValue) {
      case "top":
        content.style.bottom = "100%"
        content.style.top = "auto"
        content.style.marginBottom = "4px"
        break
      case "bottom":
      default:
        content.style.top = "100%"
        content.style.bottom = "auto"
        content.style.marginTop = "4px"
        break
    }

    switch (this.alignValue) {
      case "start":
        content.style.left = "0"
        content.style.right = "auto"
        break
      case "center":
        content.style.left = "50%"
        content.style.transform = "translateX(-50%)"
        break
      case "end":
      default:
        content.style.right = "0"
        content.style.left = "auto"
        break
    }
  }
}
