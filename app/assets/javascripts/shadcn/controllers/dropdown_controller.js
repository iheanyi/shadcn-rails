import BaseMenuController from "./base_menu_controller"

/**
 * Dropdown controller for dropdown menus
 * Extends BaseMenuController with dropdown-specific positioning
 */
export default class extends BaseMenuController {
  static targets = [...BaseMenuController.targets]
  static values = {
    ...BaseMenuController.values,
    align: { type: String, default: "end" },
    side: { type: String, default: "bottom" }
  }

  show(event) {
    // Store side value for positioning before showing
    if (this.hasContentTarget) {
      this.contentTarget.dataset.side = this.sideValue
    }
    super.show(event)
  }

  positionContent() {
    if (!this.hasContentTarget || !this.hasTriggerTarget) return

    const trigger = this.triggerTarget.getBoundingClientRect()
    const content = this.contentTarget

    // Position based on side and align
    content.style.position = "absolute"
    content.style.minWidth = `${trigger.width}px`

    switch (this.sideValue) {
      case "top":
        content.style.bottom = "100%"
        content.style.top = "auto"
        content.style.marginBottom = "4px"
        break
      case "bottom":
      default:
        content.style.top = "100%"
        content.style.bottom = "auto"
        content.style.marginTop = "4px"
        break
    }

    switch (this.alignValue) {
      case "start":
        content.style.left = "0"
        content.style.right = "auto"
        break
      case "center":
        content.style.left = "50%"
        content.style.transform = "translateX(-50%)"
        break
      case "end":
      default:
        content.style.right = "0"
        content.style.left = "auto"
        break
    }
  }

  toggleCheckbox(event) {
    const item = event.currentTarget
    if (item.dataset.disabled !== undefined) return

    const isChecked = item.dataset.state === "checked"
    item.dataset.state = isChecked ? "unchecked" : "checked"
    item.setAttribute("aria-checked", (!isChecked).toString())

    // Toggle the check icon visibility
    const indicator = item.querySelector("span svg")
    if (indicator) {
      indicator.style.display = isChecked ? "none" : "block"
    }

    this.dispatch("check", { detail: { item, checked: !isChecked } })
  }

  selectRadio(event) {
    const item = event.currentTarget
    if (item.dataset.disabled !== undefined) return

    const group = item.closest("[role='group']")
    if (group) {
      // Uncheck all radio items in the group
      group.querySelectorAll("[role='menuitemradio']").forEach(radio => {
        radio.dataset.state = "unchecked"
        radio.setAttribute("aria-checked", "false")
        const indicator = radio.querySelector("span svg")
        if (indicator) indicator.style.display = "none"
      })
    }

    // Check this item
    item.dataset.state = "checked"
    item.setAttribute("aria-checked", "true")
    const indicator = item.querySelector("span svg")
    if (indicator) indicator.style.display = "block"

    this.dispatch("radioChange", { detail: { item, value: item.dataset.value } })
  }
}
