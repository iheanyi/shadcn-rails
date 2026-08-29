import { Controller } from "@hotwired/stimulus";
/**
 * Popover controller for rich content overlays
 * Uses Floating UI for smart positioning and stimulus-use for click outside detection
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        open: {
            type: BooleanConstructor;
            default: boolean;
        };
        side: {
            type: StringConstructor;
            default: string;
        };
        align: {
            type: StringConstructor;
            default: string;
        };
        modal: {
            type: BooleanConstructor;
            default: boolean;
        };
    };
    connect(): void;
    disconnect(): void;
    cleanupPositioning(): void;
    get placement(): string;
    toggle(event: ShadcnEvent): void;
    show(): void;
    hide(): void;
    close(): void;
    clickOutside(event: ShadcnEvent): void;
}
//# sourceMappingURL=popover_controller.d.ts.map