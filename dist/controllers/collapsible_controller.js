import { Controller } from "@hotwired/stimulus";
/**
 * Collapsible controller for expandable content
 */
export default class default_1 extends Controller {
    constructor() {
        super(...arguments);
        this.hasConnected = false;
    }
    static { this.targets = ["trigger", "content"]; }
    static { this.values = {
        open: { type: Boolean, default: false },
        disabled: { type: Boolean, default: false }
    }; }
    connect() {
        this.hasConnected = true;
        this.updateState({ animate: false });
    }
    toggle() {
        if (this.disabledValue)
            return;
        this.openValue = !this.openValue;
        this.updateState();
    }
    open() {
        if (this.disabledValue)
            return;
        this.openValue = true;
        this.updateState();
    }
    close() {
        this.openValue = false;
        this.updateState();
    }
    updateState({ animate = true } = {}) {
        const state = this.openValue ? "open" : "closed";
        this.element.dataset.state = state;
        if (this.hasTriggerTarget) {
            this.triggerTarget.dataset.state = state;
            this.triggerTarget.setAttribute("aria-expanded", this.openValue.toString());
        }
        if (this.hasContentTarget) {
            this.contentTarget.dataset.state = state;
            if (this.openValue) {
                this.contentTarget.hidden = false;
                if (!animate) {
                    this.contentTarget.style.height = "";
                }
                else {
                    // Animate open
                    const height = this.contentTarget.scrollHeight;
                    this.contentTarget.style.height = "0px";
                    requestAnimationFrame(() => {
                        this.contentTarget.style.height = `${height}px`;
                        setTimeout(() => {
                            this.contentTarget.style.height = "";
                        }, 200);
                    });
                }
            }
            else {
                if (!animate) {
                    this.contentTarget.hidden = true;
                    this.contentTarget.style.height = "";
                }
                else {
                    // Animate close
                    this.contentTarget.style.height = `${this.contentTarget.scrollHeight}px`;
                    requestAnimationFrame(() => {
                        this.contentTarget.style.height = "0px";
                        setTimeout(() => {
                            this.contentTarget.hidden = true;
                            this.contentTarget.style.height = "";
                        }, 200);
                    });
                }
            }
        }
        this.dispatch(this.openValue ? "opened" : "closed");
    }
    openValueChanged() {
        if (!this.hasConnected)
            return;
        this.updateState();
    }
}
//# sourceMappingURL=collapsible_controller.js.map