import DocsLiveFilterController from "../../test/dummy/app/javascript/controllers/docs_live_filter_controller.js"
import { setupController, cleanupController } from "../helpers/stimulus-test-helper.js"

describe("DocsLiveFilterController", () => {
  let application

  afterEach(() => cleanupController(application))

  test("syncs the mounted form after turbo frame navigations", async () => {
    const setup = await setupController(DocsLiveFilterController, `
      <form data-controller="docs--live-filter" data-turbo-frame="data-table-demo">
        <input type="hidden" name="sort" value="name">
        <input type="hidden" name="dir" value="desc">
        <input name="q" value="olivia">
        <select name="status">
          <option value="">All statuses</option>
          <option value="Paid" selected>Paid</option>
        </select>
      </form>
      <turbo-frame id="data-table-demo"></turbo-frame>
    `, "docs--live-filter")
    application = setup.application

    const frame = document.getElementById("data-table-demo")
    dispatchTurboEvent(frame, "turbo:before-fetch-request", {
      url: new URL("/docs/components/data-table?q=olivia&status=Paid&sort=email&dir=asc", window.location.href)
    })
    dispatchTurboEvent(frame, "turbo:frame-load")

    expect(setup.element.querySelector("[name='q']").value).toBe("olivia")
    expect(setup.element.querySelector("[name='status']").value).toBe("Paid")
    expect(setup.element.querySelector("[name='sort']").value).toBe("email")
    expect(setup.element.querySelector("[name='dir']").value).toBe("asc")
  })

  test("clears stale fields after reset frame navigations", async () => {
    const setup = await setupController(DocsLiveFilterController, `
      <form data-controller="docs--live-filter" data-turbo-frame="data-table-demo">
        <input type="hidden" name="sort" value="name">
        <input type="hidden" name="dir" value="desc">
        <input name="q" value="olivia">
        <select name="status">
          <option value="">All statuses</option>
          <option value="Paid" selected>Paid</option>
        </select>
      </form>
      <turbo-frame id="data-table-demo"></turbo-frame>
    `, "docs--live-filter")
    application = setup.application

    const frame = document.getElementById("data-table-demo")
    dispatchTurboEvent(frame, "turbo:before-fetch-request", {
      url: new URL("/docs/components/data-table", window.location.href)
    })
    dispatchTurboEvent(frame, "turbo:frame-load")

    expect(setup.element.querySelector("[name='q']").value).toBe("")
    expect(setup.element.querySelector("[name='status']").value).toBe("")
    expect(setup.element.querySelector("[name='sort']")).toBeNull()
    expect(setup.element.querySelector("[name='dir']")).toBeNull()
  })
})

function dispatchTurboEvent(element, name, detail = {}) {
  element.dispatchEvent(new CustomEvent(name, {
    bubbles: true,
    cancelable: true,
    detail
  }))
}
