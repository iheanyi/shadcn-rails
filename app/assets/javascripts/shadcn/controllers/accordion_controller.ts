import { Controller } from "@hotwired/stimulus"

/**
 * Accordion controller for collapsible sections
 * Supports single and multiple expansion modes
 */
export default class extends Controller<HTMLElement> {
  static targets = ["item", "trigger", "content"]
  static values = {
    type: { type: String, default: "single" }, // "single" or "multiple"
    collapsible: { type: Boolean, default: false },
    default: { type: String, default: "" } // comma-separated values for multiple
  }

  connect() {
    // Expand default items
    if (this.defaultValue) {
      const defaultValues = this.defaultValue.split(",").map((v: string) => v.trim())
      defaultValues.forEach((value: string) => {
        const item = this.findItemByValue(value)
        if (item) {
          this.expandItem(item)
        }
      })
    }
  }

  toggle(event: ShadcnEvent) {
    const trigger = event.currentTarget
    const item = trigger.closest('[data-shadcn--accordion-target="item"]')

    if (!item) return

    const isOpen = item.dataset.state === "open"

    if (isOpen) {
      if (this.collapsibleValue || this.typeValue === "multiple") {
        this.collapseItem(item)
      }
    } else {
      if (this.typeValue === "single") {
        // Collapse all other items first
        this.itemTargets.forEach((otherItem: HTMLElement) => {
          if (otherItem !== item && otherItem.dataset.state === "open") {
            this.collapseItem(otherItem)
          }
        })
      }
      this.expandItem(item)
    }
  }

  expandItem(item: HTMLElement) {
    const trigger = item.querySelector('[data-shadcn--accordion-target="trigger"]')
    const content = item.querySelector('[data-shadcn--accordion-target="content"]')

    if (!trigger || !content) return

    item.dataset.state = "open"
    trigger.dataset.state = "open"
    trigger.setAttribute("aria-expanded", "true")
    content.dataset.state = "open"
    content.hidden = false

    // Animate height
    const height = content.scrollHeight
    content.style.height = "0px"
    requestAnimationFrame(() => {
      content.style.height = `${height}px`
      // Remove fixed height after animation
      setTimeout(() => {
        content.style.height = ""
      }, 200)
    })

    this.dispatch("expand", { detail: { value: item.dataset.value } })
  }

  collapseItem(item: HTMLElement) {
    const trigger = item.querySelector('[data-shadcn--accordion-target="trigger"]')
    const content = item.querySelector('[data-shadcn--accordion-target="content"]')

    if (!trigger || !content) return

    // Set current height for animation
    content.style.height = `${content.scrollHeight}px`

    requestAnimationFrame(() => {
      item.dataset.state = "closed"
      trigger.dataset.state = "closed"
      trigger.setAttribute("aria-expanded", "false")
      content.dataset.state = "closed"
      content.style.height = "0px"

      setTimeout(() => {
        content.hidden = true
        content.style.height = ""
      }, 200)
    })

    this.dispatch("collapse", { detail: { value: item.dataset.value } })
  }

  findItemByValue(value: string) {
    return this.itemTargets.find((item: HTMLElement) => item.dataset.value === value)
  }

  // Keyboard navigation
  handleKeydown(event: ShadcnEvent) {
    const triggers = this.triggerTargets
    const currentIndex = triggers.findIndex((t: HTMLElement) => t === document.activeElement)

    if (currentIndex === -1) return

    let newIndex = currentIndex

    switch (event.key) {
      case "ArrowUp":
        event.preventDefault()
        newIndex = currentIndex === 0 ? triggers.length - 1 : currentIndex - 1
        break
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
  }
}
