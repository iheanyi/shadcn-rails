import { Controller } from "@hotwired/stimulus";
/**
 * Sheet controller for slide-out panels
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
    };
    connect(): void;
    disconnect(): void;
    open(): void;
    close(): void;
    toggle(): void;
    handleKeydown(event: ShadcnEvent): void;
    focusFirstElement(): void;
    trapFocus(event: ShadcnEvent): void;
}
//# sourceMappingURL=sheet_controller.d.ts.map