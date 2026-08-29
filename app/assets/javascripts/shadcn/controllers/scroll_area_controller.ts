import { Controller } from "@hotwired/stimulus"

/**
 * Scroll Area controller for custom scrollbars
 */
export default class extends Controller<HTMLElement> {
  static targets = ["viewport", "scrollbar", "thumb"]
  static values = {
    orientation: { type: String, default: "vertical" },
    type: { type: String, default: "hover" }
  }

  connect() {
    this.updateScrollbar()

    if (this.hasViewportTarget) {
      this.viewportTarget.addEventListener("scroll", this.handleScroll.bind(this))
    }

    // Show scrollbar based on type
    if (this.typeValue === "always") {
      this.showScrollbar()
    }
  }

  disconnect() {
    if (this.hasViewportTarget) {
      this.viewportTarget.removeEventListener("scroll", this.handleScroll.bind(this))
    }
  }

  handleScroll() {
    this.updateScrollbar()
  }

  updateScrollbar() {
    if (!this.hasViewportTarget || !this.hasThumbTarget) return

    const viewport = this.viewportTarget
    const thumb = this.thumbTarget

    if (this.orientationValue === "vertical" || this.orientationValue === "both") {
      const scrollRatio = viewport.scrollTop / (viewport.scrollHeight - viewport.clientHeight)
      const thumbHeight = Math.max((viewport.clientHeight / viewport.scrollHeight) * 100, 10)
      const thumbTop = scrollRatio * (100 - thumbHeight)

      thumb.style.height = `${thumbHeight}%`
      thumb.style.top = `${thumbTop}%`
    }

    if (this.orientationValue === "horizontal" || this.orientationValue === "both") {
      const scrollRatio = viewport.scrollLeft / (viewport.scrollWidth - viewport.clientWidth)
      const thumbWidth = Math.max((viewport.clientWidth / viewport.scrollWidth) * 100, 10)
      const thumbLeft = scrollRatio * (100 - thumbWidth)

      thumb.style.width = `${thumbWidth}%`
      thumb.style.left = `${thumbLeft}%`
    }
  }

  showScrollbar() {
    this.scrollbarTargets.forEach((scrollbar: HTMLElement) => {
      scrollbar.style.opacity = "1"
    })
  }

  hideScrollbar() {
    if (this.typeValue !== "always") {
      this.scrollbarTargets.forEach((scrollbar: HTMLElement) => {
        scrollbar.style.opacity = "0"
      })
    }
  }
}
