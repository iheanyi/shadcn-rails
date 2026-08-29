import { Controller } from "@hotwired/stimulus";
/**
 * Tooltip controller for contextual information
 * Uses Floating UI for smart positioning
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        side: {
            type: StringConstructor;
            default: string;
        };
        align: {
            type: StringConstructor;
            default: string;
        };
        delay: {
            type: NumberConstructor;
            default: number;
        };
        skipDelay: {
            type: NumberConstructor;
            default: number;
        };
    };
    connect(): void;
    disconnect(): void;
    cleanupPositioning(): void;
    get placement(): string;
    show(): void;
    hide(): void;
    clearTimeouts(): void;
}
//# sourceMappingURL=tooltip_controller.d.ts.map