import { Controller } from "@hotwired/stimulus"

/**
 * Switch Controller
 *
 * Handles toggle switch with hidden input sync for form submission
 *
 * Targets:
 * - button: The visual switch button element
 * - thumb: The sliding thumb element
 * - input: Hidden checkbox input for form submission
 *
 * Values:
 * - checked: Boolean indicating current state
 */
export default class extends Controller<HTMLElement> {
  static targets = ["button", "thumb", "input"]
  static values = {
    checked: { type: Boolean, default: false }
  }

  connect() {
    this.updateVisuals()
  }

  toggle() {
    if (this.hasButtonTarget && this.buttonTarget.disabled) return

    this.checkedValue = !this.checkedValue
    this.updateVisuals()
    this.syncInput()
    this.dispatchChange()
  }

  handleKeydown(event: ShadcnEvent) {
    if (event.key === " " || event.key === "Enter") {
      event.preventDefault()
      this.toggle()
    }
  }

  updateVisuals() {
    const state = this.checkedValue ? "checked" : "unchecked"

    // Update button state
    if (this.hasButtonTarget) {
      this.buttonTarget.dataset.state = state
      this.buttonTarget.setAttribute("aria-checked", this.checkedValue.toString())
    }

    // Update thumb position
    if (this.hasThumbTarget) {
      this.thumbTarget.dataset.state = state
    }

    // Update wrapper element state
    this.element.dataset.state = state
  }

  syncInput() {
    if (this.hasInputTarget) {
      this.inputTarget.checked = this.checkedValue
      // Dispatch native change event for form compatibility
      this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }))
    }
  }

  dispatchChange() {
    this.dispatch("change", {
      detail: { checked: this.checkedValue }
    })
  }

  checkedValueChanged() {
    this.updateVisuals()
    this.syncInput()
  }
}
