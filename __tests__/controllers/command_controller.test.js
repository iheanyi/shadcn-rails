import CommandController from "../../app/assets/javascripts/shadcn/controllers/command_controller.ts"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("CommandController smoke", () => {
  let application
  let controller

  afterEach(() => cleanupController(application))

  test("connects with input, list, empty, group, and item targets", async () => {
    const setup = await setupController(CommandController, `
      <div data-controller="shadcn--command">
        <input data-shadcn--command-target="input">
        <div data-shadcn--command-target="list">
          <div data-shadcn--command-target="empty" hidden>No results</div>
          <div data-shadcn--command-target="group">
            <button data-shadcn--command-target="item" data-value="calendar">Calendar</button>
          </div>
        </div>
      </div>
    `, "shadcn--command")

    application = setup.application
    controller = setup.controller

    expect(controller).toBeInstanceOf(CommandController)
  })
})
