import { Controller } from "@hotwired/stimulus";
/**
 * Hover Card Controller
 * Handles showing/hiding content on hover with delays
 * Uses Floating UI for smart positioning
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        openDelay: {
            type: NumberConstructor;
            default: number;
        };
        closeDelay: {
            type: NumberConstructor;
            default: number;
        };
        side: {
            type: StringConstructor;
            default: string;
        };
        align: {
            type: StringConstructor;
            default: string;
        };
    };
    connect(): void;
    disconnect(): void;
    cleanupPositioning(): void;
    get placement(): string;
    scheduleOpen(): void;
    scheduleClose(): void;
    cancelClose(): void;
    clearTimeouts(): void;
    open(): void;
    close(): void;
}
//# sourceMappingURL=hover_card_controller.d.ts.map