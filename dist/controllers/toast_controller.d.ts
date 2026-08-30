import { Controller } from "@hotwired/stimulus";
/**
 * Toast controller for notification toasts
 */
export default class extends Controller<HTMLElement> {
    static values: {
        duration: {
            type: NumberConstructor;
            default: number;
        };
        open: {
            type: BooleanConstructor;
            default: boolean;
        };
    };
    connect(): void;
    disconnect(): void;
    close(): void;
    startDismissTimer(): void;
    clearDismissTimer(): void;
    pause(): void;
    resume(): void;
    prefersReducedMotion(): boolean;
}
//# sourceMappingURL=toast_controller.d.ts.map