import { Controller } from "@hotwired/stimulus";
import { useClickOutside } from "stimulus-use";
import { positionFloating } from "../utils/floating";
/**
 * Select controller for custom select dropdowns
 * Uses Floating UI for smart positioning and stimulus-use for click outside detection
 */
export default class default_1 extends Controller {
    static { this.targets = ["trigger", "content", "input", "item", "display", "checkIcon"]; }
    static { this.values = {
        value: String,
        placement: { type: String, default: "bottom-start" },
        sameWidth: { type: Boolean, default: true }
    }; }
    connect() {
        this.isOpen = false;
        this.focusedIndex = -1;
        this.cleanupFloating = null;
        // Use stimulus-use for click outside detection
        useClickOutside(this);
        // Set initial value display
        if (this.valueValue) {
            this.selectByValue(this.valueValue, false);
        }
    }
    disconnect() {
        this.close();
        this.cleanupPositioning();
    }
    cleanupPositioning() {
        if (this.cleanupFloating) {
            this.cleanupFloating();
            this.cleanupFloating = null;
        }
    }
    toggle(event) {
        event?.preventDefault();
        if (this.isOpen) {
            this.close();
        }
        else {
            this.open();
        }
    }
    open() {
        if (this.isOpen)
            return;
        this.isOpen = true;
        if (this.hasContentTarget) {
            this.contentTarget.hidden = false;
            this.contentTarget.dataset.state = "open";
            // Use Floating UI for smart positioning
            if (this.hasTriggerTarget) {
                this.cleanupFloating = positionFloating(this.triggerTarget, this.contentTarget, {
                    placement: this.placementValue,
                    minWidth: true,
                    referenceWidthVariable: "--radix-select-trigger-width",
                    maxHeight: 384 // max-h-96
                });
            }
        }
        if (this.hasTriggerTarget) {
            this.triggerTarget.setAttribute("aria-expanded", "true");
        }
        // Focus current value or first item
        this.focusedIndex = -1;
        const currentItem = this.itemTargets.find((item) => item.dataset.value === this.valueValue);
        if (currentItem) {
            this.focusedIndex = this.itemTargets.indexOf(currentItem);
            currentItem.focus();
        }
        else {
            this.focusNextItem();
        }
        this.dispatch("opened");
    }
    close() {
        if (!this.isOpen)
            return;
        this.isOpen = false;
        // Cleanup Floating UI auto-update
        this.cleanupPositioning();
        if (this.hasContentTarget) {
            this.contentTarget.dataset.state = "closed";
            setTimeout(() => {
                if (!this.isOpen) {
                    this.contentTarget.hidden = true;
                }
            }, 150);
        }
        if (this.hasTriggerTarget) {
            this.triggerTarget.setAttribute("aria-expanded", "false");
        }
        this.focusedIndex = -1;
        this.dispatch("closed");
    }
    // Called by stimulus-use when clicking outside the element
    clickOutside(event) {
        if (this.isOpen) {
            this.close();
        }
    }
    select(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled !== undefined)
            return;
        const value = item.dataset.value;
        this.selectByValue(value);
        this.close();
        this.triggerTarget?.focus();
    }
    selectByValue(value, dispatch = true) {
        this.valueValue = value;
        if (this.hasTriggerTarget) {
            if (value) {
                this.triggerTarget.removeAttribute("data-placeholder");
            }
            else {
                this.triggerTarget.setAttribute("data-placeholder", "");
            }
        }
        // Update hidden input
        if (this.hasInputTarget) {
            this.inputTarget.value = value;
        }
        // Update display
        const selectedItem = this.itemTargets.find((item) => item.dataset.value === value);
        if (this.hasDisplayTarget && selectedItem) {
            this.displayTarget.textContent = selectedItem.textContent.trim();
        }
        // Update aria-selected and check icons
        this.itemTargets.forEach((item) => {
            const isSelected = item.dataset.value === value;
            item.setAttribute("aria-selected", isSelected.toString());
            const checkIcon = item.querySelector('[data-shadcn--select-target="checkIcon"]');
            if (checkIcon) {
                checkIcon.style.opacity = isSelected ? "1" : "0";
            }
        });
        if (dispatch) {
            this.dispatch("change", { detail: { value } });
        }
    }
    handleKeydown(event) {
        if (!this.isOpen) {
            if (event.key === "Enter" || event.key === " " || event.key === "ArrowDown") {
                event.preventDefault();
                this.open();
            }
            return;
        }
        switch (event.key) {
            case "Escape":
                event.preventDefault();
                this.close();
                this.triggerTarget?.focus();
                break;
            case "ArrowDown":
                event.preventDefault();
                this.focusNextItem();
                break;
            case "ArrowUp":
                event.preventDefault();
                this.focusPreviousItem();
                break;
            case "Home":
                event.preventDefault();
                this.focusFirstItem();
                break;
            case "End":
                event.preventDefault();
                this.focusLastItem();
                break;
            case "Enter":
            case " ":
                event.preventDefault();
                this.selectFocusedItem();
                break;
        }
    }
    focusNextItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = (this.focusedIndex + 1) % items.length;
        items[this.focusedIndex].focus();
    }
    focusPreviousItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = this.focusedIndex <= 0 ? items.length - 1 : this.focusedIndex - 1;
        items[this.focusedIndex].focus();
    }
    focusFirstItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = 0;
        items[0].focus();
    }
    focusLastItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = items.length - 1;
        items[this.focusedIndex].focus();
    }
    selectFocusedItem() {
        const items = this.enabledItems;
        if (this.focusedIndex >= 0 && this.focusedIndex < items.length) {
            items[this.focusedIndex].click();
        }
    }
    get enabledItems() {
        return this.itemTargets.filter((item) => item.dataset.disabled === undefined);
    }
}
//# sourceMappingURL=select_controller.js.map