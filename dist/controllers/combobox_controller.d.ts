import { Controller } from "@hotwired/stimulus";
/**
 * Combobox controller for searchable select dropdown
 * Handles open/close, filtering, keyboard navigation, and item selection
 * Uses Floating UI for smart positioning and stimulus-use for utilities
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        open: {
            type: BooleanConstructor;
            default: boolean;
        };
        value: {
            type: StringConstructor;
            default: string;
        };
        selectedIndex: {
            type: NumberConstructor;
            default: number;
        };
        debounceWait: {
            type: NumberConstructor;
            default: number;
        };
        placement: {
            type: StringConstructor;
            default: string;
        };
    };
    static debounces: string[];
    connect(): void;
    disconnect(): void;
    cleanupPositioning(): void;
    toggle(): void;
    open(): void;
    close(): void;
    /**
     * Filter items based on input value
     */
    filter(): void;
    /**
     * Select an item
     */
    select(event: ShadcnEvent): void;
    /**
     * Handle keyboard navigation
     */
    handleKeydown(event: ShadcnEvent): void;
    /**
     * Update visual selection state
     */
    updateSelection(): void;
    /**
     * Get all visible items
     */
    getVisibleItems(): any;
    clickOutside(event: ShadcnEvent): void;
}
//# sourceMappingURL=combobox_controller.d.ts.map