import { Controller } from "@hotwired/stimulus"

/**
 * Tabs controller for tabbed interfaces
 * Handles tab selection, keyboard navigation, content switching, and URL sync
 */
export default class extends Controller {
  static targets = ["list", "trigger", "content"]
  static values = {
    defaultValue: String,
    urlParam: String // Query parameter name for URL sync (e.g., "tab")
  }

  connect() {
    // Determine initial tab value
    let initialValue = this.getValueFromUrl() || this.defaultValueValue || this.triggerTargets[0]?.dataset.value

    if (initialValue) {
      // Validate that the value exists in our triggers
      const validValues = this.triggerTargets.map(t => t.dataset.value)
      if (!validValues.includes(initialValue)) {
        initialValue = this.defaultValueValue || this.triggerTargets[0]?.dataset.value
      }
      this.selectTabByValue(initialValue, false) // Don't update URL on initial load
    }

    // Listen for browser back/forward navigation
    if (this.hasUrlParamValue) {
      window.addEventListener("popstate", this.handlePopState.bind(this))
    }
  }

  disconnect() {
    if (this.hasUrlParamValue) {
      window.removeEventListener("popstate", this.handlePopState.bind(this))
    }
  }

  handlePopState() {
    const value = this.getValueFromUrl()
    if (value) {
      this.selectTabByValue(value, false)
    }
  }

  getValueFromUrl() {
    if (!this.hasUrlParamValue) return null

    const url = new URL(window.location.href)
    return url.searchParams.get(this.urlParamValue)
  }

  updateUrl(value) {
    if (!this.hasUrlParamValue) return

    const url = new URL(window.location.href)
    url.searchParams.set(this.urlParamValue, value)
    window.history.replaceState({}, "", url.toString())
  }

  selectTab(event) {
    const trigger = event.currentTarget
    const value = trigger.dataset.value
    this.selectTabByValue(value, true)
  }

  selectTabByValue(value, updateUrl = true) {
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

    // Update URL if enabled
    if (updateUrl) {
      this.updateUrl(value)
    }

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
