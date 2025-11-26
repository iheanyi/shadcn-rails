import { Controller } from "@hotwired/stimulus"

/**
 * Toast controller for notification toasts
 */
export default class extends Controller {
  static values = {
    duration: { type: Number, default: 5000 },
    open: { type: Boolean, default: true }
  }

  connect() {
    if (this.openValue && this.durationValue > 0) {
      this.startDismissTimer()
    }
  }

  disconnect() {
    this.clearDismissTimer()
  }

  close() {
    this.openValue = false
    this.element.dataset.state = "closed"

    // Remove after animation
    setTimeout(() => {
      this.element.remove()
      this.dispatch("closed")
    }, 200)
  }

  startDismissTimer() {
    this.clearDismissTimer()
    this.dismissTimeout = setTimeout(() => {
      this.close()
    }, this.durationValue)
  }

  clearDismissTimer() {
    if (this.dismissTimeout) {
      clearTimeout(this.dismissTimeout)
      this.dismissTimeout = null
    }
  }

  // Pause timer on hover
  pause() {
    this.clearDismissTimer()
  }

  // Resume timer when hover ends
  resume() {
    if (this.openValue && this.durationValue > 0) {
      this.startDismissTimer()
    }
  }
}
