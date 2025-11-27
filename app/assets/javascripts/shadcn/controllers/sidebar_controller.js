import { Controller } from "@hotwired/stimulus"
import { useMatchMedia } from "stimulus-use"

// Constants for sidebar dimensions
const SIDEBAR_COOKIE_NAME = "sidebar:state"
const SIDEBAR_COOKIE_MAX_AGE = 60 * 60 * 24 * 7 // 7 days
const SIDEBAR_WIDTH = "16rem"
const SIDEBAR_WIDTH_MOBILE = "18rem"
const SIDEBAR_WIDTH_ICON = "3rem"

/**
 * Sidebar Controller
 * Uses stimulus-use useMatchMedia for responsive behavior
 */
export default class extends Controller {
  static targets = ["sidebar"]
  static values = {
    open: { type: Boolean, default: true },
    openMobile: { type: Boolean, default: false },
    keyboardShortcut: { type: String, default: "b" }
  }

  connect() {
    // Set initial state from cookie if available
    const savedState = this.getCookie(SIDEBAR_COOKIE_NAME)
    if (savedState !== null) {
      this.openValue = savedState === "true"
    }

    // Set up keyboard shortcut
    this.handleKeyDown = this.handleKeyDown.bind(this)
    document.addEventListener("keydown", this.handleKeyDown)

    // Use stimulus-use for responsive media query detection
    this.isMobile = window.innerWidth < 768
    useMatchMedia(this, {
      mediaQueries: {
        mobile: "(max-width: 767px)"
      }
    })

    // Initial state sync
    this.syncState()
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeyDown)
  }

  // Called by stimulus-use when mobile media query state changes
  mobileChanged({ matches }) {
    const wasMobile = this.isMobile
    this.isMobile = matches

    // Close mobile sidebar when switching to desktop
    if (wasMobile && !this.isMobile) {
      this.openMobileValue = false
    }

    this.syncState()
  }

  handleKeyDown(event) {
    // Check for Cmd/Ctrl + keyboard shortcut
    if (
      (event.metaKey || event.ctrlKey) &&
      event.key.toLowerCase() === this.keyboardShortcutValue.toLowerCase()
    ) {
      event.preventDefault()
      this.toggle()
    }
  }

  toggle() {
    if (this.isMobile) {
      this.openMobileValue = !this.openMobileValue
    } else {
      this.openValue = !this.openValue
    }
  }

  setOpen(open) {
    if (this.isMobile) {
      this.openMobileValue = open
    } else {
      this.openValue = open
    }
  }

  openValueChanged() {
    this.syncState()
    // Save to cookie
    this.setCookie(SIDEBAR_COOKIE_NAME, String(this.openValue), SIDEBAR_COOKIE_MAX_AGE)
  }

  openMobileValueChanged() {
    this.syncState()
  }

  syncState() {
    const state = this.isMobile ? (this.openMobileValue ? "expanded" : "collapsed") : (this.openValue ? "expanded" : "collapsed")

    // Update data attributes on the provider element
    this.element.dataset.state = state
    this.element.dataset.mobile = this.isMobile

    // Update sidebar targets if they exist
    if (this.hasSidebarTarget) {
      this.sidebarTargets.forEach(sidebar => {
        sidebar.dataset.state = state
        sidebar.dataset.mobile = this.isMobile
      })
    }

    // Dispatch custom event for other components to listen to
    this.element.dispatchEvent(new CustomEvent("sidebar:state-change", {
      bubbles: true,
      detail: {
        open: this.isMobile ? this.openMobileValue : this.openValue,
        isMobile: this.isMobile,
        state: state
      }
    }))
  }

  // Cookie helpers
  getCookie(name) {
    const value = `; ${document.cookie}`
    const parts = value.split(`; ${name}=`)
    if (parts.length === 2) {
      return parts.pop().split(";").shift()
    }
    return null
  }

  setCookie(name, value, maxAge) {
    document.cookie = `${name}=${value}; path=/; max-age=${maxAge}; SameSite=Lax`
  }

  // Actions for external triggers
  open() {
    this.setOpen(true)
  }

  close() {
    this.setOpen(false)
  }

  // Handle clicking outside on mobile to close
  clickOutside(event) {
    if (this.isMobile && this.openMobileValue) {
      const sidebar = this.sidebarTargets[0]
      if (sidebar && !sidebar.contains(event.target)) {
        this.openMobileValue = false
      }
    }
  }
}
