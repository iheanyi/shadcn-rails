import ToastController from "../../app/assets/javascripts/shadcn/controllers/toast_controller.ts"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("ToastController smoke", () => {
  let application
  let controller

  afterEach(() => {
    jest.useRealTimers()
    cleanupController(application)
  })

  test("connects without starting a timer when duration is zero", async () => {
    const setup = await setupController(ToastController, `
      <div data-controller="shadcn--toast"
           data-shadcn--toast-open-value="true"
           data-shadcn--toast-duration-value="0"
           data-state="open">
        Toast message
      </div>
    `, "shadcn--toast")

    application = setup.application
    controller = setup.controller

    expect(controller).toBeInstanceOf(ToastController)
    expect(controller.openValue).toBe(true)
  })

  test("removes after shared toast motion duration", async () => {
    jest.useFakeTimers()
    const setup = await setupController(ToastController, `
      <div data-controller="shadcn--toast"
           data-shadcn--toast-open-value="true"
           data-shadcn--toast-duration-value="0"
           data-state="open">
        Toast message
      </div>
    `, "shadcn--toast")

    application = setup.application
    controller = setup.controller

    controller.close()
    jest.advanceTimersByTime(399)

    expect(document.querySelector("[data-controller='shadcn--toast']")).not.toBeNull()

    jest.advanceTimersByTime(1)

    expect(document.querySelector("[data-controller='shadcn--toast']")).toBeNull()
  })
})
