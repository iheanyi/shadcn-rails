import { Controller } from "@hotwired/stimulus"
import { positionFloating } from "../utils/floating"

/**
 * Hover Card Controller
 * Handles showing/hiding content on hover with delays
 * Uses Floating UI for smart positioning
 */
export default class extends Controller<HTMLElement> {
  static targets = ["trigger", "content"]
  static values = {
    openDelay: { type: Number, default: 700 },
    closeDelay: { type: Number, default: 300 },
    side: { type: String, default: "bottom" },
    align: { type: String, default: "center" }
  }

  connect() {
    this.openTimeout = null
    this.closeTimeout = null
    this.isOpen = false
    this.cleanupFloating = null

    this.triggerTarget.addEventListener("mouseenter", this.scheduleOpen.bind(this))
    this.triggerTarget.addEventListener("mouseleave", this.scheduleClose.bind(this))
    this.triggerTarget.addEventListener("focus", this.scheduleOpen.bind(this))
    this.triggerTarget.addEventListener("blur", this.scheduleClose.bind(this))

    this.contentTarget.addEventListener("mouseenter", this.cancelClose.bind(this))
    this.contentTarget.addEventListener("mouseleave", this.scheduleClose.bind(this))
  }

  disconnect() {
    this.clearTimeouts()
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

  scheduleOpen() {
    this.clearTimeouts()
    this.openTimeout = setTimeout(() => {
      this.open()
    }, this.openDelayValue)
  }

  scheduleClose() {
    this.clearTimeouts()
    this.closeTimeout = setTimeout(() => {
      this.close()
    }, this.closeDelayValue)
  }

  cancelClose() {
    if (this.closeTimeout) {
      clearTimeout(this.closeTimeout)
      this.closeTimeout = null
    }
  }

  clearTimeouts() {
    if (this.openTimeout) {
      clearTimeout(this.openTimeout)
      this.openTimeout = null
    }
    if (this.closeTimeout) {
      clearTimeout(this.closeTimeout)
      this.closeTimeout = null
    }
  }

  open() {
    if (this.isOpen) return

    this.isOpen = true
    this.contentTarget.style.display = "block"
    this.contentTarget.setAttribute("data-state", "open")

    // Use Floating UI for smart positioning
    this.cleanupFloating = positionFloating(this.triggerTarget, this.contentTarget, {
      placement: this.placement,
      offset: 8
    })

    this.dispatch("open")
  }

  close() {
    if (!this.isOpen) return

    this.isOpen = false
    this.contentTarget.setAttribute("data-state", "closed")

    // Cleanup Floating UI
    this.cleanupPositioning()

    // Wait for animation to complete
    setTimeout(() => {
      if (!this.isOpen) {
        this.contentTarget.style.display = "none"
      }
    }, 150)

    this.dispatch("close")
  }
}
