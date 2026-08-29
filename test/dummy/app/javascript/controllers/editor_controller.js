import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "params", "preview"]

  connect() {
    this.applyCurrentState()
    this.updatePreview()
    this.updateParams()
  }

  marksChanged(event) {
    this.applyMarks(this.normalizeValues(event.detail.value))
    this.updatePreview()
    this.updateParams()
  }

  alignmentChanged(event) {
    this.applyAlignment(this.normalizeValues(event.detail.value)[0] || "left")
    this.updatePreview()
    this.updateParams()
  }

  canvasChanged() {
    this.updatePreview()
    this.updateParams()
  }

  preview(event) {
    event.preventDefault()
    this.applyCurrentState()
    this.updatePreview()
  }

  applyCurrentState() {
    this.applyMarks(this.paramsForForm().editor.marks)
    this.applyAlignment(this.paramsForForm().editor.alignment)
  }

  applyMarks(marks) {
    this.canvasTarget.style.fontWeight = marks.includes("bold") ? "700" : "400"
    this.canvasTarget.style.fontStyle = marks.includes("italic") ? "italic" : "normal"
    this.canvasTarget.style.textDecoration = marks.includes("underline") ? "underline" : "none"
  }

  applyAlignment(alignment) {
    this.canvasTarget.style.textAlign = alignment
  }

  updatePreview() {
    this.previewTarget.textContent = this.canvasTarget.value || "Nothing to preview yet."
    this.previewTarget.style.fontWeight = this.canvasTarget.style.fontWeight
    this.previewTarget.style.fontStyle = this.canvasTarget.style.fontStyle
    this.previewTarget.style.textDecoration = this.canvasTarget.style.textDecoration
    this.previewTarget.style.textAlign = this.canvasTarget.style.textAlign
  }

  updateParams() {
    this.paramsTarget.textContent = JSON.stringify(this.paramsForForm(), null, 2)
  }

  paramsForForm() {
    const formData = new FormData(this.element)

    return {
      editor: {
        marks: this.normalizeValues(formData.get("editor[marks]")),
        alignment: formData.get("editor[alignment]") || "left",
        body: formData.get("editor[body]") || ""
      }
    }
  }

  normalizeValues(value) {
    if (Array.isArray(value)) return value
    if (!value) return []
    return value.toString().split(",").filter(Boolean)
  }
}
