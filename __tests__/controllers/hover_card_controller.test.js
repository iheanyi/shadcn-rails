import HoverCardController from "../../app/assets/javascripts/shadcn/controllers/hover_card_controller.ts"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("HoverCardController smoke", () => {
  let application
  let controller

  afterEach(() => cleanupController(application))

  test("connects with trigger and content targets", async () => {
    const setup = await setupController(HoverCardController, `
      <div data-controller="shadcn--hover-card">
        <a href="#" data-shadcn--hover-card-target="trigger">Hover me</a>
        <div data-shadcn--hover-card-target="content" hidden>Preview content</div>
      </div>
    `, "shadcn--hover-card")

    application = setup.application
    controller = setup.controller

    expect(controller).toBeInstanceOf(HoverCardController)
  })
})
