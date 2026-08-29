import { Controller } from "@hotwired/stimulus";
/**
 * Accordion controller for collapsible sections
 * Supports single and multiple expansion modes
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        type: {
            type: StringConstructor;
            default: string;
        };
        collapsible: {
            type: BooleanConstructor;
            default: boolean;
        };
        default: {
            type: StringConstructor;
            default: string;
        };
    };
    connect(): void;
    toggle(event: ShadcnEvent): void;
    expandItem(item: HTMLElement): void;
    collapseItem(item: HTMLElement): void;
    findItemByValue(value: string): any;
    handleKeydown(event: ShadcnEvent): void;
}
//# sourceMappingURL=accordion_controller.d.ts.map