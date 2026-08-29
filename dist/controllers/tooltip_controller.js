import { Controller } from "@hotwired/stimulus";
import { positionFloating } from "../utils/floating";
/**
 * Tooltip controller for contextual information
 * Uses Floating UI for smart positioning
 */
export default class default_1 extends Controller {
    static { this.targets = ["trigger", "content"]; }
    static { this.values = {
        side: { type: String, default: "top" },
        align: { type: String, default: "center" },
        delay: { type: Number, default: 200 },
        skipDelay: { type: Number, default: 300 }
    }; }
    connect() {
        this.showTimeout = null;
        this.hideTimeout = null;
        this.cleanupFloating = null;
    }
    disconnect() {
        this.clearTimeouts();
        this.cleanupPositioning();
    }
    cleanupPositioning() {
        if (this.cleanupFloating) {
            this.cleanupFloating();
            this.cleanupFloating = null;
        }
    }
    get placement() {
        // Convert side/align to Floating UI placement
        const align = this.alignValue === "center" ? "" : `-${this.alignValue}`;
        return `${this.sideValue}${align}`;
    }
    show() {
        this.clearTimeouts();
        this.showTimeout = setTimeout(() => {
            if (this.hasContentTarget) {
                this.contentTarget.hidden = false;
                this.contentTarget.dataset.state = "open";
                // Use Floating UI for smart positioning
                if (this.hasTriggerTarget) {
                    this.cleanupFloating = positionFloating(this.triggerTarget, this.contentTarget, {
                        placement: this.placement,
                        offset: 8
                    });
                }
            }
        }, this.delayValue);
    }
    hide() {
        this.clearTimeouts();
        // Cleanup Floating UI
        this.cleanupPositioning();
        this.hideTimeout = setTimeout(() => {
            if (this.hasContentTarget) {
                this.contentTarget.dataset.state = "closed";
                setTimeout(() => {
                    this.contentTarget.hidden = true;
                }, 100);
            }
        }, 0);
    }
    clearTimeouts() {
        if (this.showTimeout) {
            clearTimeout(this.showTimeout);
            this.showTimeout = null;
        }
        if (this.hideTimeout) {
            clearTimeout(this.hideTimeout);
            this.hideTimeout = null;
        }
    }
}
//# sourceMappingURL=tooltip_controller.js.map