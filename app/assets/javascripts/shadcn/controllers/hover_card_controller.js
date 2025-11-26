import { Controller } from "@hotwired/stimulus"

/**
 * Hover Card Controller
 * Handles showing/hiding content on hover with delays
 */
export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = {
    openDelay: { type: Number, default: 700 },
    closeDelay: { type: Number, default: 300 }
  }

  connect() {
    this.openTimeout = null
    this.closeTimeout = null
    this.isOpen = false

    this.triggerTarget.addEventListener("mouseenter", this.scheduleOpen.bind(this))
    this.triggerTarget.addEventListener("mouseleave", this.scheduleClose.bind(this))
    this.triggerTarget.addEventListener("focus", this.scheduleOpen.bind(this))
    this.triggerTarget.addEventListener("blur", this.scheduleClose.bind(this))

    this.contentTarget.addEventListener("mouseenter", this.cancelClose.bind(this))
    this.contentTarget.addEventListener("mouseleave", this.scheduleClose.bind(this))
  }

  disconnect() {
    this.clearTimeouts()
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
    this.positionContent()

    this.dispatch("open")
  }

  close() {
    if (!this.isOpen) return

    this.isOpen = false
    this.contentTarget.setAttribute("data-state", "closed")

    // Wait for animation to complete
    setTimeout(() => {
      if (!this.isOpen) {
        this.contentTarget.style.display = "none"
      }
    }, 150)

    this.dispatch("close")
  }

  positionContent() {
    const trigger = this.triggerTarget.getBoundingClientRect()
    const content = this.contentTarget
    const side = content.dataset.side || "bottom"
    const align = content.dataset.align || "center"

    // Reset position
    content.style.top = ""
    content.style.left = ""
    content.style.right = ""
    content.style.bottom = ""

    const gap = 8 // Gap between trigger and content

    switch (side) {
      case "top":
        content.style.bottom = "100%"
        content.style.marginBottom = `${gap}px`
        break
      case "bottom":
        content.style.top = "100%"
        content.style.marginTop = `${gap}px`
        break
      case "left":
        content.style.right = "100%"
        content.style.marginRight = `${gap}px`
        content.style.top = "0"
        break
      case "right":
        content.style.left = "100%"
        content.style.marginLeft = `${gap}px`
        content.style.top = "0"
        break
    }

    // Handle alignment for top/bottom
    if (side === "top" || side === "bottom") {
      switch (align) {
        case "start":
          content.style.left = "0"
          break
        case "end":
          content.style.right = "0"
          break
        case "center":
        default:
          content.style.left = "50%"
          content.style.transform = "translateX(-50%)"
          break
      }
    }
  }
}
