import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use"
import { positionFloating } from "../utils/floating"

/**
 * Popover controller for rich content overlays
 * Uses Floating UI for smart positioning and stimulus-use for click outside detection
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
    this.cleanupFloating = null

    // Use stimulus-use for click outside detection
    useClickOutside(this)

    if (this.openValue) {
      this.show()
    }
  }

  disconnect() {
    this.hide()
    this.cleanupPositioning()
  }

  cleanupPositioning() {
    if (this.cleanupFloating) {
      this.cleanupFloating()
      this.cleanupFloating = null
    }
  }

  get placement() {
    // Convert side/align to Floating UI placement
    const align = this.alignValue === "center" ? "" : `-${this.alignValue}`
    return `${this.sideValue}${align}`
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

      // Use Floating UI for smart positioning
      if (this.hasTriggerTarget) {
        this.cleanupFloating = positionFloating(this.triggerTarget, this.contentTarget, {
          placement: this.placement,
          offset: 8
        })
      }
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

    // Cleanup Floating UI auto-update
    this.cleanupPositioning()

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
}
