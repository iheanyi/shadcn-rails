import { computePosition, autoUpdate, flip, shift, offset, size } from "@floating-ui/dom"

/**
 * Floating UI positioning utility for shadcn-rails components
 *
 * Provides smart positioning for dropdowns, popovers, tooltips, etc.
 * that automatically handles:
 * - Viewport edge detection (flip to opposite side)
 * - Sliding along axis to stay in view (shift)
 * - Consistent spacing (offset)
 * - Dynamic content sizing
 */

/**
 * Default middleware configuration
 */
const defaultMiddleware = [
  offset(4),
  flip({
    fallbackAxisSideDirection: "start",
    crossAxis: false
  }),
  shift({ padding: 8 })
]

/**
 * Middleware that includes size constraints for dropdowns/selects
 */
const sizeMiddleware = (options = {}) => size({
  apply({ availableWidth, availableHeight, elements }) {
    Object.assign(elements.floating.style, {
      maxWidth: `${Math.max(0, availableWidth)}px`,
      maxHeight: options.maxHeight ? `${Math.min(options.maxHeight, availableHeight)}px` : `${Math.max(0, availableHeight - 10)}px`
    })
  },
  padding: 10
})

/**
 * Position a floating element relative to a reference element
 *
 * @param {HTMLElement} reference - The trigger/reference element
 * @param {HTMLElement} floating - The floating content element
 * @param {Object} options - Positioning options
 * @param {string} options.placement - Placement (top, bottom, left, right, with -start/-end variants)
 * @param {number} options.offset - Offset distance in pixels (default: 4)
 * @param {boolean} options.sameWidth - Make floating element same width as reference
 * @param {number} options.maxHeight - Maximum height for the floating element
 * @param {Function} options.onPositioned - Callback after positioning
 * @returns {Function} Cleanup function to stop auto-updates
 */
export function positionFloating(reference, floating, options = {}) {
  const {
    placement = "bottom-start",
    offset: offsetValue = 4,
    sameWidth = false,
    maxHeight = null,
    onPositioned = null
  } = options

  // Build middleware array
  const middleware = [
    offset(offsetValue),
    flip({
      fallbackAxisSideDirection: "start",
      crossAxis: false
    }),
    shift({ padding: 8 })
  ]

  // Add size middleware if needed
  if (maxHeight || sameWidth) {
    middleware.push(size({
      apply({ availableWidth, availableHeight, elements, rects }) {
        const styles = {}

        if (sameWidth) {
          styles.width = `${rects.reference.width}px`
          styles.minWidth = `${rects.reference.width}px`
        }

        if (maxHeight) {
          styles.maxHeight = `${Math.min(maxHeight, availableHeight - 10)}px`
        } else {
          styles.maxHeight = `${Math.max(0, availableHeight - 10)}px`
        }

        Object.assign(elements.floating.style, styles)
      },
      padding: 10
    }))
  }

  // Set up auto-updating position
  const cleanup = autoUpdate(reference, floating, () => {
    computePosition(reference, floating, {
      placement,
      middleware
    }).then(({ x, y, placement: finalPlacement }) => {
      // Apply position
      Object.assign(floating.style, {
        position: "absolute",
        left: `${x}px`,
        top: `${y}px`
      })

      // Update data-side attribute for animations
      const side = finalPlacement.split("-")[0]
      floating.dataset.side = side

      // Call callback if provided
      if (onPositioned) {
        onPositioned({ x, y, placement: finalPlacement })
      }
    })
  })

  return cleanup
}

/**
 * Position a context menu at specific coordinates
 *
 * @param {HTMLElement} floating - The floating content element
 * @param {number} x - X coordinate (clientX from event)
 * @param {number} y - Y coordinate (clientY from event)
 * @param {Object} options - Positioning options
 * @returns {void}
 */
export function positionAtPoint(floating, x, y, options = {}) {
  const { maxHeight = null } = options

  // Create a virtual reference element at the click point
  const virtualRef = {
    getBoundingClientRect() {
      return {
        width: 0,
        height: 0,
        x,
        y,
        top: y,
        left: x,
        right: x,
        bottom: y
      }
    }
  }

  const middleware = [
    offset(4),
    flip(),
    shift({ padding: 8 })
  ]

  if (maxHeight) {
    middleware.push(size({
      apply({ availableHeight, elements }) {
        elements.floating.style.maxHeight = `${Math.min(maxHeight, availableHeight - 10)}px`
      },
      padding: 10
    }))
  }

  computePosition(virtualRef, floating, {
    placement: "bottom-start",
    middleware
  }).then(({ x: posX, y: posY, placement }) => {
    Object.assign(floating.style, {
      position: "fixed",
      left: `${posX}px`,
      top: `${posY}px`
    })

    const side = placement.split("-")[0]
    floating.dataset.side = side
  })
}

export { computePosition, autoUpdate, flip, shift, offset, size }
