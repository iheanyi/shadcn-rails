import DropdownController from "../../app/assets/javascripts/shadcn/controllers/dropdown_controller.ts"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("DropdownController smoke", () => {
  let application
  let controller

  afterEach(() => cleanupController(application))

  test("connects in the closed state", async () => {
    const setup = await setupController(DropdownController, `
      <div data-controller="shadcn--dropdown" data-shadcn--dropdown-open-value="false">
        <button data-shadcn--dropdown-target="trigger" aria-expanded="false">Open</button>
        <div data-shadcn--dropdown-target="content" hidden>
          <button data-shadcn--dropdown-target="item">Profile</button>
        </div>
      </div>
    `, "shadcn--dropdown")

    application = setup.application
    controller = setup.controller

    expect(controller).toBeInstanceOf(DropdownController)
    expect(controller.openValue).toBe(false)
  })
})
