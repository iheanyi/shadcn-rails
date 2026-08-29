import CommandDialogController from "../../app/assets/javascripts/shadcn/controllers/command_dialog_controller.ts"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("CommandDialogController smoke", () => {
  let application
  let controller

  afterEach(() => cleanupController(application))

  test("connects without opening when closed", async () => {
    const setup = await setupController(CommandDialogController, `
      <div data-controller="shadcn--command-dialog" data-shadcn--command-dialog-open-value="false">
        <button data-shadcn--command-dialog-target="trigger">Open command menu</button>
        <template data-shadcn--command-dialog-target="template">
          <div data-shadcn--command-dialog-target="overlay" hidden></div>
          <div data-shadcn--command-dialog-target="content" hidden></div>
        </template>
      </div>
    `, "shadcn--command-dialog")

    application = setup.application
    controller = setup.controller

    expect(controller).toBeInstanceOf(CommandDialogController)
    expect(controller.openValue).toBe(false)
  })
})
