import ScrollAreaController from "../../app/assets/javascripts/shadcn/controllers/scroll_area_controller.ts"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("ScrollAreaController smoke", () => {
  let application
  let controller

  afterEach(() => cleanupController(application))

  test("connects with viewport, scrollbar, and thumb targets", async () => {
    const setup = await setupController(ScrollAreaController, `
      <div data-controller="shadcn--scroll-area" data-shadcn--scroll-area-type-value="always">
        <div data-shadcn--scroll-area-target="viewport" style="height: 100px; overflow: auto;">
          <div style="height: 200px;"></div>
        </div>
        <div data-shadcn--scroll-area-target="scrollbar">
          <div data-shadcn--scroll-area-target="thumb"></div>
        </div>
      </div>
    `, "shadcn--scroll-area")

    application = setup.application
    controller = setup.controller

    expect(controller).toBeInstanceOf(ScrollAreaController)
  })
})
