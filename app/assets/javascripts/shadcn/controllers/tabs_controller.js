import { Controller } from "@hotwired/stimulus"

/**
 * Tabs controller for tabbed interfaces
 * Handles tab selection, keyboard navigation, and content switching
 */
export default class extends Controller {
  static targets = ["list", "trigger", "content"]
  static values = {
    defaultValue: String
  }

  connect() {
    // Set initial tab
    const initialValue = this.defaultValueValue || this.triggerTargets[0]?.dataset.value
    if (initialValue) {
      this.selectTabByValue(initialValue)
    }
  }

  selectTab(event) {
    const trigger = event.currentTarget
    const value = trigger.dataset.value
    this.selectTabByValue(value)
  }

  selectTabByValue(value) {
    // Update triggers
    this.triggerTargets.forEach(trigger => {
      const isSelected = trigger.dataset.value === value
      trigger.dataset.state = isSelected ? "active" : "inactive"
      trigger.setAttribute("aria-selected", isSelected.toString())
      trigger.tabIndex = isSelected ? 0 : -1
    })

    // Update content panels
    this.contentTargets.forEach(content => {
      const isSelected = content.dataset.value === value
      content.dataset.state = isSelected ? "active" : "inactive"
      content.hidden = !isSelected
    })

    this.dispatch("change", { detail: { value } })
  }

  // Keyboard navigation
  handleKeydown(event) {
    const triggers = this.triggerTargets.filter(t => !t.disabled)
    const currentIndex = triggers.findIndex(t => t === document.activeElement)

    if (currentIndex === -1) return

    let newIndex = currentIndex

    switch (event.key) {
      case "ArrowLeft":
      case "ArrowUp":
        event.preventDefault()
        newIndex = currentIndex === 0 ? triggers.length - 1 : currentIndex - 1
        break
      case "ArrowRight":
      case "ArrowDown":
        event.preventDefault()
        newIndex = currentIndex === triggers.length - 1 ? 0 : currentIndex + 1
        break
      case "Home":
        event.preventDefault()
        newIndex = 0
        break
      case "End":
        event.preventDefault()
        newIndex = triggers.length - 1
        break
      default:
        return
    }

    triggers[newIndex].focus()
    triggers[newIndex].click()
  }
}
