import { Controller } from "@hotwired/stimulus";
/**
 * Slider Controller
 *
 * Handles slider value selection with drag and keyboard support
 *
 * Targets:
 * - track: The slider track
 * - range: The filled range portion
 * - thumb: The draggable thumb
 * - input: Hidden input for form submission
 * - output: Optional element to display the current value (auto-synced)
 *
 * Values:
 * - min: Minimum value
 * - max: Maximum value
 * - step: Step increment
 * - value: Current value
 * - name: Input name
 * - disabled: Whether slider is disabled
 * - outputFormat: Format string for output (use {value} for value, {percent} for percentage)
 *
 * Data attributes for native <input type="range">:
 * - data-output-target: ID of element to display value (one-way: slider → output)
 * - data-output-format: Format string with {value} and {percent} placeholders
 * - data-input-target: ID of input element for two-way binding (slider ↔ input)
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        min: {
            type: NumberConstructor;
            default: number;
        };
        max: {
            type: NumberConstructor;
            default: number;
        };
        step: {
            type: NumberConstructor;
            default: number;
        };
        value: {
            type: NumberConstructor;
            default: number;
        };
        name: StringConstructor;
        disabled: {
            type: BooleanConstructor;
            default: boolean;
        };
        outputFormat: {
            type: StringConstructor;
            default: string;
        };
    };
    connect(): void;
    disconnect(): void;
    /**
     * Set up two-way bindings for native range inputs with data-input-target
     */
    setupTwoWayBindings(): void;
    /**
     * Set up two-way binding for a single range input
     * @param {HTMLInputElement} rangeInput - The range input element
     */
    setupBindingForInput(rangeInput: HTMLInputElement): void;
    /**
     * Clean up event listeners when disconnecting
     */
    teardownTwoWayBindings(): void;
    /**
     * Handle changes from a linked input element (input → slider sync)
     * @param {HTMLInputElement} rangeInput - The range input to update
     * @param {Event} event - The input/change event from the linked input
     */
    handleLinkedInputChange(rangeInput: HTMLInputElement, event: Event): void;
    startDrag(event: ShadcnEvent): void;
    handleDrag(event: ShadcnEvent): void;
    stopDrag(): void;
    handleKeydown(event: ShadcnEvent): void;
    snapToStep(value: number): number;
    updateVisuals(): void;
    updateOutput(): void;
    dispatchChange(): void;
    get percentage(): number;
    valueValueChanged(): void;
    /**
     * Update style for native input range element
     * Called on input event from native <input type="range">
     * Updates CSS custom property for fill and syncs output element
     */
    updateStyle(event: ShadcnEvent): void;
}
//# sourceMappingURL=slider_controller.d.ts.map