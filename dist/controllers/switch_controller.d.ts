import { Controller } from "@hotwired/stimulus";
/**
 * Switch Controller
 *
 * Handles toggle switch with hidden input sync for form submission
 *
 * Targets:
 * - button: The visual switch button element
 * - thumb: The sliding thumb element
 * - input: Hidden checkbox input for form submission
 *
 * Values:
 * - checked: Boolean indicating current state
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        checked: {
            type: BooleanConstructor;
            default: boolean;
        };
    };
    connect(): void;
    toggle(): void;
    handleKeydown(event: ShadcnEvent): void;
    updateVisuals(): void;
    syncInput(): void;
    dispatchChange(): void;
    checkedValueChanged(): void;
}
//# sourceMappingURL=switch_controller.d.ts.map