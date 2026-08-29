import { Controller } from "@hotwired/stimulus";
/**
 * Toggle Controller
 *
 * Handles toggle button state management
 *
 * Values:
 * - pressed: Boolean indicating if toggle is pressed
 */
export default class default_1 extends Controller {
    static { this.values = {
        pressed: { type: Boolean, default: false }
    }; }
    connect() {
        this.updateState();
    }
    toggle() {
        if (this.element.disabled)
            return;
        this.pressedValue = !this.pressedValue;
        this.updateState();
        this.dispatchChange();
    }
    updateState() {
        this.element.setAttribute("aria-pressed", this.pressedValue.toString());
        this.element.dataset.state = this.pressedValue ? "on" : "off";
    }
    dispatchChange() {
        this.dispatch("change", {
            detail: { pressed: this.pressedValue }
        });
    }
    pressedValueChanged() {
        this.updateState();
    }
}
//# sourceMappingURL=toggle_controller.js.map