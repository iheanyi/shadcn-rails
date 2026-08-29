import BaseMenuController from "./base_menu_controller";
import { positionAtPoint } from "../utils/floating";
/**
 * Context Menu controller for right-click menus
 * Extends BaseMenuController with Floating UI positioning at cursor location
 */
export default class default_1 extends BaseMenuController {
    static { this.targets = [...BaseMenuController.targets]; }
    static { this.values = {
        ...BaseMenuController.values,
        hideDelay: { type: Number, default: 100 }
    }; }
    connect() {
        super.connect();
        this.boundHandleContextMenu = this.handleContextMenu.bind(this);
        this.originalOverflow = null;
        this.mouseX = 0;
        this.mouseY = 0;
        this._ignoreClickOutside = false;
    }
    // Override clickOutside to handle the deferred close behavior
    // Context menus need to ignore clicks in the same frame as the right-click
    clickOutside(event) {
        if (this._ignoreClickOutside)
            return;
        super.clickOutside(event);
    }
    show(event) {
        event?.preventDefault();
        // Cancel any pending hide timeout from a previous close
        this.cancelHideTimeout();
        // Store mouse position for positioning
        this.mouseX = event?.clientX || 0;
        this.mouseY = event?.clientY || 0;
        this.openValue = true;
        // Lock scroll (only if not already locked)
        if (document.body.style.overflow !== "hidden") {
            this.originalOverflow = document.body.style.overflow;
            document.body.style.overflow = "hidden";
        }
        if (this.hasContentTarget) {
            this.contentTarget.hidden = false;
            this.contentTarget.dataset.state = "open";
            this.positionContent();
        }
        // Defer click outside detection to prevent immediate close from right-click
        // The contextmenu event can sometimes trigger a click in the same event cycle
        this._ignoreClickOutside = true;
        requestAnimationFrame(() => {
            this._ignoreClickOutside = false;
            if (this.openValue) {
                document.addEventListener("contextmenu", this.boundHandleContextMenu);
            }
        });
        document.addEventListener("keydown", this.boundHandleKeydown);
        // Focus first item
        this.focusedIndex = -1;
        this.focusNextItem();
        this.dispatch("opened");
    }
    hide() {
        if (!this.openValue)
            return;
        this.openValue = false;
        // Remove event listeners immediately to prevent double-triggering
        document.removeEventListener("contextmenu", this.boundHandleContextMenu);
        document.removeEventListener("keydown", this.boundHandleKeydown);
        if (this.hasContentTarget) {
            this.contentTarget.dataset.state = "closed";
            // Wait for animation to complete before hiding and restoring scroll
            // Animation duration is 100ms, add buffer for smooth transition
            this.hideTimeoutId = setTimeout(() => {
                if (!this.openValue) {
                    this.contentTarget.hidden = true;
                    // Restore scroll only after menu is fully hidden
                    document.body.style.overflow = this.originalOverflow || "";
                }
                this.hideTimeoutId = null;
            }, this.hideDelayValue);
        }
        else {
            // No content target, restore scroll immediately
            document.body.style.overflow = this.originalOverflow || "";
        }
        // Reset focus index
        this.focusedIndex = -1;
        this.dispatch("closed");
    }
    handleContextMenu(event) {
        // Don't close if right-clicking on the trigger element
        // This allows show() to be called again to reposition the menu
        if (this.hasTriggerTarget && this.triggerTarget.contains(event.target)) {
            return;
        }
        // Close if right-clicking outside the content
        if (this.hasContentTarget && !this.contentTarget.contains(event.target)) {
            this.hide();
        }
    }
    shouldCloseOnClickOutside(event) {
        // Don't close if clicking inside the content
        if (this.hasContentTarget && this.contentTarget.contains(event.target)) {
            return false;
        }
        return true;
    }
    positionContent() {
        if (!this.hasContentTarget)
            return;
        // Use Floating UI for smart positioning at cursor location
        positionAtPoint(this.contentTarget, this.mouseX, this.mouseY);
    }
}
//# sourceMappingURL=context_menu_controller.js.map