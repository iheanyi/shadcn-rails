import BaseMenuController from "./base_menu_controller";
import { positionFloating } from "../utils/floating";
/**
 * Dropdown controller for dropdown menus
 * Extends BaseMenuController with Floating UI positioning
 */
export default class default_1 extends BaseMenuController {
    static { this.targets = [...BaseMenuController.targets]; }
    static { this.values = {
        ...BaseMenuController.values,
        align: { type: String, default: "end" },
        side: { type: String, default: "bottom" }
    }; }
    connect() {
        this.cleanupFloating = null;
        super.connect();
    }
    disconnect() {
        this.cleanupPositioning();
        super.disconnect();
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
    positionContent() {
        if (!this.hasContentTarget || !this.hasTriggerTarget)
            return;
        // Use Floating UI for smart positioning
        this.cleanupFloating = positionFloating(this.triggerTarget, this.contentTarget, {
            placement: this.placement,
            offset: 4,
            sameWidth: false
        });
    }
    hideMenu() {
        this.cleanupPositioning();
        super.hideMenu();
    }
    toggleCheckbox(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled !== undefined)
            return;
        const isChecked = item.dataset.state === "checked";
        item.dataset.state = isChecked ? "unchecked" : "checked";
        item.setAttribute("aria-checked", (!isChecked).toString());
        // Toggle the check icon visibility
        const indicator = item.querySelector("span svg");
        if (indicator) {
            indicator.style.display = isChecked ? "none" : "block";
        }
        this.dispatch("check", { detail: { item, checked: !isChecked } });
    }
    selectRadio(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled !== undefined)
            return;
        const group = item.closest("[role='group']");
        if (group) {
            // Uncheck all radio items in the group
            group.querySelectorAll("[role='menuitemradio']").forEach((radio) => {
                radio.dataset.state = "unchecked";
                radio.setAttribute("aria-checked", "false");
                const indicator = radio.querySelector("span svg");
                if (indicator)
                    indicator.style.display = "none";
            });
        }
        // Check this item
        item.dataset.state = "checked";
        item.setAttribute("aria-checked", "true");
        const indicator = item.querySelector("span svg");
        if (indicator)
            indicator.style.display = "block";
        this.dispatch("radioChange", { detail: { item, value: item.dataset.value } });
    }
}
//# sourceMappingURL=dropdown_controller.js.map