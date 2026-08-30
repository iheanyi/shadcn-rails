import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 275 }
  }

  connect() {
    this.timeout = null
    this.frameUrl = null
    this.captureFrameRequestHandler = (event) => this.captureFrameRequest(event)
    this.syncFromFrameHandler = (event) => this.syncFromFrame(event)

    document.addEventListener("turbo:before-fetch-request", this.captureFrameRequestHandler)
    document.addEventListener("turbo:frame-load", this.syncFromFrameHandler)
  }

  disconnect() {
    this.clearPendingSubmit()
    document.removeEventListener("turbo:before-fetch-request", this.captureFrameRequestHandler)
    document.removeEventListener("turbo:frame-load", this.syncFromFrameHandler)
  }

  submitNow() {
    this.clearPendingSubmit()
    this.submitForm()
  }

  submitLater() {
    this.clearPendingSubmit()
    this.timeout = window.setTimeout(() => {
      this.submitForm()
    }, this.delayValue)
  }

  submitForm() {
    if (this.element instanceof HTMLFormElement) {
      this.element.requestSubmit()
    }
  }

  captureFrameRequest(event) {
    if (event.target !== this.frameElement) return

    this.frameUrl = event.detail?.url?.toString()
  }

  syncFromFrame(event) {
    if (event.target !== this.frameElement || !this.frameUrl) return

    this.syncFromUrl(this.frameUrl)
    this.frameUrl = null
  }

  syncFromUrl(url) {
    const params = new URL(url, window.location.href).searchParams

    this.syncField("q", params)
    this.syncField("status", params)
    this.syncHiddenField("sort", params)
    this.syncHiddenField("dir", params)
  }

  syncField(name, params) {
    const field = this.element.querySelector(`[name="${name}"]`)
    if (!field) return

    field.value = params.get(name) || ""
  }

  syncHiddenField(name, params) {
    const value = params.get(name)
    const field = this.element.querySelector(`input[type="hidden"][name="${name}"]`)

    if (value) {
      const input = field || this.createHiddenField(name)
      input.value = value
    } else if (field) {
      field.remove()
    }
  }

  createHiddenField(name) {
    const input = document.createElement("input")
    input.type = "hidden"
    input.name = name
    this.element.append(input)

    return input
  }

  get frameElement() {
    return document.getElementById(this.element.dataset.turboFrame)
  }

  clearPendingSubmit() {
    if (!this.timeout) return

    window.clearTimeout(this.timeout)
    this.timeout = null
  }
}
