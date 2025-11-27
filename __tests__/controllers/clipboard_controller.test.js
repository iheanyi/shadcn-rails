import { Application } from "@hotwired/stimulus"
import ClipboardController from "../../test/dummy/app/javascript/controllers/clipboard_controller.js"
import { setupController, cleanupController, click, nextFrame, wait } from '../helpers/stimulus-test-helper.js'

describe("ClipboardController", () => {
  let application
  let element
  let controller

  // Mock the clipboard API
  const mockClipboard = {
    writeText: jest.fn()
  }

  beforeAll(() => {
    Object.defineProperty(navigator, 'clipboard', {
      value: mockClipboard,
      writable: true,
      configurable: true
    })
  })

  beforeEach(() => {
    mockClipboard.writeText.mockReset()
    mockClipboard.writeText.mockResolvedValue(undefined)
  })

  afterEach(() => {
    cleanupController(application)
  })

  describe("basic functionality", () => {
    const basicHTML = `
      <div data-controller="clipboard">
        <pre data-clipboard-target="source"><code>rails generate shadcn:add button</code></pre>
        <button data-action="click->clipboard#copy" data-clipboard-target="button">Copy</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ClipboardController, basicHTML, 'clipboard')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes correctly", () => {
      expect(controller).toBeDefined()
      expect(controller.hasSourceTarget).toBe(true)
      expect(controller.hasButtonTarget).toBe(true)
    })

    test("copies text to clipboard on click", async () => {
      controller.copy()
      await nextFrame()

      expect(mockClipboard.writeText).toHaveBeenCalledWith("rails generate shadcn:add button")
    })

    test("changes button text to 'Copied!' after copying", async () => {
      controller.copy()
      await nextFrame()

      expect(controller.buttonTarget.textContent).toBe("Copied!")
    })

    test("reverts button text after successDuration", async () => {
      // Use a shorter duration for testing
      controller.successDurationValue = 100
      controller.copy()
      await nextFrame()

      expect(controller.buttonTarget.textContent).toBe("Copied!")

      await wait(150)
      expect(controller.buttonTarget.textContent).toBe("Copy")
    })
  })

  describe("custom success text", () => {
    const customTextHTML = `
      <div data-controller="clipboard"
           data-clipboard-success-text-value="Done!"
           data-clipboard-success-duration-value="100">
        <pre data-clipboard-target="source"><code>const foo = "bar"</code></pre>
        <button data-action="click->clipboard#copy" data-clipboard-target="button">Copy Code</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ClipboardController, customTextHTML, 'clipboard')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("uses custom success text", async () => {
      controller.copy()
      await nextFrame()

      expect(controller.buttonTarget.textContent).toBe("Done!")
    })

    test("uses custom success duration", async () => {
      controller.copy()
      await nextFrame()

      expect(controller.buttonTarget.textContent).toBe("Done!")

      await wait(150)
      expect(controller.buttonTarget.textContent).toBe("Copy Code")
    })
  })

  describe("without button target", () => {
    const noButtonHTML = `
      <div data-controller="clipboard">
        <pre data-clipboard-target="source"><code>npm install shadcn-rails</code></pre>
        <button data-action="click->clipboard#copy">Copy</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ClipboardController, noButtonHTML, 'clipboard')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("still copies text without button target", async () => {
      controller.copy()
      await nextFrame()

      expect(mockClipboard.writeText).toHaveBeenCalledWith("npm install shadcn-rails")
    })

    test("does not throw when showing success without button target", async () => {
      expect(() => {
        controller.copy()
      }).not.toThrow()
    })
  })

  describe("clipboard API failure", () => {
    const failureHTML = `
      <div data-controller="clipboard">
        <pre data-clipboard-target="source"><code>test code</code></pre>
        <button data-action="click->clipboard#copy" data-clipboard-target="button">Copy</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ClipboardController, failureHTML, 'clipboard')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles clipboard API failure gracefully", async () => {
      mockClipboard.writeText.mockRejectedValue(new Error("Clipboard access denied"))

      // Define and mock document.execCommand for fallback (doesn't exist in jsdom)
      document.execCommand = jest.fn().mockReturnValue(true)

      controller.copy()
      await nextFrame()
      await wait(50) // Wait for promise rejection to be handled

      // Fallback should have been called
      expect(document.execCommand).toHaveBeenCalledWith("copy")

      delete document.execCommand
    })
  })

  describe("multiline code", () => {
    const multilineHTML = `
      <div data-controller="clipboard">
        <pre data-clipboard-target="source"><code><%= render Shadcn::ButtonComponent.new do %>
  Click me
<% end %></code></pre>
        <button data-action="click->clipboard#copy" data-clipboard-target="button">Copy</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ClipboardController, multilineHTML, 'clipboard')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("copies multiline text correctly", async () => {
      controller.copy()
      await nextFrame()

      expect(mockClipboard.writeText).toHaveBeenCalledWith(
        expect.stringContaining("<%= render Shadcn::ButtonComponent.new do %>")
      )
      expect(mockClipboard.writeText).toHaveBeenCalledWith(
        expect.stringContaining("Click me")
      )
    })
  })

  describe("special characters", () => {
    const specialCharsHTML = `
      <div data-controller="clipboard">
        <pre data-clipboard-target="source"><code>const regex = /[a-z]+/g; &lt;script&gt;alert('xss')&lt;/script&gt;</code></pre>
        <button data-action="click->clipboard#copy" data-clipboard-target="button">Copy</button>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ClipboardController, specialCharsHTML, 'clipboard')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("handles special characters correctly", async () => {
      controller.copy()
      await nextFrame()

      // The textContent will have decoded HTML entities
      expect(mockClipboard.writeText).toHaveBeenCalled()
    })
  })
})
