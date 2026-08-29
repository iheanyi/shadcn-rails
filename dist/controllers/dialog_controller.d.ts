import { Controller } from "@hotwired/stimulus";
/**
 * Dialog controller for modal dialogs
 * Handles opening, closing, focus trapping, and keyboard navigation
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        open: {
            type: BooleanConstructor;
            default: boolean;
        };
        modal: {
            type: BooleanConstructor;
            default: boolean;
        };
    };
    connect(): void;
    disconnect(): void;
    open(): void;
    close(): void;
    toggle(): void;
    handleKeydown(event: ShadcnEvent): void;
    handleClickOutside(event: ShadcnEvent): void;
    focusFirstElement(): void;
    trapFocus(event: ShadcnEvent): void;
    openValueChanged(): void;
}
//# sourceMappingURL=dialog_controller.d.ts.map