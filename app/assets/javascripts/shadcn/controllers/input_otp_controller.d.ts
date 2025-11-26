import { Controller } from "@hotwired/stimulus";

export default class InputOtpController extends Controller {
  static targets: ["slot", "input", "hiddenInput", "caret"];
  static values: {
    length: { type: "Number"; default: 6 };
    pattern: { type: "String"; default: "" };
    disabled: { type: "Boolean"; default: false };
  };

  // Targets
  readonly slotTargets: HTMLElement[];
  readonly inputTargets: HTMLInputElement[];
  readonly hiddenInputTarget: HTMLInputElement;
  readonly caretTargets: HTMLElement[];
  readonly hasHiddenInputTarget: boolean;

  // Values
  lengthValue: number;
  patternValue: string;
  disabledValue: boolean;

  // Lifecycle
  connect(): void;

  // Event handlers
  handleInput(event: InputEvent): void;
  handleKeydown(event: KeyboardEvent): void;
  handleFocus(event: FocusEvent): void;
  handleBlur(event: FocusEvent): void;
  handlePaste(event: ClipboardEvent): void;
  focusSlot(event: Event): void;

  // Methods
  focusInput(index: number): void;
  findNextEmptySlot(startIndex: number): number;
  updateHiddenInput(): void;
  updateCarets(): void;
  clear(): void;

  // Getters
  readonly value: string;
  readonly isComplete: boolean;
}
