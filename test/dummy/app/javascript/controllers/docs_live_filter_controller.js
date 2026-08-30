import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 275 }
  }

  connect() {
    this.timeout = null
  }

  disconnect() {
    this.clearPendingSubmit()
  }

  submitNow() {
    this.clearPendingSubmit()
    this.submitForm()
  }

  submitLater() {
    this.clearPendingSubmit()
    this.timeout = window.setTimeout(() => {
      this.submitForm()
    }, this.delayValue)
  }

  submitForm() {
    if (this.element instanceof HTMLFormElement) {
      this.element.requestSubmit()
    }
  }

  clearPendingSubmit() {
    if (!this.timeout) return

    window.clearTimeout(this.timeout)
    this.timeout = null
  }
}
