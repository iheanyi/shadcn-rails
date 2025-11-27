import { Controller } from "@hotwired/stimulus"

/**
 * Combobox controller for searchable select dropdown
 * Handles open/close, filtering, keyboard navigation, and item selection
 */
export default class extends Controller {
  static targets = ["trigger", "content", "input", "list", "item", "empty", "displayValue", "hiddenInput"]
  static values = {
    open: { type: Boolean, default: false },
    value: { type: String, default: "" },
    selectedIndex: { type: Number, default: -1 }
  }

  connect() {
    this.boundHandleKeydown = this.handleKeydown.bind(this)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundHandleKeydown)
  }

  toggle() {
    if (this.openValue) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    if (this.openValue) return

    this.openValue = true
    this.contentTarget.hidden = false
    this.contentTarget.dataset.state = "open"
    this.triggerTarget.setAttribute("aria-expanded", "true")

    // Focus the input
    requestAnimationFrame(() => {
      if (this.hasInputTarget) {
        this.inputTarget.focus()
      }
    })

    // Add keyboard listener
    document.addEventListener("keydown", this.boundHandleKeydown)

    // Reset selection index
    this.selectedIndexValue = -1
    this.updateSelection()
  }

  close() {
    if (!this.openValue) return

    this.openValue = false
    this.contentTarget.dataset.state = "closed"
    this.triggerTarget.setAttribute("aria-expanded", "false")

    // Clear search
    if (this.hasInputTarget) {
      this.inputTarget.value = ""
      this.filter()
    }

    // Hide after animation
    setTimeout(() => {
      this.contentTarget.hidden = true
    }, 150)

    // Remove keyboard listener
    document.removeEventListener("keydown", this.boundHandleKeydown)
  }

  /**
   * Filter items based on input value
   */
  filter() {
    const query = this.hasInputTarget ? this.inputTarget.value.toLowerCase().trim() : ""
    let visibleCount = 0

    this.itemTargets.forEach((item) => {
      const label = item.dataset.label?.toLowerCase() || item.textContent.toLowerCase()
      const value = item.dataset.value?.toLowerCase() || ""
      const matches = query === "" || label.includes(query) || value.includes(query)
      item.hidden = !matches
      if (matches) visibleCount++
    })

    // Show/hide empty state
    if (this.hasEmptyTarget) {
      this.emptyTarget.hidden = visibleCount > 0
    }

    // Reset selection
    this.selectedIndexValue = -1
    this.updateSelection()
  }

  /**
   * Select an item
   */
  select(event) {
    const item = event.currentTarget
    const value = item.dataset.value
    const label = item.dataset.label

    // Update value
    this.valueValue = value

    // Update hidden input for form submission
    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = value
    }

    // Update display value
    if (this.hasDisplayValueTarget) {
      this.displayValueTarget.textContent = label
      this.displayValueTarget.classList.remove("text-muted-foreground")
    }

    // Update selected state on items
    this.itemTargets.forEach((i) => {
      const isSelected = i.dataset.value === value
      i.dataset.selected = isSelected
      // Update check icon opacity
      const checkIcon = i.querySelector("svg")
      if (checkIcon) {
        if (isSelected) {
          checkIcon.classList.remove("opacity-0")
          checkIcon.classList.add("opacity-100")
        } else {
          checkIcon.classList.remove("opacity-100")
          checkIcon.classList.add("opacity-0")
        }
      }
    })

    // Dispatch change event
    this.dispatch("change", { detail: { value, label } })

    // Close the dropdown
    this.close()
  }

  /**
   * Handle keyboard navigation
   */
  handleKeydown(event) {
    const visibleItems = this.getVisibleItems()

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.selectedIndexValue = Math.min(this.selectedIndexValue + 1, visibleItems.length - 1)
        this.updateSelection()
        break
      case "ArrowUp":
        event.preventDefault()
        this.selectedIndexValue = Math.max(this.selectedIndexValue - 1, 0)
        this.updateSelection()
        break
      case "Enter":
        event.preventDefault()
        if (this.selectedIndexValue >= 0 && visibleItems[this.selectedIndexValue]) {
          // Simulate click on the selected item
          visibleItems[this.selectedIndexValue].click()
        }
        break
      case "Escape":
        event.preventDefault()
        this.close()
        break
    }
  }

  /**
   * Update visual selection state
   */
  updateSelection() {
    const visibleItems = this.getVisibleItems()

    visibleItems.forEach((item, index) => {
      if (index === this.selectedIndexValue) {
        item.classList.add("bg-accent", "text-accent-foreground")
        item.scrollIntoView({ block: "nearest" })
      } else {
        item.classList.remove("bg-accent", "text-accent-foreground")
      }
    })
  }

  /**
   * Get all visible items
   */
  getVisibleItems() {
    return this.itemTargets.filter((item) => !item.hidden)
  }

  /**
   * Handle click outside to close
   */
  handleClickOutside(event) {
    if (!this.openValue) return

    if (!this.element.contains(event.target)) {
      this.close()
    }
  }
}
