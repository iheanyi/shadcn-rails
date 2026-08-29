import AvatarController from "../../app/assets/javascripts/shadcn/controllers/avatar_controller.ts"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("AvatarController smoke", () => {
  let application
  let controller

  afterEach(() => cleanupController(application))

  test("connects with image and fallback targets", async () => {
    const setup = await setupController(AvatarController, `
      <div data-controller="shadcn--avatar">
        <img data-shadcn--avatar-target="image" src="/missing.png" alt="Demo">
        <span data-shadcn--avatar-target="fallback" class="hidden">DE</span>
      </div>
    `, "shadcn--avatar")

    application = setup.application
    controller = setup.controller

    expect(controller).toBeInstanceOf(AvatarController)
  })
})
