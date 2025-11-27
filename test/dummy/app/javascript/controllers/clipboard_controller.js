import { Controller } from "@hotwired/stimulus"

/**
 * Clipboard controller for copying code to clipboard
 *
 * Usage:
 *   <div data-controller="clipboard">
 *     <pre data-clipboard-target="source"><code>const foo = "bar"</code></pre>
 *     <button data-action="click->clipboard#copy" data-clipboard-target="button">Copy</button>
 *   </div>
 */
export default class extends Controller {
  static targets = ["source", "button"]
  static values = {
    successText: { type: String, default: "Copied!" },
    successDuration: { type: Number, default: 2000 }
  }

  copy() {
    const text = this.sourceTarget.textContent

    navigator.clipboard.writeText(text).then(() => {
      this.showSuccess()
    }).catch((err) => {
      console.error("Failed to copy text:", err)
      // Fallback for older browsers
      this.fallbackCopy(text)
    })
  }

  showSuccess() {
    if (!this.hasButtonTarget) return

    const originalText = this.buttonTarget.textContent
    this.buttonTarget.textContent = this.successTextValue

    setTimeout(() => {
      this.buttonTarget.textContent = originalText
    }, this.successDurationValue)
  }

  fallbackCopy(text) {
    const textArea = document.createElement("textarea")
    textArea.value = text
    textArea.style.position = "fixed"
    textArea.style.left = "-9999px"
    document.body.appendChild(textArea)
    textArea.select()

    try {
      document.execCommand("copy")
      this.showSuccess()
    } catch (err) {
      console.error("Fallback copy failed:", err)
    }

    document.body.removeChild(textArea)
  }
}
