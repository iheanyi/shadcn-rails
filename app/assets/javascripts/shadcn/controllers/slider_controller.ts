import { Controller } from "@hotwired/stimulus"

/**
 * Slider Controller
 *
 * Handles slider value selection with drag and keyboard support
 *
 * Targets:
 * - track: The slider track
 * - range: The filled range portion
 * - thumb: The draggable thumb
 * - input: Hidden input for form submission
 * - output: Optional element to display the current value (auto-synced)
 *
 * Values:
 * - min: Minimum value
 * - max: Maximum value
 * - step: Step increment
 * - value: Current value
 * - name: Input name
 * - disabled: Whether slider is disabled
 * - outputFormat: Format string for output (use {value} for value, {percent} for percentage)
 *
 * Data attributes for native <input type="range">:
 * - data-output-target: ID of element to display value (one-way: slider → output)
 * - data-output-format: Format string with {value} and {percent} placeholders
 * - data-input-target: ID of input element for two-way binding (slider ↔ input)
 */
export default class extends Controller<HTMLElement> {
  static targets = ["track", "range", "thumb", "input", "output"]
  static values = {
    min: { type: Number, default: 0 },
    max: { type: Number, default: 100 },
    step: { type: Number, default: 1 },
    value: { type: Number, default: 0 },
    name: String,
    disabled: { type: Boolean, default: false },
    outputFormat: { type: String, default: "{value}" }
  }

  connect() {
    this.isDragging = false
    this.updateVisuals()
    this.setupTwoWayBindings()
  }

  disconnect() {
    this.teardownTwoWayBindings()
  }

  /**
   * Set up two-way bindings for native range inputs with data-input-target
   */
  setupTwoWayBindings() {
    this.inputBindings = []

    // Check if the controller element itself is a range input with data-input-target
    // (This is the case when data-controller is on the input element directly)
    if (this.element instanceof HTMLInputElement &&
        this.element.matches &&
        this.element.matches('input[type="range"][data-input-target]')) {
      this.setupBindingForInput(this.element)
      return
    }

    // Otherwise, find all native range inputs with data-input-target attribute within the element
    const rangeInputs = this.element.querySelectorAll<HTMLInputElement>('input[type="range"][data-input-target]')
    rangeInputs.forEach(rangeInput => {
      this.setupBindingForInput(rangeInput)
    })
  }

  /**
   * Set up two-way binding for a single range input
   * @param {HTMLInputElement} rangeInput - The range input element
   */
  setupBindingForInput(rangeInput: HTMLInputElement) {
    const inputTargetId = rangeInput.dataset.inputTarget
    if (!inputTargetId) return

    const linkedInput = document.getElementById(inputTargetId)

    if (linkedInput instanceof HTMLInputElement) {
      // Create bound handler for this specific pair
      const handler = this.handleLinkedInputChange.bind(this, rangeInput)

      // Store binding info for cleanup
      this.inputBindings.push({
        rangeInput,
        linkedInput,
        handler
      })

      // Listen for changes on the linked input
      linkedInput.addEventListener('input', handler)
      linkedInput.addEventListener('change', handler)
    }
  }

  /**
   * Clean up event listeners when disconnecting
   */
  teardownTwoWayBindings() {
    if (this.inputBindings) {
      this.inputBindings.forEach(({ linkedInput, handler }: { linkedInput: HTMLInputElement, handler: (event: Event) => void }) => {
        linkedInput.removeEventListener('input', handler)
        linkedInput.removeEventListener('change', handler)
      })
      this.inputBindings = []
    }
  }

  /**
   * Handle changes from a linked input element (input → slider sync)
   * @param {HTMLInputElement} rangeInput - The range input to update
   * @param {Event} event - The input/change event from the linked input
   */
  handleLinkedInputChange(rangeInput: HTMLInputElement, event: Event) {
    if (!(event.target instanceof HTMLInputElement)) return
    const linkedInput = event.target
    let value = parseFloat(linkedInput.value)

    // Validate and clamp the value
    const min = parseFloat(rangeInput.min) || 0
    const max = parseFloat(rangeInput.max) || 100
    const step = parseFloat(rangeInput.step) || 1

    // Handle invalid input
    if (isNaN(value)) {
      value = min
    }

    // Clamp to min/max
    value = Math.max(min, Math.min(max, value))

    // Snap to step
    const steps = Math.round((value - min) / step)
    value = min + steps * step

    // Update range input
    rangeInput.value = String(value)

    // Update CSS custom property for fill
    const percentage = ((value - min) / (max - min)) * 100
    rangeInput.style.setProperty("--slider-fill", `${percentage}%`)

    // Update the linked input if value was clamped/snapped
    if (parseFloat(linkedInput.value) !== value) {
      linkedInput.value = String(value)
    }

    // Also update output if present
    const outputTargetId = rangeInput.dataset.outputTarget
    if (outputTargetId) {
      const outputElement = document.getElementById(outputTargetId)
      if (outputElement) {
        const format = rangeInput.dataset.outputFormat || "{value}"
        const formattedValue = format
          .replace("{value}", String(value))
          .replace("{percent}", String(Math.round(percentage)))
        outputElement.textContent = formattedValue
      }
    }

    // Dispatch change event
    this.dispatch("change", {
      detail: { value: value, percentage: percentage }
    })
  }

  startDrag(event: ShadcnEvent) {
    if (this.disabledValue) return

    event.preventDefault()
    this.isDragging = true

    // Handle both mouse and touch events
    const moveEvent = event.type === "touchstart" ? "touchmove" : "mousemove"
    const endEvent = event.type === "touchstart" ? "touchend" : "mouseup"

    this.handleDrag(event)

    this.boundHandleDrag = this.handleDrag.bind(this)
    this.boundStopDrag = this.stopDrag.bind(this)

    document.addEventListener(moveEvent, this.boundHandleDrag)
    document.addEventListener(endEvent, this.boundStopDrag)
  }

  handleDrag(event: ShadcnEvent) {
    if (!this.isDragging && event.type !== "mousedown" && event.type !== "touchstart") return

    const track = this.trackTarget
    const rect = track.getBoundingClientRect()

    // Get clientX from either mouse or touch event
    const clientX = event.type.includes("touch")
      ? event.touches[0].clientX
      : event.clientX

    const percentage = Math.max(0, Math.min(1, (clientX - rect.left) / rect.width))
    const rawValue = this.minValue + percentage * (this.maxValue - this.minValue)
    const steppedValue = this.snapToStep(rawValue)

    this.valueValue = steppedValue
    this.updateVisuals()
    this.dispatchChange()
  }

  stopDrag() {
    this.isDragging = false
    document.removeEventListener("mousemove", this.boundHandleDrag)
    document.removeEventListener("mouseup", this.boundStopDrag)
    document.removeEventListener("touchmove", this.boundHandleDrag)
    document.removeEventListener("touchend", this.boundStopDrag)
  }

  handleKeydown(event: ShadcnEvent) {
    if (this.disabledValue) return

    let newValue = this.valueValue
    const bigStep = (this.maxValue - this.minValue) / 10

    switch (event.key) {
      case "ArrowRight":
      case "ArrowUp":
        event.preventDefault()
        newValue = Math.min(this.maxValue, this.valueValue + this.stepValue)
        break
      case "ArrowLeft":
      case "ArrowDown":
        event.preventDefault()
        newValue = Math.max(this.minValue, this.valueValue - this.stepValue)
        break
      case "PageUp":
        event.preventDefault()
        newValue = Math.min(this.maxValue, this.valueValue + bigStep)
        break
      case "PageDown":
        event.preventDefault()
        newValue = Math.max(this.minValue, this.valueValue - bigStep)
        break
      case "Home":
        event.preventDefault()
        newValue = this.minValue
        break
      case "End":
        event.preventDefault()
        newValue = this.maxValue
        break
      default:
        return
    }

    this.valueValue = this.snapToStep(newValue)
    this.updateVisuals()
    this.dispatchChange()
  }

  snapToStep(value: number) {
    const steps = Math.round((value - this.minValue) / this.stepValue)
    return Math.max(this.minValue, Math.min(this.maxValue, this.minValue + steps * this.stepValue))
  }

  updateVisuals() {
    const percentage = this.percentage

    if (this.hasRangeTarget) {
      this.rangeTarget.style.width = `${percentage}%`
    }

    if (this.hasThumbTarget) {
      this.thumbTarget.style.left = `calc(${percentage}% - 8px)`
    }

    // Update ARIA attributes
    this.element.setAttribute("aria-valuenow", String(this.valueValue))

    // Update hidden input
    if (this.hasInputTarget) {
      this.inputTarget.value = String(this.valueValue)
    }

    // Update output element if present (for syncing value labels)
    if (this.hasOutputTarget) {
      this.updateOutput()
    }
  }

  updateOutput() {
    const formattedValue = this.outputFormatValue
      .replace("{value}", String(this.valueValue))
      .replace("{percent}", String(Math.round(this.percentage)))

    this.outputTarget.textContent = formattedValue
  }

  dispatchChange() {
    this.dispatch("change", {
      detail: { value: this.valueValue, name: this.nameValue }
    })

    // Dispatch native input event for form compatibility
    if (this.hasInputTarget) {
      this.inputTarget.dispatchEvent(new Event("input", { bubbles: true }))
    }
  }

  get percentage() {
    if (this.maxValue === this.minValue) return 0
    return ((this.valueValue - this.minValue) / (this.maxValue - this.minValue)) * 100
  }

  valueValueChanged() {
    this.updateVisuals()
  }

  /**
   * Update style for native input range element
   * Called on input event from native <input type="range">
   * Updates CSS custom property for fill and syncs output element
   */
  updateStyle(event: ShadcnEvent) {
    const input = event.target
    const value = parseFloat(input.value)
    const min = parseFloat(input.min) || 0
    const max = parseFloat(input.max) || 100

    // Calculate percentage and update CSS custom property
    const percentage = ((value - min) / (max - min)) * 100
    input.style.setProperty("--slider-fill", `${percentage}%`)

    // Update value for output sync
    this.valueValue = value

    // Update output if present (Stimulus target)
    if (this.hasOutputTarget) {
      this.updateOutput()
    }

    // Also check for data-output-target attribute (ID-based targeting)
    const outputTargetId = input.dataset.outputTarget
    if (outputTargetId) {
      const outputElement = document.getElementById(outputTargetId)
      if (outputElement) {
        const format = input.dataset.outputFormat || "{value}"
        const formattedValue = format
          .replace("{value}", String(value))
          .replace("{percent}", String(Math.round(percentage)))
        outputElement.textContent = formattedValue
      }
    }

    // Sync to linked input element for two-way binding (slider → input)
    const inputTargetId = input.dataset.inputTarget
    if (inputTargetId) {
      const linkedInput = document.getElementById(inputTargetId)
      if (linkedInput) {
        linkedInput.value = String(value)
      }
    }

    // Dispatch change event
    this.dispatch("change", {
      detail: { value: value, percentage: percentage }
    })
  }
}
