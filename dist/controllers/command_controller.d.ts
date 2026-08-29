import { Controller } from "@hotwired/stimulus";
/**
 * Command controller for command palette functionality
 * Handles filtering, keyboard navigation, and item selection
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        selectedIndex: {
            type: NumberConstructor;
            default: number;
        };
        debounceWait: {
            type: NumberConstructor;
            default: number;
        };
    };
    static debounces: string[];
    connect(): void;
    /**
     * Filter items based on input value
     */
    filter(): void;
    /**
     * Handle keyboard navigation
     */
    handleKeydown(event: ShadcnEvent): void;
    /**
     * Select an item via click
     */
    select(event: ShadcnEvent): void;
    /**
     * Handle item selection
     */
    selectItem(item: HTMLElement): void;
    /**
     * Update visual selection state
     */
    updateSelection(): void;
    /**
     * Get all visible (non-hidden, non-disabled) items
     */
    getVisibleItems(): any;
    /**
     * Focus the input when connecting
     */
    focusInput(): void;
}
//# sourceMappingURL=command_controller.d.ts.map