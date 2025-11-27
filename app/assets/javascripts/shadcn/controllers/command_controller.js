import { Controller } from "@hotwired/stimulus"

/**
 * Command controller for command palette functionality
 * Handles filtering, keyboard navigation, and item selection
 */
export default class extends Controller {
  static targets = ["input", "list", "empty", "group", "item"]
  static values = {
    selectedIndex: { type: Number, default: -1 }
  }

  connect() {
    this.updateSelection()
  }

  /**
   * Filter items based on input value
   */
  filter() {
    const query = this.hasInputTarget ? this.inputTarget.value.toLowerCase().trim() : ""
    let visibleCount = 0

    // Filter items
    this.itemTargets.forEach((item) => {
      const value = item.dataset.value?.toLowerCase() || item.textContent.toLowerCase()
      const matches = query === "" || value.includes(query)
      item.hidden = !matches
      if (matches) visibleCount++
    })

    // Filter groups - hide if all items are hidden
    this.groupTargets.forEach((group) => {
      const visibleItems = group.querySelectorAll('[data-shadcn--command-target="item"]:not([hidden])')
      group.hidden = visibleItems.length === 0
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
          this.selectItem(visibleItems[this.selectedIndexValue])
        }
        break
      case "Escape":
        if (this.hasInputTarget && this.inputTarget.value) {
          event.preventDefault()
          this.inputTarget.value = ""
          this.filter()
        }
        break
    }
  }

  /**
   * Select an item via click
   */
  select(event) {
    const item = event.currentTarget
    if (item.dataset.disabled === "true") return
    this.selectItem(item)
  }

  /**
   * Handle item selection
   */
  selectItem(item) {
    if (!item || item.dataset.disabled === "true") return

    const value = item.dataset.value || item.textContent.trim()

    // Dispatch custom event
    this.dispatch("select", {
      detail: { value, item }
    })

    // Execute onSelect if provided
    if (item.dataset.onSelect) {
      new Function(item.dataset.onSelect)()
    }
  }

  /**
   * Update visual selection state
   */
  updateSelection() {
    const visibleItems = this.getVisibleItems()

    visibleItems.forEach((item, index) => {
      const isSelected = index === this.selectedIndexValue
      item.dataset.selected = isSelected
      if (isSelected) {
        item.scrollIntoView({ block: "nearest" })
      }
    })
  }

  /**
   * Get all visible (non-hidden, non-disabled) items
   */
  getVisibleItems() {
    return this.itemTargets.filter(
      (item) => !item.hidden && item.dataset.disabled !== "true"
    )
  }

  /**
   * Focus the input when connecting
   */
  focusInput() {
    if (this.hasInputTarget) {
      this.inputTarget.focus()
    }
  }
}
