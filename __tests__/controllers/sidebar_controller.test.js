import SidebarController from "../../app/assets/javascripts/shadcn/controllers/sidebar_controller.ts"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("SidebarController smoke", () => {
  let application
  let controller
  let originalMatchMedia

  beforeEach(() => {
    originalMatchMedia = window.matchMedia
    window.matchMedia = jest.fn().mockImplementation((query) => ({
      matches: false,
      media: query,
      onchange: null,
      addEventListener: jest.fn(),
      removeEventListener: jest.fn(),
      addListener: jest.fn(),
      removeListener: jest.fn(),
      dispatchEvent: jest.fn()
    }))
  })

  afterEach(() => {
    cleanupController(application)
    window.matchMedia = originalMatchMedia
  })

  test("connects and syncs expanded state", async () => {
    const setup = await setupController(SidebarController, `
      <aside data-controller="shadcn--sidebar" data-shadcn--sidebar-open-value="true">
        <div data-shadcn--sidebar-target="sidebar"></div>
      </aside>
    `, "shadcn--sidebar")

    application = setup.application
    controller = setup.controller

    expect(controller).toBeInstanceOf(SidebarController)
    expect(setup.element.dataset.state).toBe("expanded")
  })
})
