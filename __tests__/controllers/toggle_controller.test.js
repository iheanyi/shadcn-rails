import ToggleController from "../../app/assets/javascripts/shadcn/controllers/toggle_controller.ts"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("ToggleController smoke", () => {
  let application
  let controller

  afterEach(() => cleanupController(application))

  test("connects and reflects the pressed value", async () => {
    const setup = await setupController(ToggleController, `
      <button data-controller="shadcn--toggle" data-shadcn--toggle-pressed-value="true">
        Bold
      </button>
    `, "shadcn--toggle")

    application = setup.application
    controller = setup.controller

    expect(controller).toBeInstanceOf(ToggleController)
    expect(setup.element.getAttribute("aria-pressed")).toBe("true")
  })
})
