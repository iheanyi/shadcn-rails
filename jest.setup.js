import '@testing-library/jest-dom'

// Make jest globals available in ESM modules
import { jest } from '@jest/globals'
globalThis.jest = jest
