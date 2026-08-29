import { Controller } from "@hotwired/stimulus";
/**
 * Drawer Controller
 * Handles opening/closing drawer panels with swipe support
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        open: {
            type: BooleanConstructor;
            default: boolean;
        };
        direction: {
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
    removePortal(): void;
    openValueChanged(): void;
}
//# sourceMappingURL=drawer_controller.d.ts.map