import { Controller } from "@hotwired/stimulus"

/**
 * Toggle Group Controller
 * Handles single or multiple selection of toggle items
 */
export default class extends Controller {
  static targets = ["item", "input"]
  static values = {
    type: { type: String, default: "single" }, // "single" or "multiple"
    value: { type: String, default: "" }
  }

  connect() {
    this.updateStates()
  }

  toggle(event) {
    const item = event.currentTarget
    const value = item.dataset.value
    const currentValues = this.getValues()

    if (this.typeValue === "single") {
      // Single selection - toggle or select new
      if (currentValues.includes(value)) {
        this.valueValue = ""
      } else {
        this.valueValue = value
      }
    } else {
      // Multiple selection - toggle individual item
      if (currentValues.includes(value)) {
        this.valueValue = currentValues.filter(v => v !== value).join(",")
      } else {
        this.valueValue = [...currentValues, value].filter(Boolean).join(",")
      }
    }

    this.updateStates()
    this.updateInput()
    this.dispatch("change", { detail: { value: this.getValues() } })
  }

  getValues() {
    return this.valueValue.split(",").filter(Boolean)
  }

  updateStates() {
    const values = this.getValues()

    this.itemTargets.forEach(item => {
      const isOn = values.includes(item.dataset.value)
      item.setAttribute("data-state", isOn ? "on" : "off")
      item.setAttribute("aria-pressed", isOn.toString())
    })
  }

  updateInput() {
    if (this.hasInputTarget) {
      this.inputTarget.value = this.valueValue
    }
  }

  valueValueChanged() {
    this.updateStates()
    this.updateInput()
  }
}
