import { Controller } from "@hotwired/stimulus";
import { useClickOutside } from "stimulus-use";
/**
 * Base Menu Controller
 *
 * A base controller for menu-like components (dropdown, context menu, select, etc.)
 * that provides common functionality for:
 * - Opening/closing menus
 * - Keyboard navigation (arrow keys, home, end, enter, space, escape)
 * - Focus management
 * - Click outside to close (using stimulus-use)
 * - Item selection
 *
 * Subclasses can override specific methods to customize behavior:
 * - positionContent() - Custom positioning logic
 * - showMenu() - Additional show behavior
 * - hideMenu() - Additional hide behavior
 * - shouldCloseOnClickOutside(event) - Custom click outside logic
 */
export default class default_1 extends Controller {
    static { this.targets = ["trigger", "content", "item"]; }
    static { this.values = {
        open: { type: Boolean, default: false },
        hideDelay: { type: Number, default: 150 }
    }; }
    // Lifecycle hooks
    connect() {
        this.focusedIndex = -1;
        this.hideTimeoutId = null;
        this.boundHandleKeydown = this.handleKeydown.bind(this);
        // Use stimulus-use for click outside detection
        useClickOutside(this);
        if (this.openValue) {
            this.show();
        }
    }
    disconnect() {
        this.hide();
    }
    // Public API
    toggle(event) {
        event?.preventDefault();
        if (this.openValue) {
            this.hide();
        }
        else {
            this.show();
        }
    }
    show(event) {
        if (this.openValue)
            return;
        // Cancel any pending hide timeout
        this.cancelHideTimeout();
        this.openValue = true;
        if (this.hasContentTarget) {
            this.contentTarget.hidden = false;
            this.contentTarget.dataset.state = "open";
            this.positionContent(event);
        }
        if (this.hasTriggerTarget) {
            this.triggerTarget.setAttribute("aria-expanded", "true");
        }
        // Add event listeners
        this.addEventListeners();
        // Allow subclasses to add custom show behavior
        this.showMenu(event);
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
        this.removeEventListeners();
        if (this.hasContentTarget) {
            this.contentTarget.dataset.state = "closed";
            // Hide after animation completes
            this.hideTimeoutId = setTimeout(() => {
                if (!this.openValue && this.hasContentTarget) {
                    this.contentTarget.hidden = true;
                }
                this.hideTimeoutId = null;
                // Allow subclasses to add custom hide behavior
                this.hideMenu();
            }, this.hideDelayValue);
        }
        else {
            this.hideMenu();
        }
        if (this.hasTriggerTarget) {
            this.triggerTarget.setAttribute("aria-expanded", "false");
        }
        // Reset focus index
        this.focusedIndex = -1;
        this.dispatch("closed");
    }
    close() {
        this.hide();
    }
    selectItem(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled !== undefined)
            return;
        this.dispatch("select", { detail: { item } });
        this.hide();
    }
    // Event handling - clickOutside is called by stimulus-use
    clickOutside(event) {
        // Only close if menu is open and shouldCloseOnClickOutside returns true
        if (this.openValue && this.shouldCloseOnClickOutside(event)) {
            this.hide();
        }
    }
    handleKeydown(event) {
        switch (event.key) {
            case "Escape":
                this.hide();
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
    // Focus management
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
    // Protected methods that subclasses can override
    /**
     * Position the content element. Override in subclasses for custom positioning.
     * @param {Event} event - The event that triggered the show (optional)
     */
    positionContent(event) {
        // Default: no positioning (subclasses should override)
    }
    /**
     * Called after showing the menu. Override in subclasses for additional behavior.
     * @param {Event} event - The event that triggered the show (optional)
     */
    showMenu(event) {
        // Default: no-op (subclasses can override)
    }
    /**
     * Called after hiding the menu. Override in subclasses for additional behavior.
     */
    hideMenu() {
        // Default: no-op (subclasses can override)
    }
    /**
     * Determine if the menu should close on click outside.
     * Override in subclasses for custom behavior (e.g., context menu).
     * @param {Event} event - The click event
     * @returns {boolean} - True if the menu should close
     */
    shouldCloseOnClickOutside(event) {
        // Default: close if clicking outside the entire element
        return !this.element.contains(event.target);
    }
    // Private helpers
    // Note: click outside is handled by stimulus-use's useClickOutside
    addEventListeners() {
        document.addEventListener("keydown", this.boundHandleKeydown);
    }
    removeEventListeners() {
        document.removeEventListener("keydown", this.boundHandleKeydown);
    }
    cancelHideTimeout() {
        if (this.hideTimeoutId) {
            clearTimeout(this.hideTimeoutId);
            this.hideTimeoutId = null;
        }
    }
}
//# sourceMappingURL=base_menu_controller.js.map