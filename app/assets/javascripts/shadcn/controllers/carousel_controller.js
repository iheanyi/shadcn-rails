import { Controller } from "@hotwired/stimulus"

/**
 * Carousel controller for sliding content
 * Handles navigation, autoplay, keyboard navigation, and touch/swipe
 */
export default class extends Controller {
  static targets = ["viewport", "content", "item", "prevButton", "nextButton"]
  static values = {
    orientation: { type: String, default: "horizontal" },
    loop: { type: Boolean, default: false },
    autoplay: { type: Boolean, default: false },
    autoplayInterval: { type: Number, default: 4000 },
    align: { type: String, default: "start" },
    selectedIndex: { type: Number, default: 0 }
  }

  connect() {
    this.boundHandleKeydown = this.handleKeydown.bind(this)
    this.element.addEventListener("keydown", this.boundHandleKeydown)

    // Touch/swipe support
    this.touchStartX = 0
    this.touchStartY = 0
    this.boundHandleTouchStart = this.handleTouchStart.bind(this)
    this.boundHandleTouchEnd = this.handleTouchEnd.bind(this)

    if (this.hasViewportTarget) {
      this.viewportTarget.addEventListener("touchstart", this.boundHandleTouchStart, { passive: true })
      this.viewportTarget.addEventListener("touchend", this.boundHandleTouchEnd, { passive: true })
    }

    // Set initial state
    this.updateButtonStates()
    this.scrollToIndex(this.selectedIndexValue, false)

    // Start autoplay if enabled
    if (this.autoplayValue) {
      this.startAutoplay()
    }
  }

  disconnect() {
    this.element.removeEventListener("keydown", this.boundHandleKeydown)

    if (this.hasViewportTarget) {
      this.viewportTarget.removeEventListener("touchstart", this.boundHandleTouchStart)
      this.viewportTarget.removeEventListener("touchend", this.boundHandleTouchEnd)
    }

    this.stopAutoplay()
  }

  previous() {
    const newIndex = this.selectedIndexValue - 1

    if (newIndex < 0) {
      if (this.loopValue) {
        this.selectedIndexValue = this.itemTargets.length - 1
      }
    } else {
      this.selectedIndexValue = newIndex
    }

    this.scrollToIndex(this.selectedIndexValue)
    this.dispatch("select", { detail: { index: this.selectedIndexValue } })
  }

  next() {
    const newIndex = this.selectedIndexValue + 1
    const maxIndex = this.itemTargets.length - 1

    if (newIndex > maxIndex) {
      if (this.loopValue) {
        this.selectedIndexValue = 0
      }
    } else {
      this.selectedIndexValue = newIndex
    }

    this.scrollToIndex(this.selectedIndexValue)
    this.dispatch("select", { detail: { index: this.selectedIndexValue } })
  }

  goToSlide(event) {
    const index = parseInt(event.currentTarget.dataset.index, 10)
    if (!isNaN(index) && index >= 0 && index < this.itemTargets.length) {
      this.selectedIndexValue = index
      this.scrollToIndex(index)
      this.dispatch("select", { detail: { index } })
    }
  }

  scrollToIndex(index, animate = true) {
    if (!this.hasContentTarget || !this.itemTargets.length) return

    const item = this.itemTargets[index]
    if (!item) return

    const isHorizontal = this.orientationValue === "horizontal"

    // Calculate scroll position
    let scrollPosition
    if (isHorizontal) {
      scrollPosition = item.offsetLeft - this.getAlignOffset(item, "width")
    } else {
      scrollPosition = item.offsetTop - this.getAlignOffset(item, "height")
    }

    // Apply scroll
    if (animate) {
      this.contentTarget.style.transition = "transform 0.3s ease-out"
    } else {
      this.contentTarget.style.transition = "none"
    }

    if (isHorizontal) {
      this.contentTarget.style.transform = `translateX(-${scrollPosition}px)`
    } else {
      this.contentTarget.style.transform = `translateY(-${scrollPosition}px)`
    }

    // Update ARIA attributes
    this.itemTargets.forEach((target, i) => {
      target.setAttribute("aria-hidden", i !== index)
      target.inert = i !== index
    })

    this.updateButtonStates()
  }

  getAlignOffset(item, dimension) {
    if (this.alignValue === "center") {
      const viewportSize = dimension === "width"
        ? this.viewportTarget.offsetWidth
        : this.viewportTarget.offsetHeight
      const itemSize = dimension === "width"
        ? item.offsetWidth
        : item.offsetHeight
      return (viewportSize - itemSize) / 2
    } else if (this.alignValue === "end") {
      const viewportSize = dimension === "width"
        ? this.viewportTarget.offsetWidth
        : this.viewportTarget.offsetHeight
      const itemSize = dimension === "width"
        ? item.offsetWidth
        : item.offsetHeight
      return viewportSize - itemSize
    }
    return 0 // start alignment
  }

  updateButtonStates() {
    const atStart = this.selectedIndexValue === 0
    const atEnd = this.selectedIndexValue === this.itemTargets.length - 1

    if (this.hasPrevButtonTarget) {
      this.prevButtonTarget.disabled = !this.loopValue && atStart
    }

    if (this.hasNextButtonTarget) {
      this.nextButtonTarget.disabled = !this.loopValue && atEnd
    }
  }

  handleKeydown(event) {
    const isHorizontal = this.orientationValue === "horizontal"

    if (isHorizontal) {
      if (event.key === "ArrowLeft") {
        event.preventDefault()
        this.previous()
      } else if (event.key === "ArrowRight") {
        event.preventDefault()
        this.next()
      }
    } else {
      if (event.key === "ArrowUp") {
        event.preventDefault()
        this.previous()
      } else if (event.key === "ArrowDown") {
        event.preventDefault()
        this.next()
      }
    }
  }

  handleTouchStart(event) {
    this.touchStartX = event.touches[0].clientX
    this.touchStartY = event.touches[0].clientY

    // Pause autoplay on interaction
    if (this.autoplayValue) {
      this.stopAutoplay()
    }
  }

  handleTouchEnd(event) {
    const touchEndX = event.changedTouches[0].clientX
    const touchEndY = event.changedTouches[0].clientY

    const deltaX = touchEndX - this.touchStartX
    const deltaY = touchEndY - this.touchStartY

    const isHorizontal = this.orientationValue === "horizontal"
    const threshold = 50

    if (isHorizontal) {
      if (Math.abs(deltaX) > threshold && Math.abs(deltaX) > Math.abs(deltaY)) {
        if (deltaX > 0) {
          this.previous()
        } else {
          this.next()
        }
      }
    } else {
      if (Math.abs(deltaY) > threshold && Math.abs(deltaY) > Math.abs(deltaX)) {
        if (deltaY > 0) {
          this.previous()
        } else {
          this.next()
        }
      }
    }

    // Resume autoplay after interaction
    if (this.autoplayValue) {
      this.startAutoplay()
    }
  }

  startAutoplay() {
    this.stopAutoplay()
    this.autoplayTimer = setInterval(() => {
      this.next()
    }, this.autoplayIntervalValue)
  }

  stopAutoplay() {
    if (this.autoplayTimer) {
      clearInterval(this.autoplayTimer)
      this.autoplayTimer = null
    }
  }

  // Pause autoplay when mouse enters
  mouseEnter() {
    if (this.autoplayValue) {
      this.stopAutoplay()
    }
  }

  // Resume autoplay when mouse leaves
  mouseLeave() {
    if (this.autoplayValue) {
      this.startAutoplay()
    }
  }

  selectedIndexValueChanged() {
    this.scrollToIndex(this.selectedIndexValue)
  }
}
