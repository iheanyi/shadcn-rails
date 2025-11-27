import '@testing-library/jest-dom'

// Make jest globals available in ESM modules
import { jest } from '@jest/globals'
globalThis.jest = jest

// Mock scrollIntoView since JSDOM doesn't implement it
Element.prototype.scrollIntoView = jest.fn()

// Mock getBoundingClientRect to return proper values for Floating UI
const originalGetBoundingClientRect = Element.prototype.getBoundingClientRect
Element.prototype.getBoundingClientRect = function() {
  // Return reasonable default values for testing
  return {
    width: 100,
    height: 40,
    top: 100,
    left: 100,
    bottom: 140,
    right: 200,
    x: 100,
    y: 100,
    toJSON: () => ({})
  }
}
