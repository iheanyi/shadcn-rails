import '@testing-library/jest-dom'

// Make jest globals available in ESM modules
import { jest } from '@jest/globals'
globalThis.jest = jest

// Mock scrollIntoView since JSDOM doesn't implement it
Element.prototype.scrollIntoView = jest.fn()
