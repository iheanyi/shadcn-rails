import SonnerController, { dismiss, toast } from "../../app/assets/javascripts/shadcn/controllers/sonner_controller.ts"
import { setupController, cleanupController, click, nextFrame } from "../helpers/stimulus-test-helper.js"

function toasterHtml({ limit = 3, duration = 4000, position = "bottom-right" } = {}) {
  return `
    <div data-controller="shadcn--sonner"
         data-shadcn--sonner-limit-value="${limit}"
         data-shadcn--sonner-duration-value="${duration}"
         data-shadcn--sonner-position-value="${position}">
      <ol id="shadcn-sonner-viewport" data-shadcn--sonner-target="viewport"></ol>
    </div>
  `
}

describe("SonnerController", () => {
  let application
  let controller

  beforeEach(async () => {
    const setup = await setupController(SonnerController, toasterHtml(), "shadcn--sonner")
    application = setup.application
    controller = setup.controller
  })

  afterEach(() => {
    jest.useRealTimers()
    dismiss()
    cleanupController(application)
  })

  test("toast() appends a toast with title, description, variant, and close button", () => {
    const id = toast("Saved", {
      description: "Your changes are live.",
      variant: "success",
      duration: 0
    })

    const toastElement = document.querySelector(`[data-shadcn-sonner-toast-id="${id}"]`)

    expect(toastElement).not.toBeNull()
    expect(toastElement).toHaveTextContent("Saved")
    expect(toastElement).toHaveTextContent("Your changes are live.")
    expect(toastElement).toHaveAttribute("role", "status")
    expect(toastElement).toHaveAttribute("aria-live", "polite")
    expect(toastElement).toHaveAttribute("data-variant", "success")
    expect(toastElement.querySelector("[data-sonner-close]")).not.toBeNull()
  })

  test("toast.dismiss(id) removes the selected toast", () => {
    jest.useFakeTimers()
    const keepId = toast("Keep", { duration: 0 })
    const removeId = toast("Remove", { duration: 0 })

    toast.dismiss(removeId)
    jest.advanceTimersByTime(250)

    expect(document.querySelector(`[data-shadcn-sonner-toast-id="${keepId}"]`)).not.toBeNull()
    expect(document.querySelector(`[data-shadcn-sonner-toast-id="${removeId}"]`)).toBeNull()
  })

  test("generated close button dismisses without starting a swipe", async () => {
    const id = toast("Closable", { duration: 0 })
    const toastElement = document.querySelector(`[data-shadcn-sonner-toast-id="${id}"]`)
    const closeButton = toastElement.querySelector("[data-sonner-close]")
    const closeIconPath = closeButton.querySelector("path")
    const PointerEventConstructor = window.PointerEvent ?? MouseEvent

    await nextFrame()
    jest.useFakeTimers()
    expect(closeButton.dataset.sonnerCloseBound).toBeUndefined()
    closeIconPath.dispatchEvent(new PointerEventConstructor("pointerdown", { bubbles: true }))
    click(closeIconPath)
    jest.advanceTimersByTime(250)

    expect(document.querySelector(`[data-shadcn-sonner-toast-id="${id}"]`)).toBeNull()
  })

  test("toast.dismiss(id) removes queued toasts before the toaster connects", async () => {
    cleanupController(application)
    application = null

    const id = toast("Queued save", { duration: 0 })
    toast.dismiss(id)

    const setup = await setupController(SonnerController, toasterHtml(), "shadcn--sonner")
    application = setup.application
    controller = setup.controller

    expect(document.querySelector(`[data-shadcn-sonner-toast-id="${id}"]`)).toBeNull()
  })

  test("enforces the configured visible toast limit", async () => {
    cleanupController(application)
    const setup = await setupController(SonnerController, toasterHtml({ limit: 2 }), "shadcn--sonner")
    application = setup.application
    controller = setup.controller

    jest.useFakeTimers()
    const firstId = toast("First", { duration: 0 })
    toast("Second", { duration: 0 })
    toast("Third", { duration: 0 })
    jest.advanceTimersByTime(250)

    const toastElements = Array.from(document.querySelectorAll("[data-shadcn-sonner-toast-id]"))
    expect(document.querySelector(`[data-shadcn-sonner-toast-id="${firstId}"]`)).toBeNull()
    expect(toastElements).toHaveLength(2)
    expect(toastElements[0]).toHaveTextContent("Third")
    expect(toastElements[1]).toHaveTextContent("Second")
  })

  test("pauses and resumes auto-dismiss while hovered", () => {
    jest.useFakeTimers()
    const id = toast("Hover me", { duration: 100 })
    const toastElement = document.querySelector(`[data-shadcn-sonner-toast-id="${id}"]`)

    jest.advanceTimersByTime(50)
    toastElement.dispatchEvent(new MouseEvent("mouseenter", { bubbles: true }))
    jest.advanceTimersByTime(150)

    expect(document.querySelector(`[data-shadcn-sonner-toast-id="${id}"]`)).not.toBeNull()

    toastElement.dispatchEvent(new MouseEvent("mouseleave", { bubbles: true }))
    jest.advanceTimersByTime(300)

    expect(document.querySelector(`[data-shadcn-sonner-toast-id="${id}"]`)).toBeNull()
  })

  test("initializes toast markup appended into the persistent viewport", async () => {
    const toastElement = document.createElement("li")
    toastElement.dataset.sonnerToast = "true"
    toastElement.dataset.duration = "0"
    toastElement.textContent = "Server-rendered toast"

    controller.viewportTarget.appendChild(toastElement)
    await nextFrame()

    expect(toastElement.dataset.shadcnSonnerToastId).toMatch(/^sonner-/)
    expect(toastElement.dataset.shadcnSonnerBound).toBe("true")
    expect(toastElement.getAttribute("data-action")).toContain("mouseenter->shadcn--sonner#pause")
    expect(toastElement.getAttribute("data-action")).toContain("pointerdown->shadcn--sonner#startSwipe")
    expect(toastElement).toHaveTextContent("Server-rendered toast")
    expect(toastElement.querySelector("[data-sonner-close]")).not.toBeNull()
  })

  test("demo action reads data attributes from triggers", async () => {
    document.body.insertAdjacentHTML(
      "beforeend",
      '<button data-action="click->shadcn--sonner#demo" data-title="Demo" data-description="Triggered from data attributes" data-variant="info" data-duration="0">Show</button>'
    )
    const button = document.querySelector("button[data-title='Demo']")

    controller.element.appendChild(button)
    await nextFrame()
    click(button)

    const toastElement = document.querySelector("[data-shadcn-sonner-toast-id]")
    expect(toastElement).toHaveTextContent("Demo")
    expect(toastElement).toHaveTextContent("Triggered from data attributes")
    expect(toastElement).toHaveAttribute("data-variant", "info")
  })
})
