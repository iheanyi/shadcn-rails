import { Controller } from "@hotwired/stimulus";
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
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        open: {
            type: BooleanConstructor;
            default: boolean;
        };
        hideDelay: {
            type: NumberConstructor;
            default: number;
        };
    };
    connect(): void;
    disconnect(): void;
    toggle(event: ShadcnEvent): void;
    show(event?: ShadcnEvent): void;
    hide(): void;
    close(): void;
    selectItem(event: ShadcnEvent): void;
    clickOutside(event: ShadcnEvent): void;
    handleKeydown(event: ShadcnEvent): void;
    focusNextItem(): void;
    focusPreviousItem(): void;
    focusFirstItem(): void;
    focusLastItem(): void;
    selectFocusedItem(): void;
    get enabledItems(): any;
    /**
     * Position the content element. Override in subclasses for custom positioning.
     * @param {Event} event - The event that triggered the show (optional)
     */
    positionContent(event?: ShadcnEvent): void;
    /**
     * Called after showing the menu. Override in subclasses for additional behavior.
     * @param {Event} event - The event that triggered the show (optional)
     */
    showMenu(event?: ShadcnEvent): void;
    /**
     * Called after hiding the menu. Override in subclasses for additional behavior.
     */
    hideMenu(): void;
    /**
     * Determine if the menu should close on click outside.
     * Override in subclasses for custom behavior (e.g., context menu).
     * @param {Event} event - The click event
     * @returns {boolean} - True if the menu should close
     */
    shouldCloseOnClickOutside(event: ShadcnEvent): boolean;
    addEventListeners(): void;
    removeEventListeners(): void;
    cancelHideTimeout(): void;
}
//# sourceMappingURL=base_menu_controller.d.ts.map