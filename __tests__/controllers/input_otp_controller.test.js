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

  test("marks focused slot active with data attribute", async () => {
    const setup = await setupController(InputOtpController, `
      <div data-controller="shadcn--input-otp" data-shadcn--input-otp-length-value="1">
        <input data-shadcn--input-otp-target="hiddenInput" type="hidden">
        <div data-shadcn--input-otp-target="slot" data-active="false" data-index="0">
          <input
            data-shadcn--input-otp-target="input"
            data-index="0"
            data-action="focus->shadcn--input-otp#handleFocus blur->shadcn--input-otp#handleBlur"
          >
          <span data-shadcn--input-otp-target="caret"></span>
        </div>
      </div>
    `, "shadcn--input-otp")

    application = setup.application
    controller = setup.controller

    const slot = setup.element.querySelector("[data-shadcn--input-otp-target='slot']")
    const input = setup.element.querySelector("[data-shadcn--input-otp-target='input']")

    input.dispatchEvent(new FocusEvent("focus"))
    expect(slot.dataset.active).toBe("true")
    expect(slot.className).not.toContain("ring-1")

    input.dispatchEvent(new FocusEvent("blur"))
    expect(slot.dataset.active).toBe("false")
  })
})
