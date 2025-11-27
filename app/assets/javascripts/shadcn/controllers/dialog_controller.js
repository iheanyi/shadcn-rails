import { Controller } from "@hotwired/stimulus"

/**
 * Dialog controller for modal dialogs
 * Handles opening, closing, focus trapping, and keyboard navigation
 */
export default class extends Controller {
  static targets = ["trigger", "template", "overlay", "content"]
  static values = {
    open: { type: Boolean, default: false },
    modal: { type: Boolean, default: true }
  }

  connect() {
    this.portal = null
    this.previousActiveElement = null
    this.boundHandleKeydown = this.handleKeydown.bind(this)
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)

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
      this.portal.className = "shadcn-dialog-portal"
      this.portal.innerHTML = this.templateTarget.innerHTML
      document.body.appendChild(this.portal)

      // Re-query targets from portal
      this.portalOverlay = this.portal.querySelector('[data-shadcn--dialog-target="overlay"]')
      this.portalContent = this.portal.querySelector('[data-shadcn--dialog-target="content"]')

      // Wire up close actions on portal elements (since they're outside controller scope)
      this.portal.querySelectorAll('[data-action*="shadcn--dialog#close"]').forEach(el => {
        el.addEventListener("click", (e) => {
          e.preventDefault()
          this.close()
        })
      })

      // Also handle overlay click
      if (this.portalOverlay) {
        this.portalOverlay.addEventListener("click", () => this.close())
      }
    }

    // Show overlay and content
    requestAnimationFrame(() => {
      if (this.portalOverlay) {
        this.portalOverlay.dataset.state = "open"
        this.portalOverlay.removeAttribute("hidden")
      }
      if (this.portalContent) {
        this.portalContent.dataset.state = "open"
        this.portalContent.removeAttribute("hidden")
      }

      // Setup event listeners
      document.addEventListener("keydown", this.boundHandleKeydown)

      // Focus first focusable element
      this.focusFirstElement()

      // Prevent body scroll
      if (this.modalValue) {
        document.body.style.overflow = "hidden"
      }
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

    // Remove event listeners
    document.removeEventListener("keydown", this.boundHandleKeydown)

    // Restore body scroll
    document.body.style.overflow = ""

    // Return focus
    if (this.previousActiveElement) {
      this.previousActiveElement.focus()
    }

    // Remove portal after animation
    setTimeout(() => {
      if (this.portal) {
        this.portal.remove()
        this.portal = null
      }
    }, 200)

    this.dispatch("closed")
  }

  toggle() {
    if (this.openValue) {
      this.close()
    } else {
      this.open()
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    } else if (event.key === "Tab" && this.modalValue) {
      this.trapFocus(event)
    }
  }

  handleClickOutside(event) {
    if (this.portalContent && !this.portalContent.contains(event.target)) {
      this.close()
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

  trapFocus(event) {
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

  openValueChanged() {
    if (this.openValue) {
      this.open()
    } else {
      this.close()
    }
  }
}
