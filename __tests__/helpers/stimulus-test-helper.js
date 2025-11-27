import { Application } from "@hotwired/stimulus"

/**
 * Helper to set up Stimulus controller tests
 * Creates a DOM element with the controller connected
 */
export function setupController(Controller, html, controllerName = 'test') {
  const application = Application.start()
  application.register(controllerName, Controller)

  document.body.innerHTML = html

  // Wait for Stimulus to connect the controller
  return new Promise((resolve) => {
    requestAnimationFrame(() => {
      const element = document.querySelector(`[data-controller="${controllerName}"]`)
      const controller = application.getControllerForElementAndIdentifier(element, controllerName)
      resolve({ application, element, controller })
    })
  })
}

/**
 * Clean up after tests
 */
export function cleanupController(application) {
  if (application) {
    application.stop()
  }
  document.body.innerHTML = ''
}

/**
 * Simulate a click event on an element
 */
export function click(element) {
  element.dispatchEvent(new MouseEvent('click', {
    bubbles: true,
    cancelable: true,
    view: window
  }))
}

/**
 * Wait for a specified number of milliseconds
 */
export function wait(ms) {
  return new Promise(resolve => setTimeout(resolve, ms))
}

/**
 * Wait for an animation frame
 */
export function nextFrame() {
  return new Promise(resolve => requestAnimationFrame(resolve))
}

/**
 * Simulate a keyboard event on an element
 * @param {Element} element - Target element
 * @param {string} key - Key name (e.g., 'ArrowDown', 'Enter', 'Escape')
 * @param {Object} options - Additional options (shiftKey, ctrlKey, etc.)
 */
export function keydown(element, key, options = {}) {
  element.dispatchEvent(new KeyboardEvent('keydown', {
    key,
    bubbles: true,
    cancelable: true,
    ...options
  }))
}

/**
 * Simulate a keyup event
 */
export function keyup(element, key, options = {}) {
  element.dispatchEvent(new KeyboardEvent('keyup', {
    key,
    bubbles: true,
    cancelable: true,
    ...options
  }))
}

/**
 * Wait for a portal element to appear in the DOM
 * @param {string} selector - CSS selector for the portal
 * @param {boolean} shouldExist - Whether portal should exist (true) or not exist (false)
 * @param {number} timeout - Maximum wait time in ms
 */
export async function waitForPortal(selector, shouldExist = true, timeout = 1000) {
  const startTime = Date.now()

  while (Date.now() - startTime < timeout) {
    const element = document.querySelector(selector)
    if (shouldExist && element) return element
    if (!shouldExist && !element) return null
    await wait(10)
  }

  throw new Error(`Portal ${selector} ${shouldExist ? 'did not appear' : 'did not disappear'} within ${timeout}ms`)
}

/**
 * Mock window.location for URL-related tests
 * @param {string} url - The URL to mock
 * @returns {Function} Cleanup function to restore original location
 */
export function mockLocation(url) {
  const originalLocation = window.location
  delete window.location
  window.location = new URL(url)

  // Add commonly needed properties
  window.location.assign = jest.fn()
  window.location.replace = jest.fn()
  window.location.reload = jest.fn()

  return () => {
    window.location = originalLocation
  }
}

/**
 * Mock history.pushState and replaceState for URL sync tests
 */
export function mockHistory() {
  const originalPushState = window.history.pushState
  const originalReplaceState = window.history.replaceState

  const calls = {
    pushState: [],
    replaceState: []
  }

  window.history.pushState = jest.fn((state, title, url) => {
    calls.pushState.push({ state, title, url })
  })

  window.history.replaceState = jest.fn((state, title, url) => {
    calls.replaceState.push({ state, title, url })
  })

  return {
    calls,
    restore: () => {
      window.history.pushState = originalPushState
      window.history.replaceState = originalReplaceState
    }
  }
}

/**
 * Get all focusable elements within a container
 * @param {Element} container - Container element
 */
export function getFocusableElements(container) {
  return container.querySelectorAll(
    'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
  )
}

/**
 * Dispatch a custom event
 * @param {Element} element - Target element
 * @param {string} eventName - Event name
 * @param {Object} detail - Event detail object
 */
export function dispatchEvent(element, eventName, detail = {}) {
  element.dispatchEvent(new CustomEvent(eventName, {
    bubbles: true,
    cancelable: true,
    detail
  }))
}

/**
 * Wait for controller to emit a specific event
 * @param {Element} element - Element to listen on
 * @param {string} eventName - Event name (e.g., 'shadcn--accordion:expand')
 * @param {number} timeout - Maximum wait time
 */
export function waitForEvent(element, eventName, timeout = 1000) {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => {
      reject(new Error(`Event ${eventName} not received within ${timeout}ms`))
    }, timeout)

    element.addEventListener(eventName, (event) => {
      clearTimeout(timer)
      resolve(event)
    }, { once: true })
  })
}
