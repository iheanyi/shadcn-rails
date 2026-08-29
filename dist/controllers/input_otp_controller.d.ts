import { Controller } from "@hotwired/stimulus";
/**
 * Stimulus controller for the Input OTP component
 * Handles multi-slot OTP input with keyboard navigation
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        length: {
            type: NumberConstructor;
            default: number;
        };
        pattern: {
            type: StringConstructor;
            default: string;
        };
        disabled: {
            type: BooleanConstructor;
            default: boolean;
        };
    };
    connect(): void;
    handleInput(event: ShadcnEvent): void;
    handleKeydown(event: ShadcnEvent): void;
    handleFocus(event: ShadcnEvent): void;
    handleBlur(event: ShadcnEvent): void;
    handlePaste(event: ShadcnEvent): void;
    focusSlot(event: ShadcnEvent): void;
    focusInput(index: number): void;
    findNextEmptySlot(startIndex: number): number;
    updateHiddenInput({ dispatch }?: {
        dispatch?: boolean | undefined;
    }): void;
    updateCarets(): void;
    get value(): any;
    get isComplete(): boolean;
    clear(): void;
}
//# sourceMappingURL=input_otp_controller.d.ts.map