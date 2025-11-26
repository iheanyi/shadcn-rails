import { Controller } from "@hotwired/stimulus";

/**
 * Switch Controller
 * Handles toggle switch with hidden input sync for form submission
 */
export default class SwitchController extends Controller {
  static targets: ["button", "thumb", "input"];
  static values: {
    checked: { type: "Boolean"; default: false };
  };

  /** Switch button target */
  readonly buttonTarget: HTMLButtonElement;
  readonly hasButtonTarget: boolean;

  /** Switch thumb target */
  readonly thumbTarget: HTMLElement;
  readonly hasThumbTarget: boolean;

  /** Hidden input target */
  readonly inputTarget: HTMLInputElement;
  readonly hasInputTarget: boolean;

  /** Whether the switch is checked */
  checkedValue: boolean;
  readonly hasCheckedValue: boolean;

  /** Toggle the switch */
  toggle(): void;

  /** Handle keyboard events (Space, Enter) */
  handleKeydown(event: KeyboardEvent): void;

  /** Update visual state */
  updateVisuals(): void;

  /** Sync hidden input value */
  syncInput(): void;

  /** Dispatch change event */
  dispatchChange(): void;

  /** Called when checkedValue changes */
  checkedValueChanged(): void;
}
