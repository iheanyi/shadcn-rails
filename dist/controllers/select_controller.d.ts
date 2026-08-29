import { Controller } from "@hotwired/stimulus";
/**
 * Select controller for custom select dropdowns
 * Uses Floating UI for smart positioning and stimulus-use for click outside detection
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        value: StringConstructor;
        placement: {
            type: StringConstructor;
            default: string;
        };
        sameWidth: {
            type: BooleanConstructor;
            default: boolean;
        };
    };
    connect(): void;
    disconnect(): void;
    cleanupPositioning(): void;
    toggle(event: ShadcnEvent): void;
    open(): void;
    close(): void;
    clickOutside(event: ShadcnEvent): void;
    select(event: ShadcnEvent): void;
    selectByValue(value: string, dispatch?: boolean): void;
    handleKeydown(event: ShadcnEvent): void;
    focusNextItem(): void;
    focusPreviousItem(): void;
    focusFirstItem(): void;
    focusLastItem(): void;
    selectFocusedItem(): void;
    get enabledItems(): any;
}
//# sourceMappingURL=select_controller.d.ts.map