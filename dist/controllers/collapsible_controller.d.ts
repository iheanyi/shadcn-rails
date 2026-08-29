import { Controller } from "@hotwired/stimulus";
/**
 * Collapsible controller for expandable content
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        open: {
            type: BooleanConstructor;
            default: boolean;
        };
        disabled: {
            type: BooleanConstructor;
            default: boolean;
        };
    };
    connect(): void;
    toggle(): void;
    open(): void;
    close(): void;
    updateState(): void;
    openValueChanged(): void;
}
//# sourceMappingURL=collapsible_controller.d.ts.map