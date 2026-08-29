import { Controller } from "@hotwired/stimulus"

/**
 * Sheet controller for slide-out panels
 */
export default class extends Controller<HTMLElement> {
  static targets = ["trigger", "template", "overlay", "content"]
  static values = {
    open: { type: Boolean, default: false },
    side: { type: String, default: "right" }
  }

  connect() {
    this.portal = null
    this.previousActiveElement = null
    this.boundHandleKeydown = this.handleKeydown.bind(this)

    if (this.openValue) {
      this.open()
    }
  }

  disconnect() {
    this.close()
    if (this.portal) {
      this.portal.remove()
    }
  }

  open() {
    if (this.openValue) return

    this.previousActiveElement = document.activeElement
    this.openValue = true

    // Move template content to body
    if (this.hasTemplateTarget && !this.portal) {
      this.portal = document.createElement("div")
      this.portal.className = "shadcn-sheet-portal"
      this.portal.innerHTML = this.templateTarget.innerHTML
      document.body.appendChild(this.portal)

      this.portalOverlay = this.portal.querySelector('[data-shadcn--sheet-target="overlay"]')
      this.portalContent = this.portal.querySelector('[data-shadcn--sheet-target="content"]')

      // Re-attach event listeners for close buttons
      const closeButtons = this.portal.querySelectorAll('[data-action*="shadcn--sheet#close"]')
      closeButtons.forEach((btn: HTMLElement) => {
        btn.addEventListener("click", () => this.close())
      })
    }

    requestAnimationFrame(() => {
      if (this.portalOverlay) {
        this.portalOverlay.dataset.state = "open"
        this.portalOverlay.removeAttribute("hidden")
      }
      if (this.portalContent) {
        this.portalContent.dataset.state = "open"
        this.portalContent.removeAttribute("hidden")
      }

      document.addEventListener("keydown", this.boundHandleKeydown)
      document.body.style.overflow = "hidden"

      this.focusFirstElement()
    })

    this.dispatch("opened")
  }

  close() {
    if (!this.openValue) return

    this.openValue = false

    if (this.portalOverlay) {
      this.portalOverlay.dataset.state = "closed"
    }
    if (this.portalContent) {
      this.portalContent.dataset.state = "closed"
    }

    document.removeEventListener("keydown", this.boundHandleKeydown)
    document.body.style.overflow = ""

    if (this.previousActiveElement) {
      this.previousActiveElement.focus()
    }

    setTimeout(() => {
      if (this.portal) {
        this.portal.remove()
        this.portal = null
      }
    }, 300)

    this.dispatch("closed")
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
    } else if (event.key === "Tab") {
      this.trapFocus(event)
    }
  }

  focusFirstElement() {
    if (!this.portalContent) return

    const focusable = this.portalContent.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    )
    if (focusable.length > 0) {
      focusable[0].focus()
    } else {
      this.portalContent.focus()
    }
  }

  trapFocus(event: ShadcnEvent) {
    if (!this.portalContent) return

    const focusable = this.portalContent.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    )
    const firstFocusable = focusable[0]
    const lastFocusable = focusable[focusable.length - 1]

    if (event.shiftKey) {
      if (document.activeElement === firstFocusable) {
        lastFocusable.focus()
        event.preventDefault()
      }
    } else {
      if (document.activeElement === lastFocusable) {
        firstFocusable.focus()
        event.preventDefault()
      }
    }
  }
}
