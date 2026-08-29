/** @type {import('jest').Config} */
export default {
  testEnvironment: 'jsdom',
  testMatch: ['**/__tests__/**/*.test.js'],
  extensionsToTreatAsEsm: ['.ts'],
  moduleFileExtensions: ['ts', 'js', 'json'],
  transform: {
    '^.+\\.[jt]s$': 'babel-jest'
  },
  transformIgnorePatterns: [
    '/node_modules/(?!@hotwired/stimulus|stimulus-use|@floating-ui)'
  ],
  moduleNameMapper: {
    '^@floating-ui/dom$': '<rootDir>/__mocks__/@floating-ui/dom.js',
    '^stimulus-use$': '<rootDir>/__mocks__/stimulus-use.js'
  },
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  collectCoverageFrom: [
    'app/assets/javascripts/shadcn/controllers/**/*.ts',
    '!**/node_modules/**'
  ],
  coverageDirectory: 'coverage',
  verbose: true
}
