import { Controller } from "@hotwired/stimulus"

/**
 * Avatar controller for handling image load errors
 */
export default class extends Controller<HTMLElement> {
  static targets = ["image", "fallback"]

  handleError() {
    if (this.hasImageTarget) {
      this.imageTarget.hidden = true
    }
    if (this.hasFallbackTarget) {
      this.fallbackTarget.classList.remove("hidden")
    }
  }

  handleLoad() {
    if (this.hasImageTarget) {
      this.imageTarget.hidden = false
    }
    if (this.hasFallbackTarget) {
      this.fallbackTarget.classList.add("hidden")
    }
  }
}
