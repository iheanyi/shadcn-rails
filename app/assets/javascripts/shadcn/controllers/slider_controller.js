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
 */
export default class extends Controller {
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
  }

  startDrag(event) {
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

  handleDrag(event) {
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

  handleKeydown(event) {
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

  snapToStep(value) {
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
    this.element.setAttribute("aria-valuenow", this.valueValue)

    // Update hidden input
    if (this.hasInputTarget) {
      this.inputTarget.value = this.valueValue
    }

    // Update output element if present (for syncing value labels)
    if (this.hasOutputTarget) {
      this.updateOutput()
    }
  }

  updateOutput() {
    const formattedValue = this.outputFormatValue
      .replace("{value}", this.valueValue)
      .replace("{percent}", Math.round(this.percentage))

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
  updateStyle(event) {
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
          .replace("{value}", value)
          .replace("{percent}", Math.round(percentage))
        outputElement.textContent = formattedValue
      }
    }

    // Dispatch change event
    this.dispatch("change", {
      detail: { value: value, percentage: percentage }
    })
  }
}
