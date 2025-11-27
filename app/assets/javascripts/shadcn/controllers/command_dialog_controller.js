import { Controller } from "@hotwired/stimulus"

/**
 * Command Dialog controller for command palette in modal
 * Extends dialog functionality with keyboard shortcut support
 */
export default class extends Controller {
  static targets = ["trigger", "template", "overlay", "content"]
  static values = {
    open: { type: Boolean, default: false },
    shortcut: { type: String, default: "" }
  }

  connect() {
    this.portal = null
    this.previousActiveElement = null
    this.boundHandleKeydown = this.handleKeydown.bind(this)
    this.boundHandleShortcut = this.handleShortcut.bind(this)

    // Listen for keyboard shortcut
    if (this.shortcutValue) {
      document.addEventListener("keydown", this.boundHandleShortcut)
    }

    if (this.openValue) {
      this.open()
    }
  }

  disconnect() {
    this.close()
    if (this.portal) {
      this.portal.remove()
    }
    document.removeEventListener("keydown", this.boundHandleShortcut)
  }

  /**
   * Handle global keyboard shortcut (e.g., Cmd+K)
   */
  handleShortcut(event) {
    if (!this.shortcutValue) return

    const key = this.shortcutValue.toLowerCase()
    if (event.key.toLowerCase() === key && (event.metaKey || event.ctrlKey)) {
      event.preventDefault()
      this.toggle()
    }
  }

  open() {
    if (this.openValue) return

    this.previousActiveElement = document.activeElement
    this.openValue = true

    // Move template content to body
    if (this.hasTemplateTarget && !this.portal) {
      this.portal = document.createElement("div")
      this.portal.className = "shadcn-command-dialog-portal"
      this.portal.innerHTML = this.templateTarget.innerHTML
      document.body.appendChild(this.portal)

      // Re-query targets from portal
      this.portalOverlay = this.portal.querySelector('[data-shadcn--command-dialog-target="overlay"]')
      this.portalContent = this.portal.querySelector('[data-shadcn--command-dialog-target="content"]')

      // Setup overlay click to close
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

      // Focus the command input
      this.focusInput()

      // Prevent body scroll
      document.body.style.overflow = "hidden"
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
    }
  }

  focusInput() {
    if (!this.portalContent) return

    const input = this.portalContent.querySelector('input[data-shadcn--command-target="input"]')
    if (input) {
      setTimeout(() => input.focus(), 50)
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
