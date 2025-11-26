import { Controller } from "@hotwired/stimulus"

/**
 * Switch controller for toggle switches
 */
export default class extends Controller {
  static values = {
    checked: { type: Boolean, default: false },
    name: String
  }

  connect() {
    this.updateState()
  }

  toggle() {
    this.checkedValue = !this.checkedValue
    this.updateState()
    this.updateHiddenInput()
    this.dispatch("change", { detail: { checked: this.checkedValue } })
  }

  updateState() {
    const state = this.checkedValue ? "checked" : "unchecked"
    this.element.dataset.state = state
    this.element.setAttribute("aria-checked", this.checkedValue.toString())

    // Update thumb position
    const thumb = this.element.querySelector("span")
    if (thumb) {
      thumb.dataset.state = state
    }
  }

  updateHiddenInput() {
    if (!this.nameValue) return

    let input = this.element.parentElement.querySelector(`input[name="${this.nameValue}"]`)
    if (input) {
      input.value = this.checkedValue ? "1" : "0"
    }
  }

  checkedValueChanged() {
    this.updateState()
  }
}
