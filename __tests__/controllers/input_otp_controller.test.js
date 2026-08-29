import InputOtpController from "../../app/assets/javascripts/shadcn/controllers/input_otp_controller.ts"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("InputOtpController smoke", () => {
  let application
  let controller

  afterEach(() => cleanupController(application))

  test("connects and syncs hidden input", async () => {
    const setup = await setupController(InputOtpController, `
      <div data-controller="shadcn--input-otp" data-shadcn--input-otp-length-value="2">
        <input data-shadcn--input-otp-target="hiddenInput" type="hidden">
        <div data-shadcn--input-otp-target="slot" data-index="0">
          <input data-shadcn--input-otp-target="input" data-index="0" value="1">
          <span data-shadcn--input-otp-target="caret"></span>
        </div>
        <div data-shadcn--input-otp-target="slot" data-index="1">
          <input data-shadcn--input-otp-target="input" data-index="1" value="2">
          <span data-shadcn--input-otp-target="caret"></span>
        </div>
      </div>
    `, "shadcn--input-otp")

    application = setup.application
    controller = setup.controller

    expect(controller).toBeInstanceOf(InputOtpController)
    expect(controller.hiddenInputTarget.value).toBe("12")
  })
})
