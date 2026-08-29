import { Controller } from "@hotwired/stimulus";
/**
 * Checkbox controller for custom checkboxes
 */
export default class extends Controller<HTMLElement> {
    static values: {
        checked: {
            type: BooleanConstructor;
            default: boolean;
        };
        name: StringConstructor;
    };
    connect(): void;
    toggle(): void;
    updateState(): void;
    updateHiddenInput(): void;
    checkedValueChanged(): void;
}
//# sourceMappingURL=checkbox_controller.d.ts.map