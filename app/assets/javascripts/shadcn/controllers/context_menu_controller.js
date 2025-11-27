import { Controller } from "@hotwired/stimulus"

/**
 * Context Menu controller for right-click menus
 * Handles opening at mouse position, closing, keyboard navigation, and item selection
 */
export default class extends Controller {
  static targets = ["trigger", "content", "item"]
  static values = {
    open: { type: Boolean, default: false }
  }

  connect() {
    this.focusedIndex = -1
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
    this.boundHandleKeydown = this.handleKeydown.bind(this)
    this.originalOverflow = null
  }

  disconnect() {
    this.hide()
  }

  show(event) {
    event?.preventDefault()

    // Store mouse position for positioning
    this.mouseX = event?.clientX || 0
    this.mouseY = event?.clientY || 0

    this.openValue = true

    // Lock scroll
    this.originalOverflow = document.body.style.overflow
    document.body.style.overflow = "hidden"

    if (this.hasContentTarget) {
      this.contentTarget.hidden = false
      this.contentTarget.dataset.state = "open"
      this.positionContent()
    }

    // Defer adding click listener to prevent immediate close from right-click
    // The contextmenu event can sometimes trigger a click in the same event cycle
    requestAnimationFrame(() => {
      if (this.openValue) {
        document.addEventListener("click", this.boundHandleClickOutside)
        document.addEventListener("contextmenu", this.boundHandleClickOutside)
      }
    })
    document.addEventListener("keydown", this.boundHandleKeydown)

    // Focus first item
    this.focusedIndex = -1
    this.focusNextItem()

    this.dispatch("opened")
  }

  hide() {
    if (!this.openValue) return

    this.openValue = false

    // Remove event listeners immediately to prevent double-triggering
    document.removeEventListener("click", this.boundHandleClickOutside)
    document.removeEventListener("contextmenu", this.boundHandleClickOutside)
    document.removeEventListener("keydown", this.boundHandleKeydown)

    if (this.hasContentTarget) {
      this.contentTarget.dataset.state = "closed"
      // Wait for animation to complete before hiding and restoring scroll
      // Animation duration is 100ms, add buffer for smooth transition
      setTimeout(() => {
        if (!this.openValue) {
          this.contentTarget.hidden = true
          // Restore scroll only after menu is fully hidden
          document.body.style.overflow = this.originalOverflow || ""
        }
      }, 100)
    } else {
      // No content target, restore scroll immediately
      document.body.style.overflow = this.originalOverflow || ""
    }

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
    // Don't close if clicking inside the content
    if (this.hasContentTarget && this.contentTarget.contains(event.target)) {
      return
    }
    this.hide()
  }

  handleKeydown(event) {
    switch (event.key) {
      case "Escape":
        this.hide()
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
    if (!this.hasContentTarget) return

    const content = this.contentTarget
    const viewportWidth = window.innerWidth
    const viewportHeight = window.innerHeight

    // Reset position to measure actual size
    content.style.left = "0"
    content.style.top = "0"

    const contentRect = content.getBoundingClientRect()

    // Calculate position, keeping menu within viewport
    let x = this.mouseX
    let y = this.mouseY

    // Adjust if menu would overflow right edge
    if (x + contentRect.width > viewportWidth) {
      x = viewportWidth - contentRect.width - 8
    }

    // Adjust if menu would overflow bottom edge
    if (y + contentRect.height > viewportHeight) {
      y = viewportHeight - contentRect.height - 8
    }

    // Ensure menu doesn't go off left or top edge
    x = Math.max(8, x)
    y = Math.max(8, y)

    content.style.left = `${x}px`
    content.style.top = `${y}px`
  }
}
