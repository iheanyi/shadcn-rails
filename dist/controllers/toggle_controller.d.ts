import { Controller } from "@hotwired/stimulus";
/**
 * Toggle Controller
 *
 * Handles toggle button state management
 *
 * Values:
 * - pressed: Boolean indicating if toggle is pressed
 */
export default class extends Controller<HTMLElement> {
    static values: {
        pressed: {
            type: BooleanConstructor;
            default: boolean;
        };
    };
    connect(): void;
    toggle(): void;
    updateState(): void;
    dispatchChange(): void;
    pressedValueChanged(): void;
}
//# sourceMappingURL=toggle_controller.d.ts.map