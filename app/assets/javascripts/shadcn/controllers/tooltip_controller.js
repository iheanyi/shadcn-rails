import { Controller } from "@hotwired/stimulus"

/**
 * Tooltip controller for contextual information
 */
export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = {
    side: { type: String, default: "top" },
    align: { type: String, default: "center" },
    delay: { type: Number, default: 200 },
    skipDelay: { type: Number, default: 300 }
  }

  connect() {
    this.showTimeout = null
    this.hideTimeout = null
  }

  disconnect() {
    this.clearTimeouts()
  }

  show() {
    this.clearTimeouts()

    this.showTimeout = setTimeout(() => {
      if (this.hasContentTarget) {
        this.contentTarget.hidden = false
        this.contentTarget.dataset.state = "open"
        this.positionTooltip()
      }
    }, this.delayValue)
  }

  hide() {
    this.clearTimeouts()

    this.hideTimeout = setTimeout(() => {
      if (this.hasContentTarget) {
        this.contentTarget.dataset.state = "closed"
        setTimeout(() => {
          this.contentTarget.hidden = true
        }, 100)
      }
    }, 0)
  }

  clearTimeouts() {
    if (this.showTimeout) {
      clearTimeout(this.showTimeout)
      this.showTimeout = null
    }
    if (this.hideTimeout) {
      clearTimeout(this.hideTimeout)
      this.hideTimeout = null
    }
  }

  positionTooltip() {
    if (!this.hasContentTarget || !this.hasTriggerTarget) return

    const trigger = this.triggerTarget.getBoundingClientRect()
    const tooltip = this.contentTarget
    const tooltipRect = tooltip.getBoundingClientRect()

    // Reset positioning
    tooltip.style.position = "absolute"
    tooltip.style.top = ""
    tooltip.style.bottom = ""
    tooltip.style.left = ""
    tooltip.style.right = ""
    tooltip.style.transform = ""

    const gap = 8

    switch (this.sideValue) {
      case "top":
        tooltip.style.bottom = "100%"
        tooltip.style.marginBottom = `${gap}px`
        break
      case "bottom":
        tooltip.style.top = "100%"
        tooltip.style.marginTop = `${gap}px`
        break
      case "left":
        tooltip.style.right = "100%"
        tooltip.style.marginRight = `${gap}px`
        tooltip.style.top = "50%"
        tooltip.style.transform = "translateY(-50%)"
        break
      case "right":
        tooltip.style.left = "100%"
        tooltip.style.marginLeft = `${gap}px`
        tooltip.style.top = "50%"
        tooltip.style.transform = "translateY(-50%)"
        break
    }

    if (this.sideValue === "top" || this.sideValue === "bottom") {
      switch (this.alignValue) {
        case "start":
          tooltip.style.left = "0"
          break
        case "center":
          tooltip.style.left = "50%"
          tooltip.style.transform = "translateX(-50%)"
          break
        case "end":
          tooltip.style.right = "0"
          break
      }
    }

    tooltip.dataset.side = this.sideValue
  }
}
