import { Controller } from "@hotwired/stimulus";
/**
 * Command Dialog controller for command palette in modal
 * Extends dialog functionality with keyboard shortcut support
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        open: {
            type: BooleanConstructor;
            default: boolean;
        };
        shortcut: {
            type: StringConstructor;
            default: string;
        };
    };
    connect(): void;
    disconnect(): void;
    /**
     * Handle global keyboard shortcut (e.g., Cmd+K)
     */
    handleShortcut(event: ShadcnEvent): void;
    open(): void;
    close(): void;
    toggle(): void;
    handleKeydown(event: ShadcnEvent): void;
    focusInput(): void;
    openValueChanged(): void;
}
//# sourceMappingURL=command_dialog_controller.d.ts.map