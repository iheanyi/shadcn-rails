import { Controller } from "@hotwired/stimulus"

/**
 * Checkbox controller for custom checkboxes
 */
export default class extends Controller<HTMLElement> {
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

    // Update checkmark visibility
    const checkIcon = this.element.querySelector("svg")
    if (checkIcon) {
      checkIcon.style.opacity = this.checkedValue ? "1" : "0"
    }
  }

  updateHiddenInput() {
    if (!this.nameValue) return

    // Find or create hidden input
    let input = this.element.parentElement?.querySelector(`input[name="${this.nameValue}"]`)
    if (input) {
      input.value = this.checkedValue ? "1" : "0"
    }
  }

  checkedValueChanged() {
    this.updateState()
  }
}
