import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use"

/**
 * Popover controller for rich content overlays
 * Uses stimulus-use for click outside detection
 */
export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = {
    open: { type: Boolean, default: false },
    side: { type: String, default: "bottom" },
    align: { type: String, default: "center" },
    modal: { type: Boolean, default: false }
  }

  connect() {
    // Use stimulus-use for click outside detection
    useClickOutside(this)

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

    if (this.modalValue) {
      document.body.style.pointerEvents = "none"
      this.contentTarget.style.pointerEvents = "auto"
    }

    this.dispatch("opened")
  }

  hide() {
    if (!this.openValue) return

    this.openValue = false

    if (this.hasContentTarget) {
      this.contentTarget.dataset.state = "closed"
      setTimeout(() => {
        if (!this.openValue) {
          this.contentTarget.hidden = true
        }
      }, 150)
    }

    if (this.modalValue) {
      document.body.style.pointerEvents = ""
    }

    this.dispatch("closed")
  }

  close() {
    this.hide()
  }

  // Called by stimulus-use when clicking outside the element
  clickOutside(event) {
    if (this.openValue) {
      this.hide()
    }
  }

  positionContent() {
    if (!this.hasContentTarget || !this.hasTriggerTarget) return

    const trigger = this.triggerTarget.getBoundingClientRect()
    const content = this.contentTarget

    content.style.position = "absolute"

    const gap = 8

    switch (this.sideValue) {
      case "top":
        content.style.bottom = "100%"
        content.style.top = "auto"
        content.style.marginBottom = `${gap}px`
        break
      case "bottom":
        content.style.top = "100%"
        content.style.bottom = "auto"
        content.style.marginTop = `${gap}px`
        break
      case "left":
        content.style.right = "100%"
        content.style.left = "auto"
        content.style.marginRight = `${gap}px`
        break
      case "right":
        content.style.left = "100%"
        content.style.right = "auto"
        content.style.marginLeft = `${gap}px`
        break
    }

    switch (this.alignValue) {
      case "start":
        content.style.left = "0"
        content.style.right = "auto"
        break
      case "center":
        if (this.sideValue === "top" || this.sideValue === "bottom") {
          content.style.left = "50%"
          content.style.transform = "translateX(-50%)"
        }
        break
      case "end":
        content.style.right = "0"
        content.style.left = "auto"
        break
    }
  }
}
