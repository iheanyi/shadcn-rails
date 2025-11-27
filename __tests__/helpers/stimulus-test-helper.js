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
