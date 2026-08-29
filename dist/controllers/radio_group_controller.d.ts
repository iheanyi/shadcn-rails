import { Controller } from "@hotwired/stimulus";
/**
 * Radio Group Controller
 *
 * Handles radio group selection with keyboard navigation
 *
 * Targets:
 * - item: Individual radio buttons
 * - indicator: Visual indicator element
 *
 * Values:
 * - name: Input name for form submission
 * - value: Currently selected value
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        name: StringConstructor;
        value: StringConstructor;
    };
    connect(): void;
    select(event: ShadcnEvent): void;
    handleKeydown(event: ShadcnEvent): void;
    updateSelection(): void;
    dispatchChange(value: string): void;
    get enabledItems(): any;
    valueValueChanged(): void;
}
//# sourceMappingURL=radio_group_controller.d.ts.map