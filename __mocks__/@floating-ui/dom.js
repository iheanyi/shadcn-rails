/**
 * Mock for @floating-ui/dom
 * Used in tests since JSDOM doesn't properly support the DOM APIs Floating UI needs
 */

// Store references for size middleware to apply
let _computeRef = null
let _computeFloating = null

export const computePosition = async (reference, floating, options = {}) => {
  _computeRef = reference
  _computeFloating = floating

  // Call size middleware apply if present
  if (options.middleware) {
    for (const mw of options.middleware) {
      if (mw.name === 'size' && mw.applyFn) {
        mw.applyFn({
          availableWidth: 400,
          availableHeight: 300,
          elements: { floating },
          rects: {
            reference: {
              width: reference?.getBoundingClientRect?.()?.width || 100,
              height: reference?.getBoundingClientRect?.()?.height || 40
            }
          }
        })
      }
    }
  }

  return {
    x: 100,
    y: 140,
    placement: options.placement || 'bottom-start',
    middlewareData: {}
  }
}

export const autoUpdate = (reference, floating, update) => {
  // Call update once immediately
  update()
  // Return cleanup function
  return () => {}
}

export const flip = (options = {}) => ({
  name: 'flip',
  options
})

export const shift = (options = {}) => ({
  name: 'shift',
  options
})

export const offset = (value = 0) => ({
  name: 'offset',
  options: { mainAxis: value }
})

export const size = (options = {}) => ({
  name: 'size',
  options,
  applyFn: options.apply
})
