import { Controller } from "@hotwired/stimulus"

/**
 * Stimulus controller for the Input OTP component
 * Handles multi-slot OTP input with keyboard navigation
 */
export default class extends Controller {
  static targets = ["slot", "input", "hiddenInput", "caret"]
  static values = {
    length: { type: Number, default: 6 },
    pattern: { type: String, default: "" },
    disabled: { type: Boolean, default: false }
  }

  connect() {
    this.updateHiddenInput()
    this.updateCarets()
  }

  handleInput(event) {
    const input = event.target
    const index = parseInt(input.dataset.index)
    let value = input.value

    // Apply pattern validation if set
    if (this.patternValue) {
      const regex = new RegExp(this.patternValue)
      if (!regex.test(value)) {
        input.value = ""
        return
      }
    }

    // Only keep last character if multiple entered
    if (value.length > 1) {
      value = value.slice(-1)
      input.value = value
    }

    this.updateHiddenInput()
    this.updateCarets()

    // Auto-advance to next slot
    if (value && index < this.lengthValue - 1) {
      this.focusInput(index + 1)
    }
  }

  handleKeydown(event) {
    const input = event.target
    const index = parseInt(input.dataset.index)

    switch (event.key) {
      case "Backspace":
        if (!input.value && index > 0) {
          // Move to previous slot and clear it
          event.preventDefault()
          this.focusInput(index - 1)
          this.inputTargets[index - 1].value = ""
          this.updateHiddenInput()
          this.updateCarets()
        }
        break

      case "ArrowLeft":
        if (index > 0) {
          event.preventDefault()
          this.focusInput(index - 1)
        }
        break

      case "ArrowRight":
        if (index < this.lengthValue - 1) {
          event.preventDefault()
          this.focusInput(index + 1)
        }
        break

      case "Delete":
        input.value = ""
        this.updateHiddenInput()
        this.updateCarets()
        break
    }
  }

  handleFocus(event) {
    const input = event.target
    const slot = input.closest("[data-shadcn--input-otp-target='slot']")
    if (slot) {
      slot.classList.add("z-10", "ring-1", "ring-ring")
    }
    this.updateCarets()
  }

  handleBlur(event) {
    const input = event.target
    const slot = input.closest("[data-shadcn--input-otp-target='slot']")
    if (slot) {
      slot.classList.remove("z-10", "ring-1", "ring-ring")
    }
    this.updateCarets()
  }

  handlePaste(event) {
    event.preventDefault()
    const pastedData = event.clipboardData.getData("text")

    // Apply pattern validation if set
    let chars = pastedData.split("")
    if (this.patternValue) {
      const regex = new RegExp(this.patternValue)
      chars = chars.filter(char => regex.test(char))
    }

    // Fill slots starting from current position
    const startIndex = parseInt(event.target.dataset.index)
    chars.slice(0, this.lengthValue - startIndex).forEach((char, i) => {
      const input = this.inputTargets[startIndex + i]
      if (input) {
        input.value = char
      }
    })

    this.updateHiddenInput()
    this.updateCarets()

    // Focus appropriate slot after paste
    const nextEmptyIndex = this.findNextEmptySlot(startIndex)
    if (nextEmptyIndex !== -1) {
      this.focusInput(nextEmptyIndex)
    } else {
      this.focusInput(Math.min(startIndex + chars.length, this.lengthValue - 1))
    }
  }

  focusSlot(event) {
    const slot = event.currentTarget
    const index = parseInt(slot.dataset.index)
    this.focusInput(index)
  }

  focusInput(index) {
    const input = this.inputTargets[index]
    if (input && !this.disabledValue) {
      input.focus()
      input.select()
    }
  }

  findNextEmptySlot(startIndex) {
    for (let i = startIndex; i < this.lengthValue; i++) {
      if (!this.inputTargets[i]?.value) {
        return i
      }
    }
    return -1
  }

  updateHiddenInput() {
    if (!this.hasHiddenInputTarget) return

    const value = this.inputTargets.map(input => input.value || "").join("")
    this.hiddenInputTarget.value = value
  }

  updateCarets() {
    // Hide all carets
    this.caretTargets.forEach(caret => {
      caret.classList.add("hidden")
    })

    // Show caret in focused empty slot
    const activeInput = this.inputTargets.find(input =>
      document.activeElement === input && !input.value
    )

    if (activeInput) {
      const index = parseInt(activeInput.dataset.index)
      const caret = this.caretTargets[index]
      if (caret) {
        caret.classList.remove("hidden")
      }
    }
  }

  // Get the complete OTP value
  get value() {
    return this.inputTargets.map(input => input.value || "").join("")
  }

  // Check if OTP is complete
  get isComplete() {
    return this.value.length === this.lengthValue
  }

  // Clear all inputs
  clear() {
    this.inputTargets.forEach(input => {
      input.value = ""
    })
    this.updateHiddenInput()
    this.updateCarets()
    this.focusInput(0)
  }
}
