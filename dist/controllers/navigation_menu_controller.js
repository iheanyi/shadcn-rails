import { Controller } from "@hotwired/stimulus";
import { useClickOutside } from "stimulus-use";
/**
 * Navigation Menu Controller
 * Handles navigation menu interactions with dropdown content areas
 * Uses stimulus-use for click outside detection
 */
export default class default_1 extends Controller {
    static { this.targets = ["list", "item", "trigger", "content", "viewport"]; }
    static { this.values = {
        openIndex: { type: Number, default: -1 },
        delayDuration: { type: Number, default: 200 },
        skipDelayDuration: { type: Number, default: 300 }
    }; }
    connect() {
        this.isOpen = false;
        this.previousIndex = -1;
        this.openTimer = null;
        this.closeTimer = null;
        this.wasClickOpened = false;
        this.boundHandleKeydown = this.handleKeydown.bind(this);
        // Use stimulus-use for click outside detection
        useClickOutside(this);
    }
    disconnect() {
        this.closeAll();
        this.clearTimers();
    }
    toggle(event) {
        event?.preventDefault();
        const trigger = event.currentTarget;
        const item = trigger.closest("[data-shadcn--navigation-menu-target='item']");
        const index = this.itemTargets.indexOf(item);
        this.clearTimers();
        if (this.openIndexValue === index) {
            this.closeAll();
        }
        else {
            this.wasClickOpened = true;
            this.openItem(index);
        }
    }
    hoverOpen(event) {
        // If opened by click, require click to close
        if (this.wasClickOpened && this.isOpen)
            return;
        const trigger = event.currentTarget;
        const item = trigger.closest("[data-shadcn--navigation-menu-target='item']");
        const index = this.itemTargets.indexOf(item);
        this.clearTimers();
        if (this.isOpen) {
            // Already open, switch immediately
            if (this.openIndexValue !== index) {
                this.openItem(index);
            }
        }
        else {
            // Not open, delay before opening
            this.openTimer = setTimeout(() => {
                this.openItem(index);
            }, this.delayDurationValue);
        }
    }
    hoverClose(event) {
        // If opened by click, require click to close
        if (this.wasClickOpened)
            return;
        this.clearTimers();
        this.closeTimer = setTimeout(() => {
            this.closeAll();
        }, this.skipDelayDurationValue);
    }
    contentHover() {
        // Cancel close timer when hovering content
        this.clearTimers();
    }
    openItem(index) {
        if (index < 0 || index >= this.itemTargets.length)
            return;
        // Close previous if different
        if (this.openIndexValue !== -1 && this.openIndexValue !== index) {
            this.closeItem(this.openIndexValue);
        }
        const item = this.itemTargets[index];
        const trigger = item.querySelector("[data-shadcn--navigation-menu-target='trigger']");
        const content = item.querySelector("[data-shadcn--navigation-menu-target='content']");
        if (!trigger || !content)
            return;
        this.previousIndex = this.openIndexValue;
        this.openIndexValue = index;
        // Update trigger state
        trigger.setAttribute("aria-expanded", "true");
        trigger.dataset.state = "open";
        // Show content
        content.hidden = false;
        content.dataset.state = "open";
        // Set motion direction for animation
        if (this.previousIndex !== -1 && this.previousIndex !== index) {
            content.dataset.motion = this.previousIndex < index ? "from-end" : "from-start";
        }
        else {
            content.dataset.motion = "from-start";
        }
        // Update viewport
        if (this.hasViewportTarget) {
            this.viewportTarget.hidden = false;
            this.viewportTarget.dataset.state = "open";
            this.viewportTarget.innerHTML = content.innerHTML;
            this.positionViewport(item);
        }
        this.isOpen = true;
        // Add keydown event listener (click outside is handled by stimulus-use)
        document.addEventListener("keydown", this.boundHandleKeydown);
    }
    closeItem(index) {
        if (index < 0 || index >= this.itemTargets.length)
            return;
        const item = this.itemTargets[index];
        const trigger = item.querySelector("[data-shadcn--navigation-menu-target='trigger']");
        const content = item.querySelector("[data-shadcn--navigation-menu-target='content']");
        if (trigger) {
            trigger.setAttribute("aria-expanded", "false");
            trigger.dataset.state = "closed";
        }
        if (content) {
            content.dataset.state = "closed";
            content.dataset.motion = this.previousIndex < index ? "to-end" : "to-start";
            setTimeout(() => {
                if (content.dataset.state === "closed") {
                    content.hidden = true;
                }
            }, 150);
        }
    }
    closeAll() {
        this.triggerTargets.forEach((trigger) => {
            trigger.setAttribute("aria-expanded", "false");
            trigger.dataset.state = "closed";
        });
        this.contentTargets.forEach((content) => {
            content.dataset.state = "closed";
            setTimeout(() => {
                if (content.dataset.state === "closed") {
                    content.hidden = true;
                }
            }, 150);
        });
        if (this.hasViewportTarget) {
            this.viewportTarget.dataset.state = "closed";
            setTimeout(() => {
                if (this.viewportTarget.dataset.state === "closed") {
                    this.viewportTarget.hidden = true;
                    this.viewportTarget.innerHTML = "";
                }
            }, 150);
        }
        this.openIndexValue = -1;
        this.previousIndex = -1;
        this.isOpen = false;
        this.wasClickOpened = false;
        // Remove keydown listener (click outside is handled by stimulus-use)
        document.removeEventListener("keydown", this.boundHandleKeydown);
    }
    // Called by stimulus-use when clicking outside the element
    clickOutside(event) {
        if (this.isOpen) {
            this.closeAll();
        }
    }
    handleKeydown(event) {
        switch (event.key) {
            case "Escape":
                this.closeAll();
                if (this.openIndexValue >= 0) {
                    this.triggerTargets[this.openIndexValue]?.focus();
                }
                break;
            case "ArrowRight":
                event.preventDefault();
                this.navigateToNextItem();
                break;
            case "ArrowLeft":
                event.preventDefault();
                this.navigateToPreviousItem();
                break;
        }
    }
    navigateToNextItem() {
        const nextIndex = (this.openIndexValue + 1) % this.itemTargets.length;
        this.openItem(nextIndex);
        const trigger = this.itemTargets[nextIndex].querySelector("[data-shadcn--navigation-menu-target='trigger']");
        trigger?.focus();
    }
    navigateToPreviousItem() {
        const prevIndex = this.openIndexValue <= 0 ? this.itemTargets.length - 1 : this.openIndexValue - 1;
        this.openItem(prevIndex);
        const trigger = this.itemTargets[prevIndex].querySelector("[data-shadcn--navigation-menu-target='trigger']");
        trigger?.focus();
    }
    clearTimers() {
        if (this.openTimer) {
            clearTimeout(this.openTimer);
            this.openTimer = null;
        }
        if (this.closeTimer) {
            clearTimeout(this.closeTimer);
            this.closeTimer = null;
        }
    }
    positionViewport(item) {
        if (!this.hasViewportTarget)
            return;
        const content = item.querySelector("[data-shadcn--navigation-menu-target='content']");
        if (content) {
            // Set CSS custom properties for width/height based on content
            const rect = content.getBoundingClientRect();
            this.viewportTarget.style.setProperty("--radix-navigation-menu-viewport-width", `${rect.width}px`);
            this.viewportTarget.style.setProperty("--radix-navigation-menu-viewport-height", `${rect.height}px`);
        }
    }
}
//# sourceMappingURL=navigation_menu_controller.js.map