import { Controller } from "@hotwired/stimulus"

/**
 * Drawer Controller
 * Handles opening/closing drawer panels with swipe support
 */
export default class extends Controller<HTMLElement> {
  static targets = ["trigger", "template", "overlay", "content"]
  static values = {
    open: { type: Boolean, default: false },
    direction: { type: String, default: "bottom" }
  }

  connect() {
    this.portal = null
    this.boundHandleKeydown = this.handleKeydown.bind(this)

    if (this.openValue) {
      this.open()
    }
  }

  disconnect() {
    this.removePortal()
    document.removeEventListener("keydown", this.boundHandleKeydown)
  }

  open() {
    if (!this.hasTemplateTarget) return

    // Create portal at body level
    this.portal = document.createElement("div")
    this.portal.innerHTML = this.templateTarget.innerHTML
    document.body.appendChild(this.portal)

    // Get references to portal elements
    const overlay = this.portal.querySelector("[data-shadcn--drawer-target='overlay']")
    const content = this.portal.querySelector("[data-shadcn--drawer-target='content']")

    // Add click handler to overlay
    if (overlay) {
      overlay.addEventListener("click", () => this.close())
    }

    // Set open state
    requestAnimationFrame(() => {
      if (overlay) overlay.setAttribute("data-state", "open")
      if (content) {
        content.setAttribute("data-state", "open")
        content.focus()
      }
    })

    // Prevent body scroll
    document.body.style.overflow = "hidden"
    document.addEventListener("keydown", this.boundHandleKeydown)

    this.openValue = true
    this.dispatch("open")
  }

  close() {
    if (!this.portal) return

    const overlay = this.portal.querySelector("[data-shadcn--drawer-target='overlay']")
    const content = this.portal.querySelector("[data-shadcn--drawer-target='content']")

    // Set closing state
    if (overlay) overlay.setAttribute("data-state", "closed")
    if (content) content.setAttribute("data-state", "closed")

    // Wait for animation then remove portal
    setTimeout(() => {
      this.removePortal()
    }, 200)

    document.body.style.overflow = ""
    document.removeEventListener("keydown", this.boundHandleKeydown)

    this.openValue = false
    this.dispatch("close")
  }

  toggle() {
    if (this.openValue) {
      this.close()
    } else {
      this.open()
    }
  }

  handleKeydown(event: ShadcnEvent) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  removePortal() {
    if (this.portal) {
      this.portal.remove()
      this.portal = null
    }
  }

  openValueChanged() {
    if (this.openValue && !this.portal) {
      this.open()
    } else if (!this.openValue && this.portal) {
      this.close()
    }
  }
}
