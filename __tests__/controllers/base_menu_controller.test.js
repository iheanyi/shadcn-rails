import BaseMenuController from "../../app/assets/javascripts/shadcn/controllers/base_menu_controller.ts"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("BaseMenuController smoke", () => {
  let application
  let controller

  afterEach(() => cleanupController(application))

  test("connects with trigger, content, and item targets", async () => {
    const setup = await setupController(BaseMenuController, `
      <div data-controller="shadcn--base-menu">
        <button data-shadcn--base-menu-target="trigger" aria-expanded="false">Open</button>
        <div data-shadcn--base-menu-target="content" hidden>
          <button data-shadcn--base-menu-target="item">Item</button>
        </div>
      </div>
    `, "shadcn--base-menu")

    application = setup.application
    controller = setup.controller

    expect(controller).toBeInstanceOf(BaseMenuController)
    expect(controller.openValue).toBe(false)
  })
})
