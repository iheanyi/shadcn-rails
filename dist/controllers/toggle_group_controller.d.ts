import { Controller } from "@hotwired/stimulus";
/**
 * Toggle Group Controller
 * Handles single or multiple selection of toggle items
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        type: {
            type: StringConstructor;
            default: string;
        };
        value: {
            type: StringConstructor;
            default: string;
        };
    };
    connect(): void;
    toggle(event: ShadcnEvent): void;
    getValues(): any;
    updateStates(): void;
    updateInput(): void;
    valueValueChanged(): void;
}
//# sourceMappingURL=toggle_group_controller.d.ts.map