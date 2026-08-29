import { Controller } from "@hotwired/stimulus"

/**
 * Radio Group Controller
 *
 * Handles radio group selection with keyboard navigation
 *
 * Targets:
 * - item: Individual radio buttons
 * - indicator: Visual indicator element
 *
 * Values:
 * - name: Input name for form submission
 * - value: Currently selected value
 */
export default class extends Controller<HTMLElement> {
  static targets = ["item", "indicator"]
  static values = {
    name: String,
    value: String
  }

  connect() {
    this.updateSelection()
  }

  select(event: ShadcnEvent) {
    const item = event.currentTarget
    if (item.disabled) return

    const value = item.dataset.value
    this.valueValue = value
    this.updateSelection()
    this.dispatchChange(value)
  }

  handleKeydown(event: ShadcnEvent) {
    const items = this.enabledItems
    const currentIndex = items.indexOf(event.currentTarget)
    let newIndex = currentIndex

    switch (event.key) {
      case "ArrowDown":
      case "ArrowRight":
        event.preventDefault()
        newIndex = (currentIndex + 1) % items.length
        break
      case "ArrowUp":
      case "ArrowLeft":
        event.preventDefault()
        newIndex = (currentIndex - 1 + items.length) % items.length
        break
      case " ":
      case "Enter":
        event.preventDefault()
        this.select(event)
        return
      default:
        return
    }

    const newItem = items[newIndex]
    newItem.focus()
    // Auto-select on arrow navigation (standard radio behavior)
    this.valueValue = newItem.dataset.value
    this.updateSelection()
    this.dispatchChange(newItem.dataset.value)
  }

  updateSelection() {
    this.itemTargets.forEach((item: HTMLElement) => {
      const isSelected = item.dataset.value === this.valueValue
      item.setAttribute("aria-checked", isSelected.toString())
      item.dataset.state = isSelected ? "checked" : "unchecked"
      item.tabIndex = isSelected ? 0 : -1

      // Update indicator visibility
      const indicator = item.querySelector("[data-shadcn--radio-group-target='indicator']")
      if (indicator) {
        indicator.classList.toggle("opacity-0", !isSelected)
      }
    })

    // Ensure at least one item is focusable if nothing selected
    if (!this.valueValue && this.itemTargets.length > 0) {
      this.enabledItems[0]?.setAttribute("tabindex", "0")
    }
  }

  dispatchChange(value: string) {
    this.dispatch("change", {
      detail: { value, name: this.nameValue }
    })

    // Also dispatch a native input event for form compatibility
    const event = new Event("input", { bubbles: true })
    this.element.dispatchEvent(event)
  }

  get enabledItems() {
    return this.itemTargets.filter((item: HTMLElement) => !item.disabled)
  }

  // Allow programmatic value setting
  valueValueChanged() {
    this.updateSelection()
  }
}
